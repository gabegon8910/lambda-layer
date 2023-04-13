# Lambda Layer Creator
This script automates the creation of a Lambda layer with one or more Python packages. The script uses Python 3.8 and Amazon Linux 2.

## Requirements
Bash shell
AWS account with permissions to create Lambda layers

## Usage
1. Clone this repository to your local machine:

``` bash
git clone https://github.com/gabegon8910/lambda-layer-creator.git
```
2. Navigate to the repository directory:

```bash
cd lambda-layer-creator
```
3. Run the script:

``` bash
bash create_layer.sh
```
4. Enter the name of the Lambda layer when prompted:
```bash 
Enter Lambda layer name: my-layer
```
5. Enter the name of the first Python package you want to include in the layer when prompted:

```
Enter Python package name (leave blank to finish): requests
```
6. If you want to include more Python packages in the layer, enter their names when prompted. To finish adding packages, leave the input blank:

```
Enter Python package name (leave blank to finish): beautifulsoup4
Enter Python package name (leave blank to finish):
```

7. Wait for the script to install the Python packages and create the Lambda layer. The script will create a ZIP file with the same name as the Lambda layer in the current directory.

8. In the AWS Management Console, navigate to the Lambda service and create a new Lambda layer. Upload the ZIP file created by the script and reference the layer in your Lambda function.

## Notes
If you need to add more Python packages to an existing Lambda layer, you can use the same script and enter the name of the existing layer when prompted. The script will add the new packages to the existing layer without overwriting the existing packages.
