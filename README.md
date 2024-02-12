# Simple Reposiroty & Packet Manager (SRPM) for Slackware Linux

Simple Repository & Packet Manager, for me a.k.a srpm (slackware repository packet manager) is my attemp to manage repositories and packages with an abstraction layer of bash scripts, easy to modify, which uses below the official pkgtools of Slackware, and tries to present useful information when managing my Slackware Linux installation.

I hope this little contribution to the slackware comunity can help someone too.

## Installation

Clone/download the repository.

Go to reposiroty and make the slackware package.
Respond yes to reset permisions.
```
sudo ./make.slackware.package
```
Example of sort macking the repository.
```
[root@arcadia v]# sudo /home/data/git-repos/vielLosero/srpm/make.slackware.package
/tmp/tmp.aqSKQz9lnJ
mkdir: created directory 'usr'
mkdir: created directory 'usr/sbin'
mkdir: created directory 'etc'
mkdir: created directory 'etc/srpm'
mkdir: created directory 'usr/libexec'
mkdir: created directory 'usr/libexec/srpm'
mkdir: created directory 'var'
mkdir: created directory 'var/lib'
mkdir: created directory 'var/lib/srpm'

Slackware package maker, version 3.14159265.

Searching for symbolic links:

No symbolic links were found, so we won't make an installation script.
You can make your own later in ./install/doinst.sh and rebuild the
package if you like.

This next step is optional - you can set the directories in your package
to some sane permissions. If any of the directories in your package have
special permissions, then DO NOT reset them here!

Would you like to reset all directory permissions to 755 (drwxr-xr-x) and
directory ownerships to root.root ([y]es, [n]o)? y

mode of '.' changed from 0700 (rwx------) to 0755 (rwxr-xr-x)
mode of './install' retained as 0755 (rwxr-xr-x)
mode of './var' retained as 0755 (rwxr-xr-x)
mode of './var/lib' retained as 0755 (rwxr-xr-x)
mode of './var/lib/srpm' retained as 0755 (rwxr-xr-x)
mode of './etc' retained as 0755 (rwxr-xr-x)
mode of './etc/srpm' retained as 0755 (rwxr-xr-x)
mode of './usr' retained as 0755 (rwxr-xr-x)
mode of './usr/libexec' retained as 0755 (rwxr-xr-x)
mode of './usr/libexec/srpm' retained as 0755 (rwxr-xr-x)
mode of './usr/sbin' retained as 0755 (rwxr-xr-x)
ownership of '.' retained as root:root
ownership of './install' retained as root:root
ownership of './var' retained as root:root
ownership of './var/lib' retained as root:root
ownership of './var/lib/srpm' retained as root:root
ownership of './etc' retained as root:root
ownership of './etc/srpm' retained as root:root
ownership of './usr' retained as root:root
ownership of './usr/libexec' retained as root:root
ownership of './usr/libexec/srpm' retained as root:root
ownership of './usr/sbin' retained as root:root
Creating Slackware package:  /tmp/srpm-0.1.14-noarch-1.txz

./
etc/
etc/srpm/
etc/srpm/srpm.config.new
etc/srpm/srpm.repositories.new
install/
install/doinst.sh
install/douninst.sh
usr/
usr/libexec/
usr/libexec/srpm/
usr/libexec/srpm/srpm-package
usr/libexec/srpm/srpm-repository
usr/libexec/srpm/srpm.functions.sh
usr/sbin/
usr/sbin/srpm
var/
var/lib/
var/lib/srpm/
WARNING:  zero length file install/douninst.sh

Slackware package /tmp/srpm-0.1.14-noarch-1.txz created.
```
Install it.
```
sudo installpkg /tmp/srpm-0.1.14-noarch-1.txz
```
```
[root@arcadia v]# sudo installpkg /tmp/srpm-0.1.14-noarch-1.txz
Verifying package srpm-0.1.14-noarch-1.txz.
Installing package srpm-0.1.14-noarch-1.txz:
PACKAGE DESCRIPTION:
Executing install script for srpm-0.1.14-noarch-1.txz.
Package srpm-0.1.14-noarch-1.txz installed.
```
## How it works example 1
It is'nt nice i know but is under developement.
Normaly i search for unatended packages, that requires update, remove for old, or ignore if we know what we are doing.
```
[root@arcadia t1]# srpm -pu
+android-tools 31.0.3p1
+audacity 3.2.5
+brave-browser 1.61.116
+cmark 0.30.3
+discord 0.0.35
+libmediainfo 23.11
+mediainfo 23.11
+python-importlib_metadata 4.10.1
+python-zipp 3.8.0
+python3-PyYAML 5.3.1
+python3-attrs 21.4.0
+requiredbuilder 0.16.5
+sbopkg 0.38.2
+srpm 0.1.14
+webkit2gtk 2.42.4
[root@arcadia t1]#
```
After find some unatended packages like webkit2gtk i check if realy have a new version
```
[root@arcadia t1]# srpm -pv webkit2gtk
webkit2gtk: last 2.42.5 ; current 2.42.4
[root@arcadia t1]#
```
Then i check if some other package need update before 
```
[root@arcadia t1]# srpm -pnv webkit2gtk
libwpe: last 1.14.2 ; current 1.14.2
unifdef: last 2.12 ; current 2.12
xdg-dbus-proxy: last 0.1.4 ; current 0.1.4
wpebackend-fdo: last 1.14.2 ; current 1.14.2
geoclue2: last 2.6.0 ; current 2.6.0
bubblewrap: last 0.8.0 ; current 0.8.0
webkit2gtk: last 2.42.5 ; current 2.42.4
[root@arcadia t1]# 
```
I look if the package is from slackware or slackbuilds
```
[root@arcadia t1]# srpm -pl webkit2gtk
SBO: libraries/webkit2gtk
```
Then i install from sbopkg
```
[root@arcadia t1]# sbopkg -i webkit2gtk
```
## How it works example 2
An other example will be if we find an unatended packages that not are more in repo.
```
[root@arcadia v]# srpm -pv python3-PyYAML
python3-PyYAML: last Not in repo!!. ; current 5.3.1
[root@arcadia v]#
```
Package forced show nothing, package needed too.
```
[root@arcadia v]# srpm -pf python3-PyYAML
[root@arcadia v]# srpm -pn python3-PyYAML
[root@arcadia v]#
[root@arcadia v]# ls -la /var/log/packages/python3-PyYAML-5.3.1-x86_64-1_SBo
-rw-r--r-- 1 root root 3411 Sep 15  2021 /var/log/packages/python3-PyYAML-5.3.1-x86_64-1_SBo
[root@arcadia v]#
```
So try to find what appens, search for PyYALM
```
[root@arcadia v]# srpm -ps .*PyYAML
SBO: python2-PyYAML
SLACKWARE: python-PyYAML
[root@arcadia v]#
```
Ok seems that included on slackware so check
```
[root@arcadia v]# srpm -pv python-PyYAML
python-PyYAML: last 6.0 ; current Not installed.
[root@arcadia v]#
```
Ok remove package and install from slackware.
```
[root@arcadia v]# srpm -pr python3-PyYAML
*** srpm -pr act as frontend for removepkg ***
*** For more info use man removepkg ***
Removing package: python3-PyYAML-5.3.1-x86_64-1_SBo
Removing files:
  --> Deleting /usr/doc/python3-PyYAML-5.3.1/CHANGES
  --> Deleting /usr/doc/python3-PyYAML-5.3.1/LICENSE
--skip---
[root@arcadia v]# slackpkg install python-PyYAML
```
### How it works example 3
In this example we can see how we need to update libmediainfo before update mediainfo.
```
[root@arcadia tmp]# srpm -pu
+android-tools 31.0.3p1
+audacity 3.2.5
+brave-browser 1.61.116
+cmark 0.30.3
+discord 0.0.35
+libmediainfo 23.11
+mediainfo 23.11
+python3-attrs 21.4.0
+requiredbuilder 0.16.5
+sbopkg 0.38.2
+srpm 0.1.14
+webkit2gtk 2.42.4
[root@arcadia tmp]# srpm -pnv mediainfo
libzen: last 0.4.41 ; current 0.4.41
libmediainfo: last 24.01 ; current 23.11
mediainfo: last 24.01 ; current 23.11
[root@arcadia tmp]# srpm -pn mediainfo
mediainfo: libmediainfo
libmediainfo: libzen
libzen:
[root@arcadia tmp]#
```

## Usage
How i use it.
Brew description for each option.
### Repository info.
Show info for the repositories configured in /etc/srpm/srpm.repositories.
```
srpm repository info
```
### Repository check.
Check if repositories up to date.
From a fresh install, that no have updated yet only show Source date.
After and update it will show local db date too.
Always make a check before an update to view if there are updates availables.
```
srpm repo check
```
### Repository update
Depending of the config of /etc/srpm/srpm.repositories that will do:
 + update some files needed to search packages ...
 + made a full mirror of the repository.
```
srpm -r update
```
### Repository version
That will make work files for db to do:
package needed : packages needed for run the package aka:requires aka:dependencies
package forced : what packages are forced to stay installed becuse other package aka: invers dependencies
This option will be auto included after repository update on next versions.
```
srpm -rv
```
### Package remove
Package remove a instaled package. Be care.
```
srpm -pr kicad
```
### Package search
Package search if we know the package name.
```
srpm -ps kicad
```
Package search that start with ki.
```
srpm -ps ki
```
### Package description
Show slackware package description
```
srpm -pd package
```
### Package needed
Show recursive other packages needed to run the package.
aka:requires 
aka:dependencies
```
srpm -pn kicad
```
Sort example explained,
Each package line contain main package followed with (:) and they required packages. 
The first collumn are all the packages that kicad need to run, (itself too). Maybe in the column there are some repeateed package because a package is recursive required for 2 other packages. See triks to make a list with sort uniq.
So kicad need OpenCASCADE glm ngspice unixODBC wxPython4 wxWidgets
OpenCASCADE need VTK
glm no need any
ngspice no need any too
unixODBC need attention, search inside repository to read the %README% file.
wxPython4 need webkit2gtk python3-pathlib2 python3-attrdict
wxWidgets no need any
Then we start with the recursive dependencies, VTK
etc.
In finish, from down to up we need to install all the packages in the 1st column to run kicad.
```
[root@arcadia t1]# srpm -pn kicad
kicad: OpenCASCADE glm ngspice unixODBC wxPython4 wxWidgets
OpenCASCADE: VTK
glm:
ngspice:
unixODBC: %README%
wxPython4: webkit2gtk python3-pathlib2 python3-attrdict
wxWidgets:
VTK:
webkit2gtk: bubblewrap geoclue2 wpebackend-fdo xdg-dbus-proxy unifdef
python3-pathlib2:
python3-attrdict: python3-wheel python3-build
bubblewrap:
geoclue2:
wpebackend-fdo: libwpe
xdg-dbus-proxy:
unifdef:
python3-wheel: python3-installer
python3-build: python3-pyproject-hooks
libwpe:
python3-installer: python3-flit_core
python3-pyproject-hooks: python3-installer
python3-flit_core:
python3-installer: python3-flit_core
python3-flit_core:
[root@arcadia t1]#
```

### Package unattended
Show packages that are installed and dont stay in the repo db.
That packages will neeed admin attention to manual remove/update or ignore.
```
srpm -pu
```
### Package locate
Show the repository dir where the package are
```
srpm -pl
```
### Package version
```
srpm -pv kicad
```
### Package forced
Show the packages installed that require that package.
That will show us if it is safe to uninstall a packages or not.
```
srpm -pf libwpe
```
Next versions will do this recursive.
```
[root@arcadia t1]# srpm -pf libwpe
 wpebackend-fdo
[root@arcadia t1]# srpm -pf wpebackend-fdo
 webkit2gtk
[root@arcadia t1]# srpm -pf webkit2gtk
 wxPython4
[root@arcadia t1]# srpm -pf  wxPython4
 kicad
```
### Package install
TODO: For now it will show the asc package file for slackware or the asc slackbuild tar for verify and manual install.
### Package search-file
TODO: Will search for files associed to a package.
    Slackware have a MANIFEST.bz2 for that but slackbuilds don't. So download all packages and make a MANIFEST file is a hard work whitout a dedicatet maquine or support.
### Package mirror
TODO: Will download mirror a package to manual make or other.

 


## Contributing
All contributions are welcome.

## Tricks

### Package search
Package search that contain ki on name, grep regex.
```
srpm -ps .*ki
```
Package search that contain and ends with cad, grep regex.
```
srpm -ps .*cad\\
```
Package search that start with nc and ends with nc, grep regex.
```
srpm -ps nc\\
```
### Package needed
Packages needeed, sort in order to install.
```
srpm -pn kicad | cut -d: -f1 | tac | awk '!_[$0]++'
```
Packages needed with version/installed
```
srpm -pnv kicad
```

## Author

* **Viel Losero** - *Initial work* - [Viel Losero](https://github.com/VielLosero)

## Copyrights

Slackware® is a Registered Trademark of Patrick Volkerding. 
Linux® is a Registered Trademark of Linus Torvalds.

## License
This project is licensed under the GPL-3.0 - see the [LICENSE.md](LICENSE.md) file for details


