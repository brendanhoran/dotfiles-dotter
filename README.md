# Dot files and Operating system configuration

Setup currently is:
* Gentoo Linux
* Custom config for the X1
* Unified kernel image / EFI booting
* systemd boot
* Dracut
* LVM
* LUKS crypt volumes
* Sway window manager
* Wofi menu
* Mako notification handler
* Fish for my shell
* Waybar for my status bar
* Greetd and gtkgreet for my login handling

## Screenshot

As of March 2024 this is what the above looks like.
![desktop-screenshot-march-2024](https://github.com/brendanhoran/dotfiles-dotter/assets/3905013/e110ddd6-2732-4092-919f-5b9cd22395f1)


## OS configs

Under the `os` package group you will find all the configurations I use to setup Gentoo on my Laptop that supports the above configuration.

## Dot files

Under the `user` package you will find all the dot files that I have configured to support my environment.

## Usage

To deploy the `user` group use `dotter deploy`.     
Using `-vv` to show details or `-d` for a dry-run.

To deploy the `os` group you must be root, since this configuration copies files to `/etc` and other locations.
In order to avoid removing/manging the symlinks handled by the `user` group you must use a diffrent cache file.

Example:
```
dotter -d -l .dotter/base-os.toml --cache-file .dotter/base-os-cache.toml deploy
```
This results in a dry-run using a local config of `base-os.toml` and a seperate cache file.

### Notes

For the `os` group I make use of dotter templates, since they preform a copy vs link.
See:
https://github.com/SuperCuber/dotter/issues/77

This is not the best way, but dotter is also not designed to manage operating systems.

## Misc
You can find screen shots under the `misc/` directory.
I also save:
Current kernel config
Gentoo installed package list (world file)

