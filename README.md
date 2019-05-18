# Watchme Mnist

This is a [watchme](https://www.github.com/vsoch/watchme) repository that shows
how easy it is to monitor a task at some frequency using the [watchme monitor pid task](https://vsoch.github.io/watchme/watchers/psutils)
provided by the psutils set of tasks. Specifically, we are going to:

 1. Start with this [sklearn mnist example](https://scikit-learn.org/stable/auto_examples/neural_networks/plot_mnist_filters.html#sphx-glr-auto-examples-neural-networks-plot-mnist-filters-py)
 2. Build it into a container, the [Dockerfile](Dockerfile) here served at [vanessa/watchme-mnist](https://hub.docker.com/r/vanessa/watchme-mnist)
 3. Run the container on an HPC cluster with varying amounts of memory, for a training task that takes approximately 20 minutes.

And compare results!

## Scripts Included

This is a fairly simple analysis in that I could install [watchme](https://www.github.com/vsoch/watchme)
and then write a few quick scripts, run, and be done! 

 - [run_job.sh](run_job.sh) will submit job.sh to the cluster, specifying input parameters and outputs
 - [job.sh](job.sh) is submit to different nodes with varying memory, each 5 times


## Folders Included

 - [data](data) is where output data is written to, including json results files and images from the training.

## 1. Setup

Specifically, to install watchme:

```bash
$ pip install watchme[all]
```

You can also clone and install from the master branch directly:

```bash
$ git clone https://www.github.com/vsoch/watchme
cd watchme
pip install .[all] --user
```

And then I created a watcher folder (this repo).

```bash
$ watchme create watchme-mnist
```

We aren't going to be using .git as a temporal database, but it's still handy
to use watchme to create the repo for us :)

## 2. Mnist on the Sherlock Cluster

This was the script [job.sh](job.sh) submit via [run_job.sh](run_job.sh) and we
first export some variables to the environment to be added to our data:

```bash
# Add variables for host, cpu, etc.
export WATCHMEENV_HOSTNAME=$(hostname)
export WATCHMEENV_NPROC=$(nproc)
export WATCHMEENV_MAXMEMORY=${mem}
```

and the command to use watchme looks like this. We are going to run the model and record every 20 seconds. 
The output will be piped into a json file, and the script is given the name of a png file (in the
same directory) to save a plot to. This should take 20-30 mins.

```bash
watchme monitor --name $name-$iter --seconds 20 singularity run docker://vanessa/watchme-mnist ${output}.png > ${output}.json
```

The above command is submit in a simple loop in [run_job.sh](run_job.sh), notice how
we define iter, and mem based on the loops:

```bash
for iter in 1 2 3 4 5; do
    for mem in 4 6 8 12 16 18 24 32 64 128; do
        output="${outdir}/${name}-iter${iter}-${mem}gb"
        echo "sbatch --mem=${mem}GB job.sh ${mem} ${iter} ${name} ${output}"            
        sbatch --mem=${mem}GB job.sh "${mem}" "${iter}" "${name}" ${output}
    done
done
```

The results were each written directly to files in [data](data) (not using
git as a temporal database).
