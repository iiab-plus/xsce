#!/bin/bash
# install livecd-tools
yum install livecd-tools

KSCFG=ks.cfg
BASE_ON= 
FSLABEL=F22-XSCE-LIVE
CACHE=/opt/schoolserver/yum-packages
LOG=xsce-spin.log

livecd-creator -c $KSCFG -f $FSLABEL --title $FSLABEL --product=Fedora --releasever=22 --cache=$CACHE 
#| tee -a $LOG

