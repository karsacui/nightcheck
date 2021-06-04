#!/bin/bash
curl http://night.netscape.cf/wgusers/ > wgusers.json
length=`jq '.|length' wgusers.json`

for i in $(seq 0 $(expr $length - 1))
do
serial_number=`jq ".[$i].serial_number" wgusers.json`
public_key=`jq --raw-output ".[$i].public_key" wgusers.json`
expire=`jq ".[$i].expire" wgusers.json`
if [ $expire == false ]; then
	if test -z "$(wg show wg1 | grep $public_key)"; then
		wg set wg1 peer $public_key allowed-ips 192.168.112.$serial_number
	fi
fi

if [ $expire == true ]; then
	if test ! -z "$(wg show wg1 | grep $public_key)"; then
		wg set wg1 peer $public_key remove
	fi      
fi
done
