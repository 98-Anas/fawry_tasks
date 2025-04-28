#!/bin/bash

# Function to display help information
function show_help() {
    echo "Usage: $0 [OPTIONS] PATTERN [FILE]"
    echo "Search for PATTERN in FILE (case-insensitive)"
    echo "Options:"
    echo "  -n  show line numbers"
    echo "  -v  invert match (show non-matching lines)"
    echo "  -h  show this help"
    exit 0
}

# Function to handle errors
function handle_error() {
    echo "Error: $1" >&2
    echo "Usage: $0 [OPTIONS] PATTERN [FILE]" >&2
    exit 1
}

# Function to process the input file/stream
function process_input() {
    local line_num=0
    
    while IFS= read -r line; do
        ((line_num++))
        
        if [[ "${line,,}" == *"${pattern,,}"* ]]; then
            match_found=1
        else
            match_found=0
        fi
        
        if ((invert_match)); then
            if ((!match_found)); then
                print_line "$line_num" "$line"
            fi
        else
            if ((match_found)); then
                print_line "$line_num" "$line"
            fi
        fi
    done < "$input_source"
}

# Function to print lines with optional line numbers
function print_line() {
    local num=$1
    local line=$2
    
    if ((line_numbers)); then
        echo "$num:$line"
    else
        echo "$line"
    fi
}
