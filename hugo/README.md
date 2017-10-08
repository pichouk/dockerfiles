# Hugo

Docker image for a simple use of Hugo.

## Usage
To run Hugo command on a folder, simply run this Docker image by mouting the folder on `/code`. For example, if you want to build a Hugo website :
```
docker run --rm -v $(pwd)/:/code MYIMAGE
```

A smart Bash alias can be :
```
alias hugo='docker run --rm -v $(pwd):/code IMAGE $1'
```
