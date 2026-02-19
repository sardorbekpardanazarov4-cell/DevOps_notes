#!/bin/bash
function logging()
 {
  MESSAGE=$@
  SET_MESSAGE="Random Number is:$MESSAGE"
  echo "$SET_MESSAGE"
  logger -i -p user.info "$SET_MESSAGE"
 }
logging $RANDOM
logging $RANDOM
logging $RANDOM
Run and check log
[root@vimukthi Test]# ./exe18.sh
Random Number is:22009
Random Number is:25546
Random Number is:29800
[root@vimukthi Test]# cat /var/log/messages | tail -n5
Jan 10 11:20:01 vimukthi systemd: Removed slice User Slice of root.
Jan 10 11:20:01 vimukthi systemd: Stopping User Slice of root.
Jan 10 11:20:03 vimukthi vimukthi[6210]: Random Number is:22009
Jan 10 11:20:03 vimukthi vimukthi[6211]: Random Number is:25546
Jan 10 11:20:03 vimukthi vimukthi[6212]: Random Number is:29800
