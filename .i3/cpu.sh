#!/bin/sh
#mpstat | awk '$13 ~ /[0-9.]+/ { print 100 - $13"%" }'
mpstat | awk '$3 ~ /CPU/ { for(i=1;i<=NF;i++) { if ($i ~ /%idle/) field=i } } $3 ~ /all/ { print 100 - $field }'

