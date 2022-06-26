# Docker on Windows Subsystem for Linux (WSL)

If you do not already have WSL installed, see [Install Linux on Windows with WSL](https://docs.microsoft.com/en-us/windows/wsl/install) for instructions.

This document describes how to configure WSL 2, install recent version of Ubuntu (20.04 LTS), and install Docker as well as Docker compose.

## Configure WSL settings

Open PowerShell and check current WSL status by running `wsl --status`.

```pwsh
wsl --status
```

If default version is not 2, run `wsl --set-default-version 2`. This enables more recent, virtual machine based WSL, that is required for us to be able to run Docker daemon in the WSL.

```pwsh
wsl --set-default-version 2
```

If output indicates any problems with WSL 2 Kernel, such as `The WSL 2 kernel file is not found.`, run `wsl --update` and `wsl --shutdown`, as suggested. These command might require admin priviledges. To obtain these, find PowerShell, right click it, and select _Run as System Administrator_.

```pwsh
wsl --update
wsl --shutdown
```

Run `wsl --status` again. The output should display 2 as default version, recent last update date, and kernel version.

If you already have recent version of Ubuntu installed, ensure that it uses WSL 2 by running `wsl --list --verbose` and if necessary ``. In this case skip next section.

```pwsh
wsl --list --verbose
wsl --set-version "YOUR_DISTRO_HERE" 2
```

## Install recent version of Ubuntu

Install recent version of Ubuntu from either Microsoft Store or PowerShell. At the time of writing, Ubuntu 20.04 is easier to setup than more recent 22.04. Other distributions might also work, if you know what you are doing.

If you want to install distro through the PowerShell, run `wsl --list --online` and follow the instructions.

```pwsh
wsl --list --online
wsl --install -d Ubuntu-20.04
```

If you want to install distro through Microsoft Store: Open Microsoft Store, search for `Ubuntu 20`, select _Ubuntu 20.04 LTS_, and click _Install_.

If not opened automatically, open the installed Ubuntu distro and follow instruction in installation wizard.

## Install Docker

Open Ubuntu you just installed and follow [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) instructions.

__tl;dr:__ Run the convenience script available in `get.docker.com`:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Ignore the `WSL DETECTED: We recommend using Docker Desktop for Windows.` warning.

Start `dockerd` as a background process by using `service` or, alternatively, start `dockerd` directly.

```bash
sudo service docker start
```

To be able to run docker commands without `sudo` add current user to docker group with `usermod`. Note that you might have to logout and login for the changes to take effect.

```bash
sudo usermod -aG docker $USER
```

## Install Docker compose

Follow [Install Docker Compose](https://docs.docker.com/compose/install/) instructions for Linux.

__tl;dr:__ Install Docker Compose with the distros package manager:

```bash
sudo apt-get update
sudo apt-get install docker-compose docker-compose-plugin
```
