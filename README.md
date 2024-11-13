# Dot files and Operating system configuration

Setup currently is:
* Gentoo Linux
* Custom config for the X1
* Unified kernel image / EFI booting
* Secureboot with my own keys
* Systemd boot
* Systemd measured boot /TPM2 PCR validation
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

There are additional screenshots in the `misc/` directory.

### Window split indicator

Since I run all windows with no borders, it can be hard to recall what direction the window split is set to.   
Normally this is via a coloured window border to show direction either Horizontal or Vertical.   
I wrote a [Python script](https://github.com/brendanhoran/dotfiles-dotter/blob/main/my-scripts/sway_window_split_indicator.py) that can output to your bar and shows the next split direction as either `H` or `V`.    
It uses async event loops to subscribe to the `window::focus` and `binding` events from the sway IPC.   
![Split Indicator](https://raw.githubusercontent.com/brendanhoran/dotfiles-dotter/main/misc/window_split_indicator.png)

### Fixing delays in Greetd and XDG portals
If you have delays in the GTK greeter appearing on startup see the details in the file below.       
See the README in the [greetd-xdg-portal-fixes](https://raw.githubusercontent.com/brendanhoran/dotfiles-dotter/main/misc/greetd-xdg-portal-fixes/README.md) directory.    


## OS configs

Under the `os` package group you will find all the configurations I use to setup Gentoo on my Laptop that supports the above configuration.

## Dot files

Under the `user` package you will find all the dot files that I have configured to support my environment.

## Usage

To deploy the `user` group use `dotter deploy`.     
Using `-vv` to show details or `-d` for a dry-run.

To deploy the `os` group you must be root, since this configuration copies files to `/etc` and other locations.
In order to avoid removing/managing the symlinks handled by the `user` group you must use a different cache file.

Example:
```
dotter -d -l .dotter/base-os.toml --cache-file .dotter/base-os-cache.toml deploy
```
This results in a dry-run using a local config of `base-os.toml` and a separate cache file.

### Notes

For the `os` group I make use of dotter templates, since they preform a copy vs link.
See:
https://github.com/SuperCuber/dotter/issues/77

This is not the best way, but dotter is also not designed to manage operating systems.

## Misc
I also save:
* Current kernel config -- kernel-config-x.y
* Gentoo installed package list (world file) -- gentoo-package-set
* Greetd xdg portal fixes -- See above section about delays in greetd
* Screenshots of my desktop
