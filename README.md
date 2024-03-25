*[This image](https://hub.docker.com/r/openbcl/fds) is maintained by third party. It provides the [FDS binaries from the National Institute of Standards and Technology (NIST)](https://pages.nist.gov/fds-smv/) for Windows and Linux containers. The use of this image is at your own risk. At the moment the image is based on [Ubuntu](https://hub.docker.com/_/ubuntu). Smokeview is not included. You may want to [download Smokeview](https://pages.nist.gov/fds-smv/downloads.html) and install it on your hosts operating system by yourself.*

# Supported tags
By pulling this image without a tag you will get the `latest` version of FDS for your operating system. If you prefer another version of FDS you are free to add the version as a tag like (`5.5.3`, `6.5.3`, ...).

The following table provides information about the basic runability of fds containers for different operating systems.

| FDS-Version (Tag)   | Linux                | WSL 2 (Windows) / Hyperkit (Mac OS) <sup>\*1</sup>  |
| ------------------- | :------------------- | :-------------------------------------------------- |
| 6.9.0, latest       | ✅                   | ✅                                                 |
| 6.8.0               | ✅                   | ✅                                                 |
| 6.7.9               | ✅                   | ✅                                                 |
| 6.7.8               | ✅                   | ✅                                                 |
| 6.7.7               | ✅                   | ✅                                                 |
| 6.7.6               | ✅                   | ✅                                                 |
| 6.7.5               | ✅                   | ✅                                                 |
| 6.7.4               | ✅                   | ✅                                                 |
| 6.7.3               | ✅                   | ✅                                                 |
| 6.7.1               | ☑️ <sup>\*2</sup>    | ☑️ <sup>\*2</sup>                                  |
| 6.7.0               | ✅                   | ❌                                                 |
| 6.6.0               | ✅                   | ❌                                                 |
| 6.5.3               | ☑️ <sup>\*2</sup>    | ☑️ <sup>\*2</sup>                                  |
| 6.3.0               | ☑️ <sup>\*2</sup>    | ☑️ <sup>\*2</sup>                                  |
| 6.2.0               | ☑️ <sup>\*2</sup>    | ☑️ <sup>\*2</sup>                                  |
| 5.5.3               | ✅                   | ✅                                                 |

<sup>\*1</sup> Running with Docker Desktop based on Hyperkit (Mac OS) or WSL 2 (Windows) which are a lightweight virtualization solutions for Linux Docker containers.

<sup>\*2</sup> Running with [warning](https://stackoverflow.com/questions/46138549/docker-openmpi-and-unexpected-end-of-proc-mounts-line). This should not affect the functionality of FDS.

# How to use this image

To run the latest version of FDS (without doing simulation at all) please run the following command for testing purposes.
```bash
docker run --rm openbcl/fds fds
```
To run another version of FDS (e.g. 6.7.3) you have to append the corresponding tag to the image name.
```bash
docker run --rm openbcl/fds:6.7.3 fds
```

## Running FDS in non-interactive mode (recommended)
In order for FDS to access a simulation file within the Docker container you have to share a folder on your local file system with the container.
To do so navigate with your Terminal/Shell to a simulation folder (containing a .fds inputfile) and run one of the following commands depending on your host operating system and shell type.
*Please note: On Windows only local disks can currently be mounted as volumes. Therefore network drives or network paths cannot be mounted as volumes yet.*
```bash
# Linux / Mac OS
docker run --rm -v $(pwd):/workdir openbcl/fds fds <filename>.fds

# Windows PowerShell
docker run --rm -v ${pwd}:/workdir openbcl/fds fds <filename>.fds

# Windows Command Prompt
docker run --rm -v %cd%:/workdir openbcl/fds fds <filename>.fds
```

The execution of FDS via MPI is also supported.
The following lines of code are examples of commands for Linux host operating systems.
```bash
# FDS 6.2.0 and later
docker run --rm -v $(pwd):/workdir openbcl/fds mpiexec -n <meshcount> fds <filename>.fds

# FDS 5.5.3
docker run --rm -v $(pwd):/workdir openbcl/fds lamboot mpirun -np <meshcount> fds_mpi <filename>.fds
```

## Running FDS in interactive mode
If you like to run FDS inside an interactive shell run one of the following commands depending on your host operating system.
```bash
# Linux / Mac OS
docker run --rm -it -v $(pwd):/workdir openbcl/fds

# Windows PowerShell
docker run --rm -it -v ${pwd}:/workdir openbcl/fds

# Windows Command Prompt
docker run --rm -it -v %cd%:/workdir openbcl/fds
```

You will be connected to the interactive shell of your Docker container and have the possibility to start FDS in the usual way.

```bash
# FDS (without MPI)
fds <filename>.fds

# FDS 6.5.3 and later (with MPI)
mpiexec -n <meshcount> fds <filename>.fds

# FDS 5.5.3 (with MPI)
lamboot mpirun -np <meshcount> fds_mpi <filename>.fds
```

After your simulation has finished you are free to close the container via the `exit` command.

## Additional information
### OpenMP: OMP_NUM_THREADS
Usually the setup routine of FDS will set a system environment variable called `OMP_NUM_THREADS`.
This variable holds a value representing the number of processor cores cut by half. OMP_NUM_THREADS has not been setted during the compilation of this image.
Nevertheless FDS will use your machines number of processor cores by default. If you like to specify OMP_NUM_THREADS by yourself you might add `-e OMP_NUM_THREADS=<NR>` to the run-commands described above.
If you are running FDS together with MPI it makes sense to select the following setting: `-e OMP_NUM_THREADS=1` to disable OpenMP.
If you are running FDS version 6.7.8 (and later) or FDS version 5.5.3 OpenMP is disabled by default.

**For FDS version 6.7.8 (and later) you you have to replace `fds` with `fds_openmp` in your command if you want to run FDS together with OpenMP.**

## Known errors and possible solutions
### KILLED BY SIGNAL: 7: Error when using mpiexec
If you get an error like the following, you should increase the shared memory.
```bash
=========================================================
=   BAD TERMINATION OF ONE OF YOUR APPLICATION PROCESSES
=   RANK 0 PID 9 RUNNING AT bfc9e9b610a2
=   KILLED BY SIGNAL: 7 (Bus error)
=========================================================
```
To do so add `--shm-size=384M` to the `docker run` command described above.
This will increase the default shared memory of Docker (64MB) to 384MB.
Maybe you have to choose a higher value (depending on your simulation).

### LINUX: segmentation fault occurred
If you are running a Linux host operating system and get the following [error](https://github.com/firemodels/fds/issues/6265) you should set ulimit stack size to unlimited.
```bash
forrtl: severe (174): SIGSEGV, segmentation fault occurred
```
To do so add `--ulimit stack=-1` to the `docker run` command described above.

## DISCLAIMER
**THIS DOCKER IMAGE IS NOT ORIGINALLY PROVIDED BY NIST. THIS IS THIRD PARTY. WE MAKE NO WARRANTY OF ANY KIND, EXPRESS, IMPLIED, IN FACT OR ARISING BY OPERATION OF LAW, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT AND DATA ACCURACY. WE NEITHER REPRESENTS NOR WARRANTS THAT THE OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE, OR THAT ANY DEFECTS WILL BE CORRECTED. WE DO NOT WARRANT OR MAKE ANY REPRESENTATIONS REGARDING THE USE OF THE SOFTWARE OR THE RESULTS THEREOF, INCLUDING BUT NOT LIMITED TO THE CORRECTNESS, ACCURACY, RELIABILITY, OR USEFULNESS OF THE SOFTWARE.**

**This image is not intended to be used in any situation where a failure could cause risk of injury or damage to property.**