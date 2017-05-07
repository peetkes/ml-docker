#!/bin/bash
OPTIND=1
while getopts ":n:i:" opt; do
  case "$opt" in
    n) NAME=$OPTARG ;;
    i) IMAGE=$OPTARG ;;
    \?) echo "Unrecognized option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

docker run -d --name=$NAME -p 8000-8002:8000-8002 -p 8040-8050:8040-8050 --cpus=4 --memory=4g -v ~/Development/docker-volumes/$NAME:/var/opt/MarkLogic $IMAGE
