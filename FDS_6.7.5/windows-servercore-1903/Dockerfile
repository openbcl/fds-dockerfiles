# escape=`

# Windows Server Core Image
FROM mcr.microsoft.com/windows/servercore:1903

# provide setup-file
ARG setupfile=https://github.com/firemodels/fds/releases/download/FDS6.7.5/FDS6.7.5_SMV6.7.15_win.exe

# set install-, download-, and mpidir
ENV downloaddir="C:\download" `
	installdir="C:\Program Files\firemodels\FDS" `
	mpidir="C:\Program Files\firemodels\FDS\mpi" 

# download FDS
ADD $setupfile $downloaddir\

# set path-environment
RUN setx path "%installdir%;%mpidir%;%path%"

# Switch to PowerShell
SHELL ["powershell", "-command"]

# change setup-suffix from exe to zip, expand archive, copy files, install hydra-service and remove downloaddir
RUN Get-ChildItem $env:downloaddir\*.exe | Rename-Item -NewName { $_.Name -replace '.exe','.zip' }; `
	Expand-Archive -Force $env:downloaddir\*.zip $env:downloaddir; `
	Copy-Item -Path $env:downloaddir\firemodels\FDS*\bin -Destination $env:installdir -Recurse; `
	hydra_service -install; `
	Remove-Item –path $env:downloaddir -recurse;

# set workdir for fds-simulation
WORKDIR C:\workdir