# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Improt et project-path -----------------------------------------------------
import os
import sys
sys.path.insert(0, os.path.abspath('../../playsafemetrics'))


# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'PlaySafeMetrics'
copyright = '2024, Jean-Jacques Carron'
author = 'Jean-Jacques Carron'
release = '1.0.0'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.viewcode',   # Facultatif : pour ajouter des liens vers le code source
    'sphinx.ext.napoleon',   # Facultatif : pour la compatibilité avec Google et NumPy docstrings
    'sphinx.ext.autosummary', # Facultatif : pour générer des résumés automatiques
    # Ajoutez ici d'autres extensions si nécessaire
]


templates_path = ['_templates']
exclude_patterns = []



# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_static_path = ['_static']
