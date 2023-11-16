# Docker on Windows Subsystem for Linux (WSL)

If you do not already have WSL installed, see [Install Linux on Windows with WSL](https://docs.microsoft.com/en-us/windows/wsl/install) for instructions.

This document describes how to configure WSL 2, install recent version of Ubuntu (22.04 LTS), and install Docker as well as Docker compose.

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

If you already have recent version of Ubuntu installed, ensure that it uses WSL 2 by running `wsl --list --verbose`. If necessary, use `wsl --set-version` to update your instance to use WSL 2. Skip next section.

```pwsh
wsl --list --verbose
wsl --set-version "YOUR_DISTRO_HERE" 2
```

## Install recent version of Ubuntu

Install recent version of Ubuntu from either Microsoft Store or PowerShell. These instructions use Ubuntu 22.04. Other distributions might also work, if you know what you are doing.

If you want to install distro through the PowerShell, run `wsl --list --online` and follow the instructions.

```pwsh
wsl --list --online
wsl --install -d Ubuntu-22.04
```

If you want to install distro through Microsoft Store: Open Microsoft Store, search for `Ubuntu 22`, select _Ubuntu 22.04 LTS_, and click _Install_.

If not opened automatically, open the installed Ubuntu distro and follow instruction in installation wizard.

## Install Docker

Open Ubuntu you just installed and follow [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/) instructions.

__tl;dr:__ Run the convenience script available in `get.docker.com`:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Ignore the `WSL DETECTED: We recommend using Docker Desktop for Windows.` warning.

To be able to run docker commands without `sudo`, add current user to `docker` group with `usermod`. Note that you might have to logout and login for the changes to take effect.

```bash
sudo usermod -aG docker $USER
```

## Configure networking

By default, WSL 2 uses local DNS server to reflect network settings, such as VPN, from the host Windows to WSL instances. The IP address of this DNS server might fall into IP range used by the Dockers default bridge network. In that case, containers will not be able to resolve domains.

To configure working DNS inside containers you can either use public DNS or modify IP range used by Dockers default network. If you are working behind a corporate firewall, public DNS might not work.

### Use public DNS in WSL 2

To use public DNS, you must first disable WSL from automatically generating DNS settings to `/etc/resolv.conf`. To do this, add following rows to `/etc/wsl.conf` file in your WSL instance, for example, by editing (or creating) it with `sudo nano /etc/wsl.conf`:

```conf
[network]
generateResolvConf = false
```

For the changes to take effect, restart WSL by running `wsl --shutdown` in powershell and launching WSL instance again.

```pwsh
wsl --shutdown
```

Finally, configure DNS server manually by creating `/etc/resolv.conf` with following content, for example by opening it with `sudo nano /etc/resolv.conf`:

```conf
nameserver 8.8.8.8
```

### Configure IP range for Docker

To configure Docker to use IP ranges that wont overlap with DNS server configured by WSL, add following content to `/etc/docker/daemon.json`, for example, by opening it with `sudo nano /etc/docker/daemon.json`:

```json
{
  "bip": "172.21.0.1/16",
  "default-address-pools": [
    {
      "base":"172.22.0.0/16",
      "size":24
    }
  ]
}
```

If you already have dockerd running, you have to restart it for the changes to take effect.

```bash
sudo service docker restart
```

If containers cannot resolve domains with above configuration, ensure that the above networks do not overlap with the DNS server configured by WSL by running `ipconfig` in powershell and checking the networks it outputs.

## Start Docker daemon

Start `dockerd` as a background process by using `service` or, alternatively, start `dockerd` directly.

```bash
sudo service docker start
```

Note that this must be done every time WSL is restarted. If `docker` commands print `Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?` error, run `sudo service docker status` command to check if `dockerd` is running and, if necessary, run `sudo service docker start` command again.

If you are working on Windows 11, you can use [boot settings](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#boot-settings) to start Docker daemon automatically on WSL instance startup. To do this, add following rows to `/etc/wsl.conf` file in your WSL instance, for example, by editing (or creating) it with `sudo nano /etc/wsl.conf`.

```conf
[boot]
command = service docker start
```

## Install Docker compose

Follow [Install Docker Compose](https://docs.docker.com/compose/install/) instructions for Linux.

__tl;dr:__ Install Docker Compose with the distros package manager:

```bash
sudo apt-get update
sudo apt-get install docker-compose-plugin
```
