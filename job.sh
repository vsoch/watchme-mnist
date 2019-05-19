#!/bin/bash

# singularity-pull watcher is already created!

nproc=${1}
iter=${2}
name=${3}
output=${4}

# disable caching
export SINGULARITY_DISABLE_CACHE=yes

source /home/users/vsochat/.profile

cd ${SCRATCH}

# Add variables for host, cpu, etc.
export WATCHMEENV_HOSTNAME=$(hostname)
export WATCHMEENV_ACTUAL_NPROC=$(nproc)
export WATCHMEENV_SET_NPROC=${nproc}
export WATCHMEENV_MAXMEMORY=12

# Here we are going to run the model and record every 20 seconds. This should take 20-30 mins
watchme monitor --name $name-$iter --seconds 20 singularity run docker://vanessa/watchme-mnist ${output}.png > ${output}.json
