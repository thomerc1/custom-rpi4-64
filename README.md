# Custom 64-bit Raspberry Pi 4 build

- This repository was created to follow the bootlin slides here: https://bootlin.com/doc/training/buildroot/buildroot-slides.pdf
  - These slides are the slides under the documentation section of the buildroot website

## Initial setup

- Download the buildroot repository from github
  - `git clone https://github.com/buildroot/buildroot.git`
- Checkout the desired version / branch
  - `git checkout -t remotes/origin/<branch>`
    - This repository is using branch 2023.02.x
- cd to project dir
- In buildroot, the configuration is saved to buildroot/.config or project_dir/.config in our instance because we will be building an out of tree build. Whenever a `make clean` is issued, the build directory will be removed. If issuing a `make distclean` command, the build directory and the .config file will be removed. To ensure the configuration is not lost, it is advised to start with a defconfig, save it to your project folder, and create a symbolic link to it within buildroot/configs. Then you may back it up by issuing `make savedefconfig` following all customizations and the changes will then be tracked within your project directory.
- Create a symbolic link within the buildroot/configs folder: <br>`ln -s /project_path/config/my_defconfig my_defconfig`
- Run: `make -C ../buildroot O=$(pwd) menuconfig` <br>
  - After running the previous command, a wrapper Makefile will be placed in the project directory and you can run: `make menuconfig` moving forward.
- Exit the menuconfig (no need to save anything)
- Make the defconfig:
  - `make my_defconfig`<br>
  - No need to specify full path here. It will call the config / symbolic link from the buildroot/configs dir
  - If you don't have a custom config, you may list the default configs using: `make list-defconfigs` or just view the contents of buildroot/configs
- Now you may update the .config using `make menuconfig`<br>
  - Multiple post build scripts may be run. The field in the config file is a space seperated list of post-build script paths
- After adding customizations via menuconfig (post-build scripts, patches, etc), select save and exit the menuconfig
- Back up the config by issuing: `make savedevconfig`.
- Build the project via: `make` from within the project directory

## Project directory structure

.<br>
├── build<br>
├── custom<br>
├── host<br>
├── images<br>
├── Makefile<br>
├── README.md<br>
└── target<br>

## Compare default configs

- TODO

## Add commit release version in build automatically

- see custom/post-build.sh

## Graphing dependancies

- TODO

## Flashing SD card

- lsblk to find sdcard device
- dd if=images/sdcard.img of=/dev/{device} status=progress conv=fsync
  - example device: mmcblk0

## After boot, test device is on network

nmap -sn 192.168.1.0/24

## System Configuration

pw: MiPi464
