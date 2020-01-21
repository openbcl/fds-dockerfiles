# About [Dockerfiles for FDS (Github Repository)](https://github.com/openbcl/fds-dockerfiles)
[This repository](https://github.com/openbcl/fds-dockerfiles) provides Dockerfiles for building FDS-Docker-Images. Each indiviual dockerfile is provided under MIT-License. Nevertheless please consider that a container image (a file system that may include various copyrighted works) and the scripts to build these images (like a Dockerfile) are separate works. In general, the license of the included software is completely unrelated to the license of the build scripts.

| Used Software / Images   | License Source                                           |
| ------------------------ | -------------------------------------------------------- |
| Ubuntu                   | https://hub.docker.com/_/ubuntu                          |
| Windows Server Core      | https://hub.docker.com/_/microsoft-windows-servercore    |
| FDS                      | https://github.com/firemodels/fds/blob/master/LICENSE.md |

# About [this image (Docker Hub  Repository)](https://hub.docker.com/r/openbcl/fds)
[This image](https://hub.docker.com/r/openbcl/fds) provides by third party the [FDS binaries from the National Institute of Standards and Technology (NIST)](https://pages.nist.gov/fds-smv/) for Windows and Linux containers. You may use it on your own risk (for details please have a look at the disclaimer). At the moment the image is based on [Windows Server Core](https://hub.docker.com/_/microsoft-windows-servercore) and on [Ubuntu](https://hub.docker.com/_/ubuntu). Smokeview is not included. You may wish to [download Smokeview](https://pages.nist.gov/fds-smv/downloads.html) and install it on your hosts operating system by yourself.

## Supported tags
By pulling this image without a tag you will get the `latest` version of this image for your operating system. In most cases this will contain the latest version of FDS. Otherwise you may wait some time until this image got updated. If you prefer another version of FDS you should add the version as a tag like (`6.5.3`, `6.6.0`, ...).

The following table provides information about the basic runability of the fds executable for the corresponding guest operating system image. The table does not guarantee that your simulation job will run without any bugs or crashes. You should test your prefered version of this FDS-Docker-Image by yourself first!

| FDS-Version (Tag)   | Linux (Ubuntu 18.04) | Mac OS (with Hyperkit) | Windows Server Core (v. 1809/1903) <sup>\*1</sup> |
| ------------------- | :------------------- | :--------------------- | :------------------------------------------------ |
| 6.7.3, latest       | ✅                   | ✅                    | ✅                                               |
| 6.7.1               | ☑️ <sup>\*2</sup>    | ☑️ <sup>\*2</sup>     | ☑️ <sup>\*3</sup>                                |
| 6.7.0               | ✅                   | ❌                    | ✅                                               |
| 6.6.0               | ✅                   | ❌                    | ✅                                               |
| 6.5.3               | ☑️ <sup>\*2</sup>    | ☑️ <sup>\*2</sup>     | ✅                                               |

<sup>\*1</sup> Running with Hyper-V which is supported by Windows 10 Pro and Windows Server 2016. To improve performance it might be advisable to run the image in process isolation mode. This mode is the standard configuration of Windows Server 2016 and optional on Windows 10 Pro. Having said that process isolation mode for Windows 10 is meant for development/testing.

<sup>\*2</sup> Runs with warning (details on stackoverflow: [OpenMPI based on old hwloc doesn't support /proc/mount file having a line in it greater than 512 characters](https://stackoverflow.com/questions/46138549/docker-openmpi-and-unexpected-end-of-proc-mounts-line))

<sup>\*3</sup> `fds` command does not work as expected. You should use `fds_local` or `mpiexec` instead.

## How to use this image
Inside Terminal (Linux/Mac OS) or PowerShell (Windows) navigate to a project folder (containing a fds-input file) and choose between the following two modes to run FDS.

### Running FDS in interactive mode
If you like to run FDS inside an interactive shell run:
* on Windows Hostsystems: `docker run --rm -it -v ${pwd}:C:\workdir openbcl/fds`
* on Linux or Mac OS Hostsystems: `docker run --rm -it -v $(pwd):/workdir openbcl/fds`
* `--rm` will automatically remove the container when it exits
* `-it` instructs Docker to allocate a pseudo shell
* `-v` mounts the current working directory into the container
* To run fds type `fds <name-of-your-inputfile>.fds`

To close your container type `exit` after the simulation has finished

### Running FDS in non-interactive mode
If you like to run your FDS-Job directly inside your container with one command run:
* on Windows Hostsystems: `docker run --rm -v ${pwd}:C:\workdir openbcl/fds fds <name-of-your-inputfile>.fds`
* on Linux or Mac OS Hostsystems: `docker run --rm -v $(pwd):/workdir openbcl/fds fds <name-of-your-inputfile>.fds`

The container should be closed automatically after the job has been finished.

### Additional information
##### OMP_NUM_THREADS
Usually the setup routine of FDS will set a system environment variable called `OMP_NUM_THREADS`. This variable holds a number, representing the number of processor cores cut by half. OMP_NUM_THREADS has not been setted during the compilation of this image. Nevertheless FDS will use your machines number of processor cores by default. If you like to specify OMP_NUM_THREADS by yourself you might add `-e OMP_NUM_THREADS=<NR>` to previous run-command.

#### WINDOWS: [Isolation Modes](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/hyperv-container)
<blockquote>

*Windows containers offer two distinct modes of runtime isolation: process and Hyper-V isolation. Containers running under both isolation modes are created, managed, and function identically. They also produce and consume the same container images. The difference between the isolation modes is to what degree of isolation is created between the container, the host operating system, and all of the other containers running on that host.*

*Process Isolation: With process isolation, multiple container instances run concurrently on a given host with isolation provided through namespace, resource control, and process isolation technologies. When running in this mode, containers share the same kernel with the host as well as each other. This is approximately the same as how Linux containers run.*

*Hyper-V isolation: This isolation mode offers enhanced security and broader compatibility between host and container versions. With Hyper-V isolation, multiple container instances run concurrently on a host; However, each container runs inside of a highly optimized virtual machine and effectively gets its own kernel. The presence of the virtual machine provides hardware-level isolation between each container as well as the container host.*

*Windows containers running on Windows Server default to running with process isolation. Windows containers running on Windows 10 Pro and Enterprise default to running with Hyper-V isolation.*

*Warning: Running with process isolation on Windows 10 Pro and Enterprise is meant for development/testing. Your host must be running Windows 10 build 17763+ and you must have a Docker version with Engine 18.09 or newer. You should continue to use Windows Server as the host for production deployments. By using this feature on Windows 10 Pro and Enterprise, you must also ensure that your host and container version tags match, otherwise the container may fail to start or exhibit undefined behavior.*
</blockquote>

* To create a container with Hyper-V isolation thorough Docker, use the `--isolation` parameter to set `--isolation=hyperv`.
* To create a container with process isolation thorough Docker, use the `--isolation` parameter to set `--isolation=process`.

#### LINUX: ulimit stack size
[Sometimes FDS requires to increase the stack size to unlimited](https://github.com/firemodels/fds/issues/6265). To do so add `--ulimit stack=-1` to your run-command.

## DISCLAIMER
**THIS DOCKER IMAGE IS NOT ORIGINALLY PROVIDED BY NIST. THIS IS THIRD PARTY. WE MAKE NO WARRANTY OF ANY KIND, EXPRESS, IMPLIED, IN FACT OR ARISING BY OPERATION OF LAW, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT AND DATA ACCURACY. WE NEITHER REPRESENTS NOR WARRANTS THAT THE OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE, OR THAT ANY DEFECTS WILL BE CORRECTED. WE DO NOT WARRANT OR MAKE ANY REPRESENTATIONS REGARDING THE USE OF THE SOFTWARE OR THE RESULTS THEREOF, INCLUDING BUT NOT LIMITED TO THE CORRECTNESS, ACCURACY, RELIABILITY, OR USEFULNESS OF THE SOFTWARE.**

**This image is not intended to be used in any situation where a failure could cause risk of injury or damage to property.**

## [FDS-LICENSE](https://github.com/firemodels/fds/blob/master/LICENSE.md)
<blockquote>

*NIST-developed software is provided by NIST as a public service. You may use, copy and distribute copies of the software in any medium, provided that you keep intact this entire notice. You may improve, modify and create derivative works of the software or any portion of the software, and you may copy and distribute such modifications or works. Modified works should carry a notice stating that you changed the software and should note the date and nature of any such change. Please explicitly acknowledge the National Institute of Standards and Technology as the source of the software.*

*NIST-developed software is expressly provided “AS IS.” NIST MAKES NO WARRANTY OF ANY KIND, EXPRESS, IMPLIED, IN FACT OR ARISING BY OPERATION OF LAW, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT AND DATA ACCURACY. NIST NEITHER REPRESENTS NOR WARRANTS THAT THE OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE, OR THAT ANY DEFECTS WILL BE CORRECTED. NIST DOES NOT WARRANT OR MAKE ANY REPRESENTATIONS REGARDING THE USE OF THE SOFTWARE OR THE RESULTS THEREOF, INCLUDING BUT NOT LIMITED TO THE CORRECTNESS, ACCURACY, RELIABILITY, OR USEFULNESS OF THE SOFTWARE.*

*You are solely responsible for determining the appropriateness of using and distributing the software and you assume all risks associated with its use, including but not limited to the risks and costs of program errors, compliance with applicable laws, damage to or loss of data, programs or equipment, and the unavailability or interruption of operation. This software is not intended to be used in any situation where a failure could cause risk of injury or damage to property. The software developed by NIST employees is not subject to copyright protection within the United States.*
</blockquote>