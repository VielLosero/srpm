#!/bin/bash
#
## Copyright (c) 2024 VielLosero 
#
# The program is free software: you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, 
# or (at your option) any later version.
#
# The program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License 
# along with this program. If not, see <https://www.gnu.org/licenses/>. 
#
## Description: functions for srpm.
## srpm, - A simple repository & package manager for Slackware Linux.
#
# Slackware® is a Registered Trademark of Patrick Volkerding. 
# Linux® is a Registered Trademark of Linus Torvalds.

# Repository config file
REPO_CONFIG_FILE=/etc/srpm/srpm.repositories

# Source srpm.config to get db dir
# load default dir
. /etc/srpm/srpm.config || exit 1
# no needed get from above
#SRPM_DIR=${SRPM_DIR:-/var/lib/srpm}

# Needed dirs
SRPM_DB_DIR="${SRPM_DIR}/db"
#SRPM_REPO="${SRPM_DB_DIR}/srpm"
SRPM_DBFILES="${SRPM_DIR}/dbfiles"
SRPM_HELPFILES="${SRPM_DIR}/helpfiles"

# Get all diferent tags from repositories in repository config file
# A  tag is like the repository name id in uppercase ex:(SBO,SLACKWARE)
gettags_from_config_file(){
REPO_TAGS=$(cat $REPO_CONFIG_FILE | grep "^REPO_" | cut -d_ -f2 | sort -u)
}

# Get repository values
# Filter from repo config file to 
getrepo_vars(){
  # Repo variables
  # repository name ex:(SBO,SLACKWARE,...)
  REPO_NAME=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_NAME" | cut -d= -f2 | tr -d '"')
  # repository architecture
  REPO_ARCH=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_ARCH" | cut -d= -f2 | tr -d '"')
  # repository version ex:(15,slackware64_15.0,...)
  REPO_VERSION=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_VERSION" | cut -d= -f2 | tr -d '"')
  # from where get sources
  REPO_SOURCE=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_SOURCE" | cut -d= -f2 | tr -d '"')
  # source type (file:/// http:// ftp:// rsync:// git)
  REPO_SOURCE_TYPE="$(echo $REPO_SOURCE | cut -d: -f1 )"
  # if repo source is a local file need repo update from where update
  REPO_UPDATE=$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_UPDATE" | cut -d= -f2 | tr -d '"')
  # sanity check if no UPDATE on config take SOURCE
  if [ -z $REPO_UPDATE ] ; then
    REPO_UPDATE=$REPO_SOURCE
  fi
  #Get files from: $REPO_UPDATE"
  REPO_UPDATE_TYPE="$(echo $REPO_UPDATE | cut -d: -f1 )"
  # sanity check 2 if repo update type is file can't update from that.
  if [ "$REPO_UPDATE_TYPE" == "file" ] ; then 
    echo "Can't update from ${TAG}: ${REPO_UPDATE}"
    echo "Please configure a valid {http/s ftp rsync git} url in ${REPO_CONFIG_FILE}"
  fi


  # File variables
  # All repos
  DBFILE_CHECKSUMS=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.CHECKSUMS.md5
  DBFILE_CHECKSUMS_ASC=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.CHECKSUMS.md5.asc
  DBFILE_CHANGELOG=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.ChangeLog.txt
  # slackware alien slakel
  DBFILE_PACKAGES=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.PACKAGES.TXT
  #DBFILE_FILELIST=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.FILELIST.TXT
  #DBFILE_GPGKEY=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.GPG-KEY
  # slackware alien
  DBFILE_MANIFEST=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.MANIFEST.bz2
  #slackware
  DBFILE_CHECKSUMS_PATCHES=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.PATCHES.CHECKSUMS.md5
  DBFILE_CHECKSUMS_PATCHES_ASC=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.PATCHES.CHECKSUMS.md5.asc
  #DBFILE_FILE_LIST_PATCHES=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.PATCHES.FILE_LIST
  #DBFILE_MANIFEST_PATCHES=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.PATCHES.MANIFEST.bz2
  #DBFILE_PACKAGES_PATCHES=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.PATCHES.PACKAGES.TXT
  DBFILE_CHECKSUMS_EXTRA=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.EXTRA.CHECKSUMS.md5
  DBFILE_CHECKSUMS_EXTRA_ASC=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.EXTRA.CHECKSUMS.md5.asc
  DBFILE_CHECKSUMS_PASTURE=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.PASTURE.CHECKSUMS.md5
  DBFILE_CHECKSUMS_PASTURE_ASC=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.PASTURE.CHECKSUMS.md5.asc
  # slackbuilds
  DBFILE_SLACKBUILDS=${SRPM_DBFILES}/${REPO_NAME}-${REPO_ARCH}-${REPO_VERSION}.SLACKBUILDS.TXT


  # where we store the neeeded files (like Changelog.txt ...) for fast check, or mirror link
  #REPO_DB_SOURCE="$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_DBDIR" | cut -d= -f2 | tr -d '"')/repositories/${REPO_NAME}/${REPO_VERSION}"
  REPO_DB_SOURCE="${SRPM_DIR}/repositories/${REPO_NAME}/${REPO_VERSION}"
  # make repo source dir if not exist. NOTE: not needed to check every time, put out of function
  [[ ! -d ${REPO_DB_SOURCE} ]] && mkdir -vp ${REPO_DB_SOURCE}
  # separated db dir to put our files and leave a clean mirror
  #REPO_DB="$(cat $REPO_CONFIG_FILE | grep "^REPO_${TAG}_DBDIR" | cut -d= -f2 | tr -d '"')/db/${REPO_NAME}/${REPO_VERSION}"
  REPO_DB="${SRPM_DIR}/db/${REPO_NAME}/${REPO_VERSION}"
  # make repo dir if not exist. NOTE: not needed to check every time, put out of function
  [[ ! -d ${REPO_DB} ]] && mkdir -vp ${REPO_DB}
}


# function that get Changelog date and number of packages inside a TAG for loop.
get_Changelog_date_and_packages_number(){
SOURCE_CHANGELOG_DATE="$(cat ${TMPDIR}/${REPO_NAME}/ChangeLog.txt  | head -1)"
SOURCE_PKGS_NUM="$(grep slack-desc ${TMPDIR}/${REPO_NAME}/CHECKSUMS.md5 | wc -l )"     
}


# Slackware ans SBO have diferent files to get package versions.
# I think the easy way is to make a little file with package version to uniform the queri on the script.
make_packages_version_db(){
  if [ "$1" == "SLACKWARE" ] ; then
    echo "[*] Creating $1 patches versions file PKGVER.TXT"
    mkdir -p ${REPO_DB}/patches 2>/dev/null
    rm ${REPO_DB}/patches/PKGVER.TXT 2>/dev/null
    sed -n "/PACKAGE NAME:  /{s///;p}" ${REPO_DB_SOURCE}/patches/PACKAGES.TXT | rev |\
       cut -d- -f3- | sed 's/-/ /' | rev  | sort >> ${REPO_DB}/patches/PKGVER.TXT
    echo "[*] Creating $1 extra versions file PKGVER.TXT"
    mkdir -p ${REPO_DB}/extra 2>/dev/null
    rm ${REPO_DB}/extra/PKGVER.TXT 2>/dev/null
    sed -n "/PACKAGE NAME:  /{s///;p}" ${REPO_DB_SOURCE}/extra/PACKAGES.TXT | rev |\
       cut -d- -f3- | sed 's/-/ /' | rev  | sort >> ${REPO_DB}/extra/PKGVER.TXT
    echo "[*] Creating $1 package versions file PKGVER.TXT"
    mkdir -p ${REPO_DB} 2>/dev/null
    rm ${REPO_DB}/PKGVER.TXT 2>/dev/null
    sed -n "/PACKAGE NAME:  /{s///;p}" ${REPO_DB_SOURCE}/PACKAGES.TXT | rev |\
       cut -d- -f3- | sed 's/-/ /' | rev | sort >> ${REPO_DB}/PKGVER.TXT
  elif [ "$1" == "SBO" ] ; then
    echo "[*] Creating $1 package versions file PKGVER.TXT"
    mkdir -p ${REPO_DB} 2>/dev/null
    rm ${REPO_DB}/PKGVER.TXT 2>/dev/null 
    # https://www.gnu.org/software/sed/manual/sed.html#Regexp-Addresses
    sed -n '/SLACKBUILD NAME: /{s///;p};/SLACKBUILD VERSION:/{s///;p}' ${REPO_DB_SOURCE}/SLACKBUILDS.TXT |\
      # https://www.gnu.org/software/sed/manual/sed.html#Joining-lines
      sed -e :a -e '$!N;s/\n  */ /;ta' -e 'P;D' | sort >> ${REPO_DB}/PKGVER.TXT
  fi
}

make_packages_requires_db(){
  if [ "$1" == "SLACKWARE" ] ; then
    echo "TODO: $1  db file REQUIRES.TXT"
    ## echo "[*] Creating $1  db file REQUIRES.TXT"
    ##   rm ${REPO_DB}/MANIFEST.ALL 2>/dev/null
    ## for dir in slackware64 extra patches ; do 
    ##   echo "[*] Removing old db files"
    ##   mkdir -p ${REPO_DB}/${dir} 2>/dev/null
    ##   rm ${REPO_DB}/${dir}/MANIFEST.Packages 2>/dev/null
    ##   echo "[*] Processing ${REPO_DB_SOURCE}/${dir}/MANIFEST.bz2"
    ##   bzgrep -n "Package:" "${REPO_DB_SOURCE}/${dir}/MANIFEST.bz2" | grep -n "Package:" > ${REPO_DB}/${dir}/MANIFEST.Packages
    ##   lines=$( wc -l ${REPO_DB}/${dir}/MANIFEST.Packages )
    ##   echo "[*] Processing lines $lines"
    ##   while read POINT ; do
    ##   POINT_ALL=$(echo $POINT | rev | cut -d- -f4-| rev)
    ##   if echo $POINT | grep -v "./source" 2>/dev/null >/dev/null ; then
    ##   START=$(echo $POINT_ALL | cut -d: -f2)
    ##   POINT1=$(($(echo $POINT_ALL | cut -d: -f1)+1))
    ##   STOP=$( sed -n "${POINT1}p" ${REPO_DB}/${dir}/MANIFEST.Packages | cut -d: -f2)
    ##   PACKAGE=$(echo $POINT_ALL |rev| cut -d/ -f1 | rev)
    ##   #echo $POINT_ALL
    ##   #echo "$PACKAGE: $START $STOP $POINT1"
    ##   echo "${PACKAGE}:${START},${STOP}:${dir}" >> ${REPO_DB}/MANIFEST.ALL
    ##   fi
    ##   done < ${REPO_DB}/${dir}/MANIFEST.Packages
    ## done && echo "[+] MANIFEST.ALL created."

    ## echo "[*] Processing "

    ## for ELF_FILE in $(bzcat ${SRPM_DIR}/repositories/slackware/slackware64-15.0/slackware64/MANIFEST.bz2| sed -n '1107,1368p' | tail -n +4  | head -n -4  | rev | cut -d" " -f1 | rev | sed 's:^:/:' ) ; do
    ##     ldd $ELF_FILE 2>/dev/null | grep "=>" | awk '{print $3}' # >> $TMP_ELF
    ##   done



  elif [ "$1" == "SBO" ] ; then
    echo "[*] Creating $1  db file REQUIRES.TXT"
    rm ${REPO_DB}/REQUIRES.TXT 2>/dev/null
    find ${REPO_DB_SOURCE}/  -name "*.info" -exec grep -H -n REQUIRES {} \; > ${REPO_DB}/REQUIRES.TXT
  fi
}

# get requires from sbo package.info usefull if no db and to check online but maybe we can use REQUIRES.TXT ??
# or maybe i can upload to git some PKGVER.TXT and REQUIRES.TXT if no one add them.
get_requires(){
  for PACKAGE in $@ ; do
    if FILEPATH="$(grep -n "\/${PACKAGE}.info" ${REPO_DB_SOURCE}/CHECKSUMS.md5)" ; then
      FOUND=1
      FILEPATH="$(echo "$FILEPATH" | head -1 | cut -d " " -f3)"
      FILE="${REPO_DB_SOURCE}/${FILEPATH}"
      #echo $FILE
      if [ -e $FILE ] ; then 
        REQ="$(cat "${REPO_DB_SOURCE}/${FILEPATH}" | grep REQUIRES | head -1 | cut -d= -f2 | tr -d '"')"
        echo "$PACKAGE: $REQ"
        REQUIRES+=($REQ)
      fi
    else
      FOUND=0
    fi
  done
}

# Process CHECKSUMS.md5 process_checksum "REPO_DIR" > sort.file
process_checksum(){
  DIR=$1
grep -n txz.asc$ ${DIR}/CHECKSUMS.md5 | awk '{sub(":"," ",$1) ; print $1" "$2}' |  awk -F/ '{  for(i=1;i<NF;i++)  LINE=LINE$i"/" ; print LINE" "$NF ; LINE=""}'  | rev | sed 's/-/ /' |sed 's/-/ /' |sed 's/-/ /' | rev |  awk '{gsub(".txz.asc"," txz",$7) ; print $0 }' 
}

bad_signature(){
cat <<"EOF"
###################################
### WARNING: BAD gpg signature. ###
###################################
EOF

PROCEED=""
while [ ! -z $PROCEED ] ; do 
read -p "Do you want to proceed? (yes/no) " yn
case $yn in 
	yes ) echo "ok, we will proceed"
        PROCEED="yes";;
	no  ) echo exiting...;
        PROCEED="no";;
	*   ) echo invalid response;;
esac
done
}

## # find file path 
## where(){
##   if [ $# == 1 ] ; then
##     RESULT=$(type $1 | cut -d" " -f3) || RESULT=$(which $1)
##     echo "$RESULT"
##   fi
## }
## 
## get_tool(){
## for tool in curl wget rsync ; do
##   TOOL=$(where $tool)
##   echo $TOOL
##   [[ ! -z $TOOL ]] && break
## done
## }
## 
## if [ "$DOWNLOADER" = "curl" ]; then
##   DOWNLOADER="curl ${CURLFLAGS} -o"
## elif [ "$DOWNLOADER" = "wget" ]; then
##   DOWNLOADER="wget ${WGETFLAGS} -O"
## elif [ "$DOWNLOADER" = "rsync" ]; then
##   DOWNLOADER="rsync ${RSYNCFLAGS} "
## else
##   echo "Downloader tool not found."
## fi
                          



# vim:sw=2:ts=2:et:
