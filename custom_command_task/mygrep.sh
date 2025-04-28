#!/bin/bash

# Function to display help information
function show_help() {
    echo "Usage: $0 [OPTIONS] PATTERN [FILE]"
    echo "Search for PATTERN in FILE (case-insensitive)"
    echo ""
    echo "Options:"
    echo "  -n         show line numbers"
    echo "  -v         invert match (show non-matching lines)"
    echo "  -h         show help"
    echo "Author:"
    echo "  Written by [Anas Ayman Elgalad]"
    echo "  GitHub: [https://github.com/98-Anas]"
    exit 0
}

# Function to handle errors with error codes
function handle_error() {
    local error_code=$1
    local message=$2
    
    case $error_code in
        1) echo "Error: Missing search pattern" >&2 ;;
        2) echo "Error: File '$message' not found" >&2 ;;
        3) echo "Error: Too many arguments" >&2 ;;
        4) echo "Error: Invalid option -$message" >&2 ;;
        5) echo "Error: Missing argument for option -$message" >&2 ;;
        6) echo "Error: Unknown option --$message" >&2 ;;
        *) echo "Error: $message" >&2 ;;
    esac
    
    echo "Try '$0 -h' for more information" >&2
    exit $error_code
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

# Check for --help before getopts
for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        show_help
    fi
done

# Parse options using getopts
while getopts ":nvh" opt; do
    case $opt in
        n) line_numbers=1 ;;
        v) invert_match=1 ;;
        h) show_help ;;
        :) handle_error 5 "$OPTARG" ;;
        \?) handle_error 4 "$OPTARG" ;;
    esac
done
shift $((OPTIND-1))

# Validate remaining arguments
if [[ $# -lt 1 ]]; then
    handle_error 1
fi

pattern="$1"
shift

if [[ $# -gt 0 ]]; then
    filename="$1"
    if [[ ! -f "$filename" ]]; then
        handle_error 2 "$filename"
    fi
    if [[ $# -gt 1 ]]; then
        handle_error 3
    fi
    input_source="$filename"
else
    if [[ -f "$pattern" ]]; then
        handle_error 1
    fi
    input_source="/dev/stdin"
fi

# Process the input
process_input