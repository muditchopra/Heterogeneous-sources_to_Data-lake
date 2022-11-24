#!/usr/bin/env sh
set -e

ls -lrt /opt
ls -lrt /usr/local/bin
ls -lrt /usr/bin
terraform --version
aws --version
dot -V
pytest --version
pylint --version
python --version
