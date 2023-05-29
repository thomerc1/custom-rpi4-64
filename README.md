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
├── staging<br>
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

pw: MiPi777

## Build tool locations

/home/linsus/Downloads/Workspace/custom_rpi4_64/host/bin/aarch64-buildroot-linux-gnu-gcc
/home/linsus/Downloads/Workspace/custom_rpi4_64/host/bin/aarch64-buildroot-linux-gnu-gdb

## Enable remote debugging

- Under Toolchain enable "Build cross gdb for the host"
- enable BR2_PACKAGE_GDB_SERVER
- `make clean`
- `make`
- Either flash image to target or copy gdbserver binary to /usr/bin

### Manual Remote GDB debugging of application (over ethernet)

- The application must be compiled with debug symbols enabled
  - Ex: `path_to_gcc/aarch64-buildroot-linux-gnu-gcc -g -o my_app my_app.c`
  - If not flashing the target with an entire image that includes the executable of my_app, copy the executable to the target device
- Copy the application to the target device
- _On target_: `gdbserver :1234 my_app`
- _On host_: `/home/linsus/Downloads/Workspace/custom_rpi4_64/host/bin/aarch64-buildroot-linux-gnu-gdb`
- _On host_: `target remote <rpi ip addr>:1234`
- _On host_: Add break points using `break my_app.c:<line_no>`

### VS Code Remote GDB debugging of application (over ethernet)

- The .vscode files within this project provide an example of the configuration needed to remote debug
- Start GDB server on target: `gdbserver :1234 my_app`
- Within VSCode, select: "view-->run"
- Select 'Remote GDB" from combobox
- Debug as normal using IDE
