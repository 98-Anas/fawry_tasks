# **Fawry Tasks**  

# Task(1) mygrep.sh - A Simple Pattern Matching Script

## Overview
`mygrep.sh` is a Bash script that searches for patterns in files or standard input. It provides basic functionality similar to the `grep` command, with support for case-insensitive matching and some common options.
![image](https://github.com/user-attachments/assets/687473fb-0c49-4635-93ac-74d46af5cb09)

## Features
- Search for patterns in files or standard input
- Case-insensitive pattern matching
- Option to display line numbers with matches
- Option to invert matches (show non-matching lines)

## Usage
```
./mygrep.sh [OPTIONS] PATTERN [FILE]
```
![Implementation.png](https://github.com/98-Anas/fawry_tasks/blob/main/Implementation.png)
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

# Task(2) Troubleshooting Internal Web Dashboard Connectivity

## **Scenario**
Your internal web dashboard (hosted on `internal.example.com`) is suddenly unreachable from multiple systems. The service seems up, but users get “host not found” errors. You suspect a DNS or network misconfiguration. Your task is to troubleshoot, verify, and restore connectivity to the internal service.

## Initial Problems
- "host not found" errors when accessing internal.example.com
- Service appeared to be running normally
- Issue affected multiple systems

## Troubleshooting Process

### 1. DNS Resolution Verification

#### Current DNS Configuration:
```bash
cat /etc/resolv.conf
```
Output showed systemd-resolved stub resolver configuration pointing to 127.0.0.53.


#### DNS Server Status:
```bash
resolvectl status
```
Revealed active DNS servers: 163.121.128.134, 163.121.128.135, and 192.168.1.1


#### DNS Lookup Tests:
```bash
nslookup internal.example.com
nslookup internal.example.com 8.8.8.8
dig internal.example.com
dig @8.8.8.8 internal.example.com
```
All queries returned NXDOMAIN, indicating the domain couldn't be found in either internal or public DNS.

![step_1](https://github.com/user-attachments/assets/aecb266d-5424-41e7-ba60-dcd9b3a8e070)

![step_2](https://github.com/user-attachments/assets/429c4ce5-33df-484c-ad3c-7c4d4fb9188e)

![step_3](https://github.com/user-attachments/assets/fc808e02-2cec-48bb-81a7-4f4053cecb58)

### 2. Service Reachability Testing

#### HTTP/HTTPS Connection Attempts:
```bash
curl -v http://internal.example.com
curl -vk https://internal.example.com
```
Both failed with "Could not resolve host" errors.

#### TCP Connectivity Tests:
```bash
telnet internal.example.com 80
telnet internal.example.com 443
```
Failed with "could not resolve" errors.

### 3. Root Cause Analysis

The investigation revealed:
1. The internal domain `internal.example.com` was not properly registered in any DNS servers (both internal and public)
2. The system was configured to use DNS before checking local host files
3. No fallback mechanism existed for internal domain resolution

![step_4](https://github.com/user-attachments/assets/4c892ec8-9e3c-4cb4-b5fa-c0d4d41adbec)

### 4. Implemented Solutions

#### Solution 1: Modified Name Resolution Order
```bash
# Original configuration:
cat /etc/nsswitch.conf | grep hosts
# Output: hosts: files mdns4_minimal [NOTFOUND=return] dns

# Changed to:
sudo nano /etc/nsswitch.conf
# Modified line: hosts: files dns
```
This ensures the system checks /etc/hosts before attempting DNS resolution.

![step_5](https://github.com/user-attachments/assets/2445532d-257b-43be-b3cb-4a9dadc8ecc1)

#### Solution 2: Added Local Hosts Entry
```bash
echo "192.168.1.180 internal.example.com" | sudo tee -a /etc/hosts
```
Provided immediate resolution for the internal hostname.

#### Solution 3: Configured systemd-resolved
```bash
sudo nano /etc/systemd/resolved.conf
# Added:
# DNS=192.168.1.1
# Domains=example.com
sudo systemctl restart systemd-resolved
```
Ensured persistent DNS configuration for internal domains.

### Verification Steps

After implementing the fixes:
```bash
nslookup internal.example.com
```
Successfully resolved to 192.168.1.180

```bash
curl -v http://internal.example.com
```
Attempted connection to the correct IP, though the service was unreachable (separate network issue)

![step_6](https://github.com/user-attachments/assets/c79fe4d9-79b0-4699-9190-149451596e5b)

![step_7](https://github.com/user-attachments/assets/85a67ff9-3247-4571-b9bb-b8a20a7c05b0)

## Final Resolution

  Resolving the issue by those attempts:
1. Modifying name resolution order to check /etc/hosts first
2. Adding a static entry to /etc/hosts for immediate resolution
3. Configuring systemd-resolved to use the correct internal DNS server

## Lessons Learned

1. Internal domains must be properly registered in internal DNS servers
2. The resolution order in nsswitch.conf can impact connectivity
3. /etc/hosts provides a valuable troubleshooting tool and temporary solution
4. systemd-resolved configuration should be verified

## Recommended Actions 

1. Add proper DNS records for internal.example.com to the internal DNS servers
2. Consider implementing a local DNS caching resolver for better performance


![step_8](https://github.com/user-attachments/assets/2332e95d-3484-4d28-9d59-9a7c0a3c4775)

## Important Commands Used

```bash
# DNS troubleshooting:
nslookup, dig, resolvectl status

# Service connectivity:
curl, telnet

# Configuration files:
/etc/resolv.conf, /etc/nsswitch.conf, /etc/hosts, /etc/systemd/resolved.conf

# Service management:
systemctl restart systemd-resolved
```
## **License**  
This script is open-source and free to use. You are welcome to contribute.  

## Author
Written by Anas Ayman Elgalad 
