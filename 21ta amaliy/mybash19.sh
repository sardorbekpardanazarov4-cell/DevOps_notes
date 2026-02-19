#!/bin/bash
MESSAGE="Random number is:$RANDOM"
echo "$MESSAGE"
logger -p user.info "$MESSAGE"
Run and check log
[root@vimukthi Test]# ./test.sh
Random number is:13461
[root@vimukthi Test]# cat /var/log/messages | tail -n1
Jan 10 11:03:18 vimukthi vimukthi: Random number is:13461

