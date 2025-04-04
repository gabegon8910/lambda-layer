# Lambda Layer Creator

This script automates the creation of an AWS Lambda layer containing one or more Python packages. It supports multiple Python versions and works across various operating systems, including Linux (Amazon Linux 2, Ubuntu, CentOS, etc.), macOS, and Windows (with a Bash environment).

## Features
- Creates a Lambda layer with specified Python packages.
- Supports any Python runtime version (e.g., 3.8, 3.10, 3.11) if available on your system or installable.
- Automatically installs the requested Python version if not present (with appropriate package managers).
- Warns if the uncompressed layer size exceeds AWS Lambda'"'"'s 250MB limit.
- Cross-platform compatibility: Linux, macOS, and Windows (via Git Bash, WSL, etc.).

## Requirements
- **Bash shell**: Available on Linux, macOS, or Windows (via Git Bash, WSL, MSYS2, or Cygwin).
- **Package Managers** (depending on OS):
  - **Linux**: `yum` (Amazon Linux), `apt` (Ubuntu/Debian), or `dnf` (CentOS/RHEL/Fedora).
  - **macOS**: Homebrew (`brew`).
  - **Windows**: Chocolatey (`choco`) for automated Python installation, or manual installation.
- **zip**: Required to create the layer archive (pre-installed on most systems; may need installation on Windows Bash environments).
- **AWS account**: With permissions to create and upload Lambda layers (for deployment).
- **sudo/admin privileges**: For installing Python if not already present.

## Usage

1. **Clone the Repository**:
```bash
git clone https://github.com/gabegon8910/lambda-layer.git
```
Navigate to the Directory:
bash

```bash
cd lambda-layer
```
Make the Script Executable (Linux/macOS):
```bash
chmod +x layers.sh
```
Run the Script:
``` 
./layers.sh
```
Enter the Lambda Layer Name:
```bash
Enter Lambda layer name: my-layer
```
Specify the Python Runtime Version:
```bash
Enter Python runtime version (e.g., 3.10): 3.10
```
    If the version isn’t installed, the script will attempt to install it (requires internet access and appropriate permissions).

Add Python Packages:

    Enter package names one at a time. Leave blank to finish:
```bash
    Enter Python package name (leave blank to finish): requests
    Enter Python package name (leave blank to finish): beautifulsoup4
    Enter Python package name (leave blank to finish):
```

Wait for Completion:

```
The script will:
        Install the specified Python version (if needed).
        Create a virtual environment.
        Install the requested packages.
        Package them into a Lambda-compatible ZIP file (my-layer.zip).
    If the uncompressed size exceeds 250MB, you’ll see a warning:
    text

WARNING: The uncompressed Lambda layer size (300MB) exceeds AWS Lambda'"'"'s 250MB limit.
        The layer may not work when uploaded to AWS Lambda.
    Upload to AWS Lambda:
        In the AWS Management Console, go to Lambda > Layers > Create Layer.
        Upload the generated ZIP file (e.g., my-layer.zip).
        Reference the layer in your Lambda function.
```
## Notes

python Version: The script is no longer limited to Python 3.8 or Amazon Linux 2. It supports any version available via your system’s package manager (e.g., 3.8, 3.9, 3.10, 3.11).
    Cross-Platform: Works on Linux (Amazon Linux, Ubuntu, CentOS, etc.), macOS (via Homebrew), and Windows (via Chocolatey or manual install in a Bash environment).
    Size Limit: AWS Lambda layers have a 250MB uncompressed size limit and a 50MB zipped size limit. The script warns about the uncompressed limit but doesn’t check the zipped size.
    Existing Layers: This script creates new layers. To update an existing layer, you’d need to manually merge packages or recreate it with all desired packages, as it doesn’t append to existing ZIP files.
    Windows Users: Ensure zip is available (install via choco install zip or similar if needed).

## Troubleshooting

    Python Installation Fails: Ensure you have the correct package manager installed and internet access. On unsupported systems, install Python manually first.
    Zip Command Not Found: Install zip (e.g., sudo apt install zip on Ubuntu, brew install zip on macOS).
    Permission Denied: Run with sudo if installing Python, or adjust permissions on the working directory.

## Contributing

Feel free to fork this repository, submit issues, or create pull requests to enhance functionality!

