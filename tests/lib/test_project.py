import os
from unittest.mock import mock_open, patch

import pytest
from lib.project import Project


@pytest.fixture
def mock_yaml_data():
    return {
        'project': {
            'paths': {},
            'masks': {},
            'dirs': {},
            'other_elements': {},
            'properties': {},
            'connections': {}
        }
    }


@patch('builtins.open', new_callable=mock_open,
       read_data="project:\n  paths: {}\n  masks: {}\n  dirs: {}\n  other_elements: {}\n  properties: {}\n  connections: {}")
@patch('yaml.safe_load')
def test_project_init(mock_safe_load, mock_file, mock_yaml_data):
    mock_safe_load.return_value = mock_yaml_data
    base_dir = '/some/base/dir'
    project_config_filename = 'config.yaml'

    project = Project(base_dir, project_config_filename)

    assert project.base_dir == base_dir
    assert project.config_file == os.path.join(
        base_dir, project_config_filename)
    assert project.config == mock_yaml_data
    mock_file.assert_called_once_with(
        os.path.join(
            base_dir,
            project_config_filename),
        'r',
        encoding='utf-8')
    mock_safe_load.assert_called_once()
