# fkessler docker

Docker container for running simple Fkessler case.


- Use [bioconda cesm docker](https://bioconda.github.io/recipes/cesm/README.html) as a base image.
- Input dataset available on zenodo: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3526193.svg)](https://doi.org/10.5281/zenodo.3526193)

## Running Fkessler with docker

Make sure inputdata is available (it won't download it as we suppose it is already on disk). 
- The location of the inputdata is `/opt/uio/inputdata` 
- Model outputs are stored in `/opt/uio/archive` along with the `cases` folder (it can be interesting to check timing).

**Important**: the folder /opt/uio/archive needs to be writable by unix group `users` (see Dockerfile) otherwise you will get a permission denied when running.

```
sudo chgrp -R users /opt/uio/archive
sudo chmod -R g+w /opt/uio/archive
```

You can check it:

```
ls -lrt /opt/uio | grep archive
```

You should have:

```
drwxrwxr-x.  8 centos users        4096 Nov  9 15:21 archive
```

### Pull the docker image locally

```
docker pull nordicesmhub/cesm_fkessler:latest
```

You can use the following command to check your image is locally available:

```
docker images
```

It should return:

```
REPOSITORY                   TAG                     IMAGE ID            CREATED             SIZE
nordicesmhub/cesm_fkessler   latest                  d4847f70444a        7 days ago          1.79GB
```

### Run the model

```
docker run -i -v /opt/uio/inputdata:/home/cesm/inputdata -v /opt/uio/archive:/home/cesm/archive  -t nordicesmhub/cesm_fkessler:latest
```

### Visualize outputs

The model outputs are in `/opt/uio/archive` (or any path you specify when running your model). Please note that this folder needs to exist before you run your model.
