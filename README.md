# **Custom Command Task - Mini Grep Command**  

## **📌 Overview**
`mygrep.sh` is a Bash script that mimics basic functionality of the grep command with support for case-insensitive searching and optional flags.
![image](https://github.com/user-attachments/assets/eca0da1e-8c71-4cb0-b646-444e3ef552f2)

---

## **🚀 Features**  
✔ **Case-insensitive search** (`hello` matches `HELLO`)  
✔ **Line numbers** (`-n` flag)  
✔ **Inverted match** (`-v` flag, prints non-matching lines)  
✔ **Combined flags** (`-nv` or `-vn` works like `-n -v`)  
✔ **Error handling** (missing file, missing pattern)  
✔ **Help menu** (`-h` or `--help`)  

---

## **📋 Usage**  
### **Basic Search**  
```bash
./mygrep.sh PATTERN [FILE]
```
**Example:**  
```bash
./mygrep.sh hello testfile.txt
```
**Output:**  
```
Hello world
HELLO AGAIN
```

### **Show Line Numbers (`-n`)**  
```bash
./mygrep.sh -n hello testfile.txt
```
**Output:**  
```
1:Hello world
4:HELLO AGAIN
```

### **Invert Match (`-v`)**  
```bash
./mygrep.sh -v hello testfile.txt
```
**Output:**  
```
This is a test
another test line
Don't match this line
Testing one two three
```

### **Combined Flags (`-nv` or `-vn`)**  
```bash
./mygrep.sh -vn hello testfile.txt
```
**Output:**  
```
2:This is a test
3:another test line
5:Don't match this line
6:Testing one two three
```

### **Help Menu (`-h` or `--help`)**  
```bash
./mygrep.sh -h
```
**Output:**  
```
Usage: ./mygrep.sh [OPTIONS] PATTERN [FILE]
Search for PATTERN in FILE (case-insensitive)

Options:
  -n         show line numbers
  -v         invert match (show non-matching lines)
  -h, --help show this help

Author:
  Written by [Anas Ayman Elgalad]
  GitHub: [https://github.com/98-Anas]
```

---

## **🧠 Reflective Section**  

### **1. Argument Handling**  
- The script uses a `while` loop with `case` statements to parse options (`-n`, `-v`, `-h`).  
- Combined flags (`-nv`) are split into individual options.  
- The first non-option argument is treated as the `PATTERN`, and the second as the `FILE`.  

### **2. Potential Improvements (Regex & More Flags)**  
To support **regex**, **case-sensitive search (`-i`)**, **count matches (`-c`)**, or **list files (`-l`)**, we could:  
- Use `grep -E` for regex instead of Bash pattern matching.  
- Add `-i` to toggle case sensitivity.  
- Add a counter for `-c` and print only the count.  
- For `-l`, track matching files in a multi-file search.  

### **3. Hardest Part to Implement**  
**Handling combined flags (`-nv`)** was tricky because:  
- Bash doesn’t natively split `-nv` into `-n -v`.  
- The solution involved checking each character in `-*` flags.  

---

## **🔧 Testing**  
### **Test File (`testfile.txt`)**  
```
Hello world
This is a test
another test line
HELLO AGAIN
Don't match this line
Testing one two three
```

### **Expected Outputs**  
| Command | Expected Output |
|---------|----------------|
| `./mygrep.sh hello testfile.txt` | `Hello world`<br>`HELLO AGAIN` |
| `./mygrep.sh -n hello testfile.txt` | `1:Hello world`<br>`4:HELLO AGAIN` |
| `./mygrep.sh -vn hello testfile.txt` | `2:This is a test`<br>`3:another test line`<br>`5:Don't match this line`<br>`6:Testing one two three` |
| `./mygrep.sh -v testfile.txt` | `Error: Missing search pattern` |

---

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

## **📜 License**  
This script is open-source and free to use. Modify and distribute as needed.  

**Author:** [Anas Ayman Elgalad](https://github.com/98-Anas)  

---

### **🎯 Final Notes**  
- The script mimics `grep`'s basic functionality.  
- Future improvements could include regex, multi-file search, and more flags.  
- Contributions are welcome! 🚀  

**Happy coding!** 💻🔍
