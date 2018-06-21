#!/bin/bash
set -e

cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

grep -q 'updates.jenkins.io' /etc/hosts && echo || bash -c "echo '127.0.0.1 updates.jenkins.io' >> /etc/hosts"

if [[ -z "$@" ]]; then
	gosu jenkins /sbin/tini -- /usr/local/bin/jenkins.sh
else
	exec "$@"
fi
