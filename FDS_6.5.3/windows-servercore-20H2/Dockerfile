# escape=`

# Windows Server Core Image
FROM mcr.microsoft.com/windows/servercore:20H2

# provide setup-file
ARG setupfile=https://github.com/firemodels/fds/releases/download/FDS6.5.3/FDS_6.5.3-SMV_6.4.4_win64.exe

# set install- and downloaddir
ENV downloaddir="C:\download" installdir="C:\Program Files\firemodels\FDS"

# download FDS
ADD $setupfile $downloaddir\

# set path-environment
RUN setx path "%installdir%;%path%"

# Switch to PowerShell
SHELL ["powershell", "-command"]

# change setup-suffix from exe to zip, expand archive, copy files, install hydra-service and remove downloaddir
RUN Get-ChildItem $env:downloaddir\*.exe | Rename-Item -NewName { $_.Name -replace '.exe','.zip' }; `
	Expand-Archive -Force $env:downloaddir\*.zip $env:downloaddir; `
	Copy-Item -Path $env:downloaddir\bin -Destination $env:installdir -Recurse; `
	hydra_service2 -install; `
	Remove-Item –path $env:downloaddir -recurse;

# set workdir for fds-simulation
WORKDIR /workdir