#!/bin/bash

USER=$(whoami)

if [$USER == "root"]
>&2 echo "Running the build commands as root initially can be dangerous"
$@
exit $?
fi

if [-x $(which sudo)]
sudo $@
fi

