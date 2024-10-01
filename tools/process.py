"""
This script lists all Python processes currently running on the system
along with their CPU usage.

The script uses the `psutil` library to iterate over all processes and
filters out those with "python" in their name. The process ID, name,
and CPU usage percentage are displayed for each Python process found.

Usage:
    Run the script directly to list all Python processes.
"""

import psutil


def list_python_processes():
    """
    Lists all running Python processes along with their CPU usage.

    This function iterates over all processes on the system, checks if the
    process name contains 'python', and prints the process ID, name, and
    CPU usage percentage. It handles exceptions related to process access,
    including `NoSuchProcess`, `AccessDenied`, and `ZombieProcess`, by
    ignoring those processes.
    """
    print("Listing all Python processes with their CPU usage:")
    for proc in psutil.process_iter(['pid', 'name', 'cpu_percent']):
        try:
            if 'python' in proc.info['name'].lower():
                print(
                    f"Process ID: {proc.info['pid']}, name: {proc.info['name']}, "
                    f"CPU Usage: {proc.info['cpu_percent']}%")
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass


if __name__ == "__main__":
    list_python_processes()
