#!/bin/sh

# Prompt the user for their name
echo "What's your name?"
read name

# Check if a name was provided
if [ -z "$name" ]; then
  # If no name was provided, use a default greeting
  greeting="Hello, stranger! Nice to meet you."
else
  # If a name was provided, use a personalized greeting
  greeting="Hello, $name! Nice to meet you."
fi

# Print the greeting
echo "$greeting"
