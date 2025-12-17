#!/bin/bash

INPUT_SPORCO=$(grep -B 1 --no-group-separator "OPERATIVI" lista.txt)
INPUT_PULITO=$(echo "$INPUT_SPORCO" | grep -v "OPERATIVI")

echo "$INPUT_PULITO" | while read MATRICOLA NOME COGNOME; do
	echo "${MATRICOLA}";
done
