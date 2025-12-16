#!/bin/bash

COUNT=0
VAR=$1
for (( COUNT=0; $COUNT<"${#VAR}"; COUNT=${COUNT}+1 )) do
	echo "${VAR:${COUNT}:1}"
done | sort | uniq -c
