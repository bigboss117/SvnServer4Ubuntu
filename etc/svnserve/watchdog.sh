#!/bin/bash

tag="false"
ps aux | grep "svnserve -d -[r]" > /tmp/svnserve.tmp
while read line
do
  tag="ture"
done < /tmp/svnserve.tmp
rm -rf /tmp/svnserve.tmp

if [ $tag = "true" ]; then
  exit 0
fi

svnroot=""
while read line
do
  key=`echo "$line" | cut -d "=" -f 1`
  value=`echo "$line" | cut -d "=" -f 2`
  if [ "$key" = "SVNROOT" ]; then
    svnroot="$value"
  fi
done < /etc/svnserve/svnserve.conf
if [ $svnroot != "" ]; then
  svnserve -d -r "$svnroot"
fi
