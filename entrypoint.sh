#!/bin/bash
set -e

cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

if [[ -z "$@" ]]; then
	gosu jenkins /sbin/tini -- /usr/local/bin/jenkins.sh
else
	exec "$@"
fi
