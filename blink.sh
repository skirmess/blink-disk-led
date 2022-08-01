#!/usr/bin/sh

if [ -z "$1" ] || ! [ -e "$1" ]
then
	echo "usage: `basename -- "$0"` <raw disk device>"
	exit 1
fi

RAW_DISK=$1

trap cleanup 1 2 3 6
cleanup() {
	if [ -n $DD_PID ]
	then
		kill $DD_PID
	fi

	exit 0
}

dd if=$RAW_DISK of=/dev/null bs=1024k &
DD_PID=$!

while true
do
	sleep 0.7
	kill -TSTP $DD_PID
	sleep 0.7
	kill -CONT $DD_PID
done

