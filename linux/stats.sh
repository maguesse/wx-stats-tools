#!/usr/bin/env sh

OK=0
KO=1

TS=$(date +%Y%m%d-%H%M%S)


function usage() {
	cat <<EOF
Usage: ${0} <user> <interval>
EOF
}

function main() {
	local user=$1; shift
	local interval=$1; shift
	local _top=0
	local _vmstat=0
	local _iostat=0

	if command top -h &>/dev/null; then
		_top=1
	fi

	if command vmstat -V &>/dev/null; then
		_vmstat=1
	fi
	
	if command iostat -V &>/dev/null; then
		_iostat=1
	fi
	while true; do
		echo $(date "+%Y-%m-%d %H:%M:%S%z")
	if [ $_top -eq 1 ]; then
		top -b -u ${user} -n 1 >> top_${TS}.log
	fi
	if [ $_vmstat -eq 1 ]; then
		vmstat -t >> vmstat_${TS}.log
	fi
	if [ $_iostat -eq 1 ]; then
		S_TIME_FORMAT=ISO iostat -t >> iostat_${TS}.log
	fi
	sleep ${interval}
	done
}

if [ $# -lt 2 ]; then
	usage
	exit $KO
fi

main $*
