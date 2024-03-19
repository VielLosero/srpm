#!/bin/bash
#
## Copyright (c) 2024 VielLosero 
#
# This file is part of srpm. 
# srpm is free software: you can redistribute it and/or modify it 
# under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, 
# or (at your option) any later version.
#
# srpm is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License 
# along with srpm. If not, see <https://www.gnu.org/licenses/>. 
#
## Description: install script for srpm. 
#
# Slackware® is a Registered Trademark of Patrick Volkerding. 
# Linux® is a Registered Trademark of Linus Torvalds.


# check root

# Sanity check, change to dir on this SlackBuild script are with the sources.
cd $(dirname $0) ; CWD=$(pwd)

DESTDIR=${DESTDIR:-}

  # Make system structure to copy files.
  mkdir -p ${DESTDIR}/usr/sbin
  mkdir -p ${DESTDIR}/etc/srpm
  mkdir -p ${DESTDIR}/usr/libexec/srpm
  mkdir -p ${DESTDIR}/var/lib/srpm
  
  # Copy files to package dir.
  cp -a ${CWD}/srpm ${DESTDIR}/usr/sbin
  cp -a ${CWD}/srpm.config.new ${DESTDIR}/etc/srpm
  cp -a ${CWD}/srpm.repositories.new ${DESTDIR}/etc/srpm
  cp -a ${CWD}/srpm-db ${DESTDIR}/usr/libexec/srpm
  cp -a ${CWD}/srpm-package ${DESTDIR}/usr/libexec/srpm
  cp -a ${CWD}/srpm-repository ${DESTDIR}/usr/libexec/srpm
  cp -a ${CWD}/srpm.functions.sh ${DESTDIR}/usr/libexec/srpm

  # Move new to old 
  if [ -z $DESTDIR ] ; then 
  [[ ! -e /etc/srpm/srpm.config ]] && \
    mv /etc/srpm/srpm.config.new /etc/srpm/srpm.config
  [[ ! -e /etc/srpm/srpm.repositories ]] && \
    mv /etc/srpm/srpm.repositories.new /etc/srpm/srpm.repositories
  fi


