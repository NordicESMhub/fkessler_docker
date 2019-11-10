# fkessler docker

Docker container for running simple Fkessler case.


- Use [bioconda cesm docker](https://bioconda.github.io/recipes/cesm/README.html) as a base image.
- Input dataset available on zenodo: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3526193.svg)](https://doi.org/10.5281/zenodo.3526193)

## Running Fkessler with docker

Make sure inputdata is available (it won't download it as we suppose it is already on disk). 
- The location of the inputdata is `/opt/uio/inputdata` 
- Model outputs are stored in `/opt/uio/archive` along with the `case` folder (it can be interesting to check timing).

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
```
### Run the model

```
docker run -i -v /opt/uio/inputdata:/home/cesm/inputdata -v /opt/uio/archive:/home/cesm/archive  -t fkessler:latest
```

### Visualize outputs

The model outputs are in `/opt/uio/archive` (or any path you specify when running your model). Please note that this folder needs to exist before you run your model.
