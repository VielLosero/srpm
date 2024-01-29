# Simple Reposiroty & Packet Manager (SRPM) for Slackware Linux

Simple Repository & Packet Manager, for me a.k.a srpm (slackware repository packet manager) is my attemp to manage repositories and packages with an abstraction layer of bash scripts, easy to modify, which uses below the official tools of Slackware, and tries to present useful information when managing my Slackware Linux installation.

I hope this little contribution to the slackware comunity can help someone too.

## Installation

## Usage

## Contributing

## Tricks

### Search for a package that end with nc, grep regex.
```
srpm -ps nc\\
```
### Search for a package containing nc, grep regex.
```
srpm -ps .*nc
```
### Search for a package containing and end with office.
```
srpm -ps .*office\\
```


## Copyrights

Slackware® is a Registered Trademark of Patrick Volkerding. 
Linux® is a Registered Trademark of Linus Torvalds.

## License
This project is licensed under the GPL-3.0 - see the [LICENSE.md](LICENSE.md) file for details


