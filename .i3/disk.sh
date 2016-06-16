#!/bin/sh
df -h / |awk '/[0-9.]+/ {print $5}'
