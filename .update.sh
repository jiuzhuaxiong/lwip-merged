#!/bin/bash

if [ -z "$1" ]; then
	echo "Need root dir!"
	exit 3
fi

#redirect output
exec > /tmp/merger.log
exec 2>&1

#move to root dir
cd $1
RES=$?
if [ $RES -ne 0 ]; then
	echo "Failed to find dir $1 !"
	exit 5
fi

#Read out inital HEAD
cd lwip
LWIP_PREREV=`git rev-parse HEAD`
cd ../contrib
CONTRIB_PREREV=`git rev-parse HEAD`
cd ..

#do the update
git pull --recurse-submodules

#Read out new HEAD
cd lwip
git rebase origin/master
LWIP_POSTREV=`git rev-parse HEAD`
cd ../contrib
git rebase origin/master
CONTRIB_POSTREV=`git rev-parse HEAD`
cd ..

MESSAGEFILE="/tmp/merger.$$"
CHANGE=

echo "New code from lwip project" > $MESSAGEFILE
echo "" >> $MESSAGEFILE

#read out logs and store if changed

if [ "$LWIP_PREREV" != "$LWIP_POSTREV" ]; then
	CHANGE=Yes
	echo "lwip repo:" >> $MESSAGEFILE
	cd lwip
	git log --pretty=format:"%h %s (%an)" $LWIP_PREREV..$LWIP_POSTREV >> $MESSAGEFILE
	cd ..
	echo "" >> $MESSAGEFILE
fi


if [ "$CONTRIB_PREREV" != "$CONTRIB_POSTREV" ]; then
	CHANGE=Yes
	echo "lwip-contrib repo:" >> $MESSAGEFILE
	cd contrib
	git log --pretty=format:"%h %s (%an)" $CONTRIB_PREREV..$CONTRIB_POSTREV >> $MESSAGEFILE
	cd ..
	echo "" >> $MESSAGEFILE
fi

#bail if no changes
if [ -z "$CHANGE" ]; then
	rm $MESSAGEFILE
	exit 0;
fi

#do the commit
git commit -a -F $MESSAGEFILE
COMMITRESULT=$?
if [ $COMMITRESULT -eq 0 ]; then
	# push if ok
	git push
fi

#clean up
rm $MESSAGEFILE
