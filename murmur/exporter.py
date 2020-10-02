#!/usr/bin/python3
# coding=utf-8

"""Murmur prometheus exporter."""

# This script is adapted from another script developped by
# Stefan Hacker <dd0t@users.sourceforge.net> : https://github.com/Natenom/munin-plugins/tree/master/murmur

# Imports
import tempfile
import os
import sys
import signal
import time
import IcePy
import Ice
from prometheus_client import start_http_server, Gauge, REGISTRY, PROCESS_COLLECTOR, PLATFORM_COLLECTOR

# Path to Murmur.ice
# The script tries first to retrieve this file dynamically from Murmur itself
# If this fails it tries this file.
SLICE_FILE = "/usr/share/slice/Murmur.ice"
# Ice.MessageSizeMax from Murmur server
ICE_MESSAGE_SIZE_MAX = "65535"
# ICE connection variable
ICE_HOST = "127.0.0.1"
ICE_PORT = 6502
PROXY_STRING = "Meta -e 1.0:tcp -h %s -p %d -t 1000" % (ICE_HOST, ICE_PORT)

# Number of seconds between 2 metrics collection
COLLECT_INTERVAL = os.getenv('EXPORTER_COLLECT_INTERVAL', 10)

# Get server name
METRICS_SERVER_LABEL = os.getenv('METRICS_SERVER_LABEL')
if not METRICS_SERVER_LABEL:
    print('Must define METRICS_SERVER_LABEL environment variable !')
    sys.exit(1)

# Prepare ICE properties
ICE_PROPS = Ice.createProperties()
ICE_PROPS.setProperty("Ice.ImplicitContext", "Shared")
ICE_PROPS.setProperty("Ice.MessageSizeMax", str(ICE_MESSAGE_SIZE_MAX))
# Initialize ICE
IDATA = Ice.InitializationData()
IDATA.properties = ICE_PROPS
ice = Ice.initialize(IDATA)

###########################################################################################
###### This part is (almost) an entire copy of the original script to connect to ICE ######
####################### To be clear : I HAVE NO IDEA WHAT I'M DOING #######################
###########################################################################################

connection_done = False
while not connection_done:
    try:
        ice_proxy = ice.stringToProxy(PROXY_STRING)

        # Get slice directory
        slice_dir = Ice.getSliceDir()
        slice_dir = ['-I' + slice_dir]

        try:
            op = IcePy.Operation('getSlice', Ice.OperationMode.Idempotent, Ice.OperationMode.Idempotent,
                                 True, None, (), (), (), ((), IcePy._t_string, False, 0), ())

            slice = op.invoke(ice_proxy, ((), None))
            (dynslicefiledesc, dynslicefilepath) = tempfile.mkstemp(suffix='.ice')
            dynslicefile = os.fdopen(dynslicefiledesc, 'w')
            dynslicefile.write(slice)
            dynslicefile.flush()
            Ice.loadSlice('', slice_dir + [dynslicefilepath])
            dynslicefile.close()
            os.remove(dynslicefilepath)
        except Exception as e:
            try:
                Ice.loadSlice('', slice_dir + [SLICE_FILE])
            except:
                raise Ice.ConnectionRefusedException

        import Murmur

        # Check connection is working
        Murmur.MetaPrx.checkedCast(ice_proxy)
        connection_done = True

    except Ice.ConnectionRefusedException:
        print('Cannot connect exporter to ICE, retry in 5 seconds')
        time.sleep(5)

###########################################################################################
######################## End of the "NO IDEA WHAT I'M DOING PART" #########################
###########################################################################################

# Remove unwanted Prometheus metrics
[REGISTRY.unregister(c) for c in [PROCESS_COLLECTOR, PLATFORM_COLLECTOR,
                                  REGISTRY._names_to_collectors['python_gc_objects_collected_total']]]

# Start Prometheus exporter server
start_http_server(8000)

# Register metrics
users_all_gauge = Gauge('murmur_online_users_all', 'Number of online users', ['server'])
users_unregistered_gauge = Gauge('murmur_online_users_unregistered',
                                 'Number of online unregistered users', ['server'])
users_registered_gauge = Gauge('murmur_online_users_registered', 'Number of online registered users', ['server'])
users_muted_gauge = Gauge('murmur_online_users_muted', 'Number of online muted users', ['server'])
users_banned_gauge = Gauge('murmur_users_banned', 'Number of banned users', ['server'])
chan_count_gauge = Gauge('murmur_channels', 'Number of channels', ['server'])
uptime_gauge = Gauge('murmur_uptime', 'Number of seconds the server is uptime', ['server'])


def exit_handler(sig, frame):
    # Define handler for stop signals
    print('Terminating...')
    ice.destroy()
    sys.exit(0)


# Catch several signals
signal.signal(signal.SIGINT, exit_handler)
signal.signal(signal.SIGTERM, exit_handler)


# Loop forever
while True:
    # Get data from Murmur server
    meta = Murmur.MetaPrx.checkedCast(ice_proxy)
    server = meta.getServer(1)

    # Initialize metrics counters
    users_muted_count = 0
    users_unregistered_count = 0
    users_registered_count = 0

    # Collect and count users
    onlineusers = server.getUsers()
    for key in onlineusers.keys():
        # Count user as registered
        if onlineusers[key].userid == -1:
            users_unregistered_count += 1
        # Count user as not registered
        if onlineusers[key].userid > 0:
            users_registered_count += 1
        # Count muted users
        if onlineusers[key].mute or onlineusers[key].selfMute or onlineusers[key].suppress:
            users_muted_count += 1

    # Set metrics
    users_all_gauge.labels(server=METRICS_SERVER_LABEL).set(len(onlineusers))
    users_muted_gauge.labels(server=METRICS_SERVER_LABEL).set(users_muted_count)
    users_unregistered_gauge.labels(server=METRICS_SERVER_LABEL).set(users_unregistered_count)
    users_registered_gauge.labels(server=METRICS_SERVER_LABEL).set(users_registered_count)
    users_banned_gauge.labels(server=METRICS_SERVER_LABEL).set(len(server.getBans()))
    chan_count_gauge.labels(server=METRICS_SERVER_LABEL).set(len(server.getChannels()))
    uptime_gauge.labels(server=METRICS_SERVER_LABEL).set(meta.getUptime())

    # Wait beforce next metrics collection
    time.sleep(COLLECT_INTERVAL)
