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
