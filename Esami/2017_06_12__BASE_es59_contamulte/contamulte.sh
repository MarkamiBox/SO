#!/bin/bash

while read NOME COGNOME TOT GIORNO MESE ANNO; do
	if [[ -z $CONTA ]]; then
		CONTA="${TOT}"
	else
		CONTA="${CONTA}"$'\n'"${TOT}"	
	fi
done

echo "$CONTA" | uniq -c | awk '{ print $2, $1 }'

