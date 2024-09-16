# Greetd login delay fix (GTK greeter)

After installing a XDG Desktop Portal , or installing applications that have it as a dependency (EG; flatpak)    
Greetd will have between a 5 and 7 second delay in launching the login greeter/window.    

## Why the delay?
Looking at the system journal you might see something similar to this:   
```
systemd[1376]: xdg-document-portal.service: Failed with result 'exit-code'.
systemd[1376]: xdg-document-portal.service: Main process exited, code=exited, status=2/INVALIDARGUMENT
dbus-daemon[1430]: [session uid=396 pid=1430 pidfd=5] Activating via systemd: service name='org.freedesktop.portal.Documents' unit='xdg-document-portal.service' requested by ':1.6' (uid=396 pid=1455 comm="/usr/libexec/xdg-desktop-portal")
systemd[1376]: Starting Portal service...
dbus-daemon[1430]: [session uid=396 pid=1430 pidfd=5] Activating via systemd: service name='org.freedesktop.portal.Desktop' unit='xdg-desktop-portal.service' requested by ':1.0' (uid=396 pid=1426 comm="gtkgreet -l -s /etc/greetd/gtkgreet.css")
```

So each user needs its own separate session owned process for the portal.   
Thus the systemd service gets started in per user in the `--user` context manager.   

Greetd runs as its own user, thus by default it gets its own portal process started, hence then fails due to not been an interactive user. Expected given its a service account.    

## The fix

To fix this, I created a home directory for the `greetd` user and masked the systemd units for XDG portal.    

Example entry in `/etc/passwd`:   
```
greetd:x:396:396:User for gui-libs/greetd:/var/lib/greetd/home:/sbin/nologin

```

This sets the home directory to `/var/lib/greetd/home`.    
I then create the following symlinks in the `/var/lib/greetd/home/.config/systemd/user` directory. You will need to create this diretory or you can become the greetd user and use systemdctl command.   

My symlinks:
```
/var/lib/greetd/home/.config/systemd/user # ls -la
lrwxrwxrwx 1 greetd greetd    9 Aug 31 19:55 at-spi-dbus-bus.service -> /dev/null
lrwxrwxrwx 1 greetd greetd    9 Aug 31 19:48 gvfs-daemon.service -> /dev/null
lrwxrwxrwx 1 greetd greetd    9 Aug 31 19:43 xdg-desktop-portal.service -> /dev/null
lrwxrwxrwx 1 greetd greetd    9 Aug 31 19:44 xdg-document-portal.service -> /dev/null
lrwxrwxrwx 1 greetd greetd    9 Aug 31 19:44 xdg-permission-store.service -> /dev/null
```

On your next reboot/login cycle there should be no delay anymore.    

To verify this check the journal for something similar as:
```
dbus-daemon[1438]: [session uid=396 pid=1438 pidfd=5] Activation via systemd failed for unit 'xdg-desktop-portal.service': Unit xdg-desktop-portal.service is masked.
dbus-daemon[1438]: [session uid=396 pid=1438 pidfd=5] Activating via systemd: service name='org.freedesktop.portal.Desktop' unit='xdg-desktop-portal.service' requested by ':1.0' (uid=396 pid=1434 comm="gtkgreet -l -s /etc/greetd/gtkgreet.css")

```

You can see now the service is masked, and won't be started for the user with the UID of `396`, my service account for `greetd`.   

