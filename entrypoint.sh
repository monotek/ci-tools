#!/bin/sh

set -e

if [ -n "${GPG_PUB_KEYS}" ]; then
  for KEY in ${GPG_PUB_KEYS}; do
    echo "Fetch ${KEY} from hkp://p80.pool.sks-keyservers.net:80"
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv ${KEY};

    if [ $? != 0 ]; then
      # Fallback if first fetch failed
      echo "Fallback: Fetch ${KEY} from hkp://ipv4.pool.sks-keyservers.net"
      gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv ${KEY};

      if [ $? != 0 ]; then
        # 2nd fallback
        echo "2nd fallback: Fetch ${KEY} from hkp://pgp.mit.edu:80"
        gpg --keyserver hkp://pgp.mit.edu:80 --recv ${KEY};
      fi
    fi
  done
fi

if [ -n "${1}" ]; then
  ${1}
else
  sh /data/commands.sh
fi
