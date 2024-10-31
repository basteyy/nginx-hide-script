#!/bin/bash

CONFIG_DIR="/etc/nginx/sites-enabled"
SNIPPET="include /etc/nginx/snippets/hide.conf;"

# Check for the '--all' parameter
PROCESS_ALL=false
if [ "$1" == "--all" ]; then
    PROCESS_ALL=true
fi

# Loop through each configuration file in the directory
for config_file in "$CONFIG_DIR"/*
do
    if [ -f "$config_file" ]; then
        # Variables to track server block positions
        in_server_block=false
        server_block_start=0
        line_number=0
        # Read the file line by line
        while IFS= read -r line || [ -n "$line" ]; do
            line_number=$((line_number + 1))
            # Detect the start of a server block
            if [[ $line =~ ^[ \t]*server[ \t]*\{ ]]; then
                in_server_block=true
                server_block_start=$line_number
            fi
            # If inside a server block, check for the end
            if [ "$in_server_block" = true ] && [[ $line =~ ^[ \t]*\} ]]; then
                server_block_end=$line_number
                # Extract the server block content
                server_block=$(sed -n "${server_block_start},${server_block_end}p" "$config_file")
                # Check if the snippet is already included
                if ! echo "$server_block" | grep -qF "$SNIPPET"; then
                    # Insert the snippet after the 'server {' line
                    insert_line=$((server_block_start + 1))
                    sed -i "${insert_line}i\\    $SNIPPET" "$config_file"
                    echo "Snippet added to $config_file in server block starting at line $server_block_start."
                    if [ "$PROCESS_ALL" = false ]; then
                        exit 0
                    fi
                fi
                in_server_block=false
            fi
        done < "$config_file"
    fi
done

echo "All server blocks already contain the snippet or no server blocks found."
