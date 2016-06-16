#!/bin/sh
#free -h | grep Mem | awk '{print $7}'
free -h | grep Mem | awk '{print $3}'
