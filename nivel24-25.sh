#!/bin/bash

bandit24=("contraseña del nivel actual")

for pin in {0000..9999}; do  # el nivel actual tiene un digito de 4 numeros ... XD 
	echo "$bandit24 $pin"
done | nc localhost 30002
