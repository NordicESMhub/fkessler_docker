# fkessler docker

Docker container for running simple Fkessler case.


- Use [bioconda cesm docker](https://bioconda.github.io/recipes/cesm/README.html) as a base image.
- Input dataset available on zenodo: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3526193.svg)](https://doi.org/10.5281/zenodo.3526193)

## Running Fkessler with docker

Make sure inputdata is available (it won't download it as we suppose it is already on disk). 
- The location of the inputdata is `/opt/uio/inputdata` 
- Model outputs are stored in `/opt/uio/archive` along with the `case` folder (it can be interesting to check timing).

```
docker run -i -v /opt/uio/inputdata:/home/cesm/inputdata -v /opt/uio/archive:/home/cesm/archive  -t fkessler:latest
```
