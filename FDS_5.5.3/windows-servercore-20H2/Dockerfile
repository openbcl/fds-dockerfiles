# escape=`

# Windows Server Core Image
FROM mcr.microsoft.com/windows/servercore:20H2

# provide setup-file
ARG setupfile=https://github.com/firemodels/fds/releases/download/Git/FDS_5.5.3a-SMV_5.6_win64.exe

# set install- and downloaddir
ENV downloaddir="C:\download" installdir="C:\Program Files\firemodels\FDS"

# download FDS
ADD $setupfile $downloaddir\

# set path-environment
RUN setx path "%installdir%;%path%"

# Switch to PowerShell
SHELL ["powershell", "-command"]

# change setup-suffix from exe to zip, expand archive, copy files, rename fds5_win_64.exe and remove downloaddir
RUN Get-ChildItem $env:downloaddir\*.exe | Rename-Item -NewName { $_.Name -replace '.exe','.zip' }; `
	Expand-Archive -Force $env:downloaddir\*.zip $env:downloaddir; `
	ren $env:downloaddir\bin\fds5_win_64.exe $env:downloaddir\bin\fds.exe; `
	ren $env:downloaddir\bin\fds5_mpi_win_64.exe $env:downloaddir\bin\fds_mpi.exe; `
	Copy-Item -Path $env:downloaddir\bin -Destination $env:installdir -Recurse; `
	Remove-Item –path $env:downloaddir -recurse;

# set workdir for fds-simulation
WORKDIR /workdir