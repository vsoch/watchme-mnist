#!/bin/bash

# pip install --user watchme[all]
watchme create mnist

# Adding watcher /home/users/vsochat/.watchme/singularity-pull...
# Generating watcher config /home/users/vsochat/.watchme/singularity-pull/watchme.cfg

# pull in advance
singularity pull docker://vanessa/watchme-mnist

# Next, here is an example of saving to flat files.
outdir=/home/users/vsochat/.watchme/mnist/data
mkdir -p ${outdir}

# name will be for cpu, to start
name="watchme-mnist-cpu"

# Next, we can run this on nodes with different memory. Since git doesn't
# do well with running in parallel, we will just save these files to the host,
# named based on the run.

for iter in 1 2 3 4 5; do
    for nproc in 1..32 ; do
        output="${outdir}/${name}-iter${iter}-proc${nproc}"
        echo "sbatch --mem=12GB job.sh ${nproc} ${iter} ${name} ${output}"            
        sbatch --partition owners --mem=12GB -n ${nproc} job.sh "${nproc}" "${iter}" "${name}" ${output}
    done
done

