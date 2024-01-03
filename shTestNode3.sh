#!/bin/bash

filename="example_file.txt"

if [ -e "$filename" ]; then
    # If the file exists, print its content
    echo "File '$filename' exists. Content:"
    cat "$filename"
else
    # If the file doesn't exist, create it and write a default message
    echo "File '$filename' does not exist. Creating it..."
    echo "Hello, this is a default message." > "$filename"
    echo "File created."
fi
