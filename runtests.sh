#!/bin/bash

cd `dirname $0`

exitcode=0

box stop name="cfflowtests"
box start directory="./tests/" serverConfigFile="./tests/server-cfflowtests.json"
box testbox run verbose=false || exitcode=1
box stop name="cfflowtests"

exit $exitcode

