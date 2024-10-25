# Creating the translated markdown content for the user
translated_content = """
# 🛠️ User Guide for the `setup_python_env.ps1` Script

This PowerShell script automatically sets up a Python virtual environment, extracts it from an archive, and configures the necessary aliases and functions in the PowerShell profile to simplify its use.

## 📋 Usage

### 1. Parameter
The script accepts an optional parameter:
- **`WorkDirectory`**: Path to the working directory where the environment will be created (default: `C:\\Work`).

### 2. Script Features

- **Creation of the working directory**:
   If the directory specified in the `WorkDirectory` parameter does not exist, it will be created.

- **Checking for the existence of `myenv`**:
   If the virtual environment `myenv` is not already present in the working directory, the script:
   - Copies a ZIP file named `myenv.zip` from a network path.
   - Unzips the file into the working directory.

- **Updating the PowerShell profile**:
   The script modifies the `Microsoft.PowerShell_profile.ps1` file to add useful aliases and functions:
   - Alias `venv`: Allows activating the virtual environment.
   - Function `pytest`: Simplifies running tests with Pytest.
   - Function `pip`: Makes using `pip` with Python easier.

- **Updating the PowerShell ISE profile**:
   If the file `Microsoft.PowerShellISE_profile.ps1` does not exist, it is created and configured to automatically load the main PowerShell profile.

- **Executing the profile**:
   The PowerShell profile is reloaded to apply the changes immediately.

## 🏃‍♂️ Running the script

1. Open PowerShell.
2. Run the script, optionally specifying the working directory, default is `c:\Work`:
   ```
   .\setup_python_env.ps1  
   .\setup_python_env.ps1 [-WorkDirectory "my_venv_path"]
