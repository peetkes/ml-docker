#!/bin/bash
OPTIND=1
while getopts ":n:" opt; do
  case "$opt" in
    n) NAME=$OPTARG ;;
    \?) echo "Unrecognized option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

docker stop $NAME
