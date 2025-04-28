# **Fawry Tasks**  

# Task(1) mygrep.sh - A Simple Pattern Matching Script

## Overview
`mygrep.sh` is a Bash script that searches for patterns in files or standard input. It provides basic functionality similar to the `grep` command, with support for case-insensitive matching and some common options.

![Implementation.png](https://github.com/98-Anas/fawry_tasks/blob/main/Implementation.png)

## Features
- Search for patterns in files or standard input
- Case-insensitive pattern matching
- Option to display line numbers with matches
- Option to invert matches (show non-matching lines)

## Usage
```
./mygrep.sh [OPTIONS] PATTERN [FILE]
```

### Options
- `-n` : Show line numbers with matching lines
- `-v` : Invert match (show lines that don't contain the pattern)
- `-h` : Show help information

## **📥 Installation**  
1. **Clone the repository**  
   ```bash
   git clone https://github.com/98-Anas/fawry_tasks.git
   cd fawry_tasks/custom_command_tasks
   ```
2. **Make the script executable**  
   ```bash
   chmod +x mygrep.sh
   ```
3. **Run it**  
   ```bash
   ./mygrep.sh hello testfile.txt
   ```

---

### Examples
1. Search for "error" in a file:
   ```
   ./mygrep.sh error logfile.txt
   ```

2. Search with line numbers:
   ```
   ./mygrep.sh -n warning messages.log
   ```

3. Search for lines that don't contain "success":
   ```
   ./mygrep.sh -v success results.txt
   ```

4. Read from standard input:
   ```
   cat data.txt | ./mygrep.sh important
   ```

## Error Handling
The script handles several error cases:
- Missing search pattern
- File not found
- Too many arguments
- Invalid options
- Missing arguments for options

When errors occur, the script displays a helpful message and exits with an appropriate error code.

## Challenges and Solutions
- **Pattern Matching**: The script performs case-insensitive matching by converting both the line and pattern to lowercase before comparison.
  
- **Input Handling**: The script can accept input either from a file or standard input, requiring careful handling of different input sources.

- **Option Parsing**: The script uses `getopts` to handle command-line options, including combinations like `-vn` or `-nv`.

- **Error Management**: Different error conditions are handled with specific error codes and messages to help users understand what went wrong.

## Technical Notes
1. **Argument Processing**: The script first checks for `--help`, then processes options with `getopts`, and finally validates the remaining arguments.

2. **Extending Functionality**: To support regular expressions or additional options like `-i`, `-c`, or `-l`, the script would need:
   - Modified pattern matching to use regex instead of simple substring search
   - Additional option handling in the `getopts` loop
   - New functions to implement counting or filename-only output

3. **Implementation Challenges**: The most difficult part was handling both file input and standard input correctly while maintaining all the error checking. This required careful ordering of the argument validation steps.

## **License**  
This script is open-source and free to use. You are welcome to contribut.  

## Author
Written by Anas Ayman Elgalad  
