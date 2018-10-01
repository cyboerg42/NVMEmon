#!/bin/bash
#Peter Kowalsky - 01.10.2018
#NVME Monitoring (smartctl) -> InfluxDB
#Usage : ./NVMEmon.sh NVME_DRIVE -> ./NVMEmon.sh nvme0n1

HOSTNAME=$(hostname)
INFLUX_DB_LOC="http://localhost:8086/write?db=opentsdb"
CURL_ARGS="-i -XPOST"

device="/dev/$1"
smart_output=$(/usr/sbin/smartctl -x "$device")

function gsmarti () {
	echo $(echo "$smart_output" | grep "$1" | cut -d':' -f2) | cut -d' ' -f1 | cut -d'%' -f1
}

data_read=$(gsmarti "Data Units Read:")
data_written=$(gsmarti "Data Units Written:")
sector_size=$(gsmarti "Namespace 1 Formatted LBA Size:")
power_cycles=$(gsmarti "Power Cycles: ")
power_on_hours=$(gsmarti "Power On Hours:")
temp=$(gsmarti "Temperature:")
crit_warn=$(gsmarti "Critical Warning:")
avail_spare=$(gsmarti "Available Spare:")
wear_level=$(gsmarti "Percentage Used:")
serial=$(gsmarti "Serial Number:")

data_read_bytes=$(( "${data_read//,}" * $sector_size ))
data_written_bytes=$(( "${data_written//,}" * $sector_size ))

curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device data_read=$data_read_bytes"
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device data_written=$data_written_bytes"
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device sector_size=$sector_size"
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device power_cycles=$power_cycles"
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device power_on_hours=$power_on_hours"
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device temp=$temp"
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device avial_spare=$avail_spare"
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device crit_warn=\"$crit_warn\""
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device wear_level=$wear_level"
curl $CURL_ARGS $INFLUX_DB_LOC --data-binary "NVMEmon,host=$HOSTNAME,drive=$device serial=\"$serial\""
