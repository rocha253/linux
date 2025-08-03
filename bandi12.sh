#!/bin/bash
set -e

# Crear directorio temporal y moverse allí
TMPDIR=$(mktemp -d)
cd "$TMPDIR"

# Copiar archivo original
cp ~/data.txt .

# Revertir hexdump a binario
xxd -r data.txt data.bin

current="data.bin"
counter=0

while true; do
    file_output=$(file "$current")
    echo "[+] Tipo detectado: $file_output"

    # Incrementar contador para nombres únicos
    counter=$((counter + 1))
    next="temp_$counter"

    if echo "$file_output" | grep -q "gzip compressed"; then
        mv "$current" "$next.gz"
        gunzip "$next.gz"
        current="$next"
    elif echo "$file_output" | grep -q "bzip2 compressed"; then
        mv "$current" "$next.bz2"
        bunzip2 "$next.bz2"
        current="$next"
    elif echo "$file_output" | grep -q "POSIX tar archive"; then
        tar_dir="tar_out_$counter"
        mkdir "$tar_dir"
        tar -xf "$current" -C "$tar_dir"
        current=$(find "$tar_dir" -type f | head -n 1)
    else
        echo "[+] Archivo final encontrado: $current"
        echo "Contenido del archivo:"
        cat "$current"
        break
    fi
done
