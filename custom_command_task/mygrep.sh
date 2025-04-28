#!/bin/bash

# Function to display help information
function show_help() {
    echo "Usage: $0 [OPTIONS] PATTERN [FILE]"
    echo "Search for PATTERN in FILE (case-insensitive)"
    echo ""
    echo "Options:"
    echo "  -n         show line numbers"
    echo "  -v         invert match (show non-matching lines)"
    echo "  -h, --help show this help"
    echo ""
    echo "Author:"
    echo "  Written by [Anas Ayman Elgalad]"
    echo "  GitHub: [https://github.com/98-Anas]"
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

# Initialize variables
line_numbers=0
invert_match=0
pattern=""
filename=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n)
            line_numbers=1
            shift
            ;;
        -v)
            invert_match=1
            shift
            ;;
        -h|--help)
            show_help
            ;;
        -*)
            if [[ "$1" == *"n"* ]]; then
                line_numbers=1
            fi
            if [[ "$1" == *"v"* ]]; then
                invert_match=1
            fi
            shift
            ;;
        *)
            # First non-option argument is pattern
            if [[ -z "$pattern" ]]; then
                pattern="$1"
            # Second non-option argument is filename
            elif [[ -z "$filename" ]]; then
                filename="$1"
                # Check if the filename exists immediately
                if [[ ! -f "$filename" ]]; then
                    handle_error "File '$filename' not found"
                fi
            else
                handle_error "Too many arguments"
            fi
            shift
            ;;
    esac
done

# Validate input
if [[ -z "$pattern" ]]; then
    handle_error "Missing search pattern"
fi

# Set input source (file or stdin)
if [[ -n "$filename" ]]; then
    input_source="$filename"
else
    # If no filename provided but pattern might have been mistaken for filename
    if [[ -f "$pattern" ]]; then
        handle_error "Missing search pattern (did you mean to search in file '$pattern'?)"
    fi
    input_source="/dev/stdin"
fi

# Process the input
process_input