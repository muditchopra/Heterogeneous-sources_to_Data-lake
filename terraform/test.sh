#!/usr/bin/env sh
set -e

terraform --version
aws --version
dot -V
pytest --version
pylint --version
cfn-lint --version
python --version
ls -lrt /opt
ls -lrt /usr/local/bin
ls -lrt /usr/bin