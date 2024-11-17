# Zenstats
Zenstats is a Linux kernel driver for reading temperature, voltage(SVI2), current(SVI2) and power(SVI2) for AMD Zen family CPUs, now with Zen 3 support!

Make sure that your Linux kernel have support for your CPUs as Zenstats is using kernel function `amd_smn_read` to read values from SMN. A fallback method (which may or may not work!) will be used when it is detected that kernel function `amd_smn_read` lacks support for your CPU.
For AMD family 17h Model 70h (Ryzen 3000) CPUs you need kernel version 5.3.4 or newer or kernel with this patch: https://patchwork.kernel.org/patch/11043277/

## Installation
You can install this module via DKMS.

### Installation for Ubuntu
```sh
sudo apt install dkms git build-essential linux-headers-$(uname -r)
cd ~
git clone https://github.com/Ta180m/zenpower3.git
cd zenpower3
sudo make dkms-install
```

### Installation for Arch
You can install the [AUR package](https://aur.archlinux.org/packages/zenstats-dkms/).

## Module activation
Because zenpower is using same PCI device as k10temp, you have to disable k10temp first. This is automatically done by the AUR package.

1. Check if k10temp is active. `lsmod | grep k10temp`
2. Unload k10temp `sudo modprobe -r k10temp`
3. (optional*) blacklist k10temp: `sudo bash -c 'sudo echo -e "\n# replaced with zenstats\nblacklist k10temp" >> /etc/modprobe.d/blacklist.conf'`
4. Activate zenpower `sudo modprobe zenstats`

*If k10temp is not blacklisted, you may have to manually unload k10temp after each restart.

## Update instructions
1. Unload zenstats `sudo modprobe -r zenstats`
2. Goto zenstats directory `cd ~/zenstats`
3. Uninstall old version `sudo make dkms-uninstall`
4. Update code from git `git pull`
5. Install new version `sudo make dkms-install`
6. Activate zenstats `sudo modprobe zenstats`

## Help needed
It would be very helpful for me for further development of Zenstats if you can share debug data from zenstats. [Read more](https://github.com/ocerman/zenpower/issues/12)

## Notes
 - Some users reported that a restart is needed after module installation
 - If you are having trouble compiling zenstats under Ubuntu 18.04 (or older) with new upstream kernel, see [#23](https://github.com/ocerman/zenpower/issues/23)
 - The meaning of raw current values from SVI2 telemetry are not standardised so the current/power readings may not be accurate on all systems (depends on the board model).
