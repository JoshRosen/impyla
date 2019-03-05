# Copyright 2013 Cloudera Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import absolute_import

from setuptools import setup, find_packages, __version__ as setuptools_version
from pkg_resources import parse_version

# Minimum setuptools version which supports "environment markers";
# see https://stackoverflow.com/a/32643122/590203
MIN_SETUPTOOLS_VERSION = "20.8.1"

if parse_version(setuptools_version) < parse_version(MIN_SETUPTOOLS_VERSION):
    raise RuntimeError(
        "impyla requires setuptools {0} or newer".format(MIN_SETUPTOOLS_VERSION))

def readme():
    with open('README.md', 'r') as ip:
        return ip.read()

import versioneer  # noqa

setup(
    name='impyla',
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    description='Python client for the Impala distributed query engine',
    long_description=readme(),
    maintainer='Wes McKinney',
    maintainer_email='wes.mckinney@twosigma.com',
    author='Uri Laserson',
    author_email='laserson@cloudera.com',
    url='https://github.com/cloudera/impyla',
    packages=find_packages(),
    install_package_data=True,
    package_data={'impala.thrift': ['*.thrift']},
    install_requires=[
        'six',
        'bitarray',
        # Use 'thrift' on Python 2 and 'thriftpy' on Python 3:
        'thrift>=0.9.3;python_version<"3"',
        'thriftpy;python_version>="3"',
    ],
    keywords=('cloudera impala python hadoop sql hdfs mpp spark pydata '
              'pandas distributed db api pep 249 hive hiveserver2 hs2'),
    license='Apache License, Version 2.0',
    classifiers=[
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5'
    ],
    entry_points={
        'sqlalchemy.dialects': ['impala = impala.sqlalchemy:ImpalaDialect']},
    zip_safe=False)
