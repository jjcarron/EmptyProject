import os
import sys

# Assuming conftest.py is in the tests/ directory
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Add the project root to sys.path
sys.path.insert(0, PROJECT_ROOT)

