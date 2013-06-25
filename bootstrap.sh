#!/bin/bash

set -e

if [ `whoami` != "root" ] ; then
  echo "You must be root."
  exit 1
fi

echo "APT::Install-Recommends \"0\";" > /etc/apt/apt.conf.d/50norecommends

apt-get update
apt-get install -y avahi-daemon tmux build-essential navit \
    libdbus-1-dev libncurses5-dev

# Get rid of desktoppy gunk
rm -rf Desktop indiecity ocr_pi.png python_games || true

# TODO: switch to upstart?

# build Emacs 24

cd /tmp
wget http://mirrors.kernel.org/gnu/emacs/emacs-24.3.tar.gz
tar xzf emacs-24.3.tar.gz
cd emacs-24.3
./configure --without-x && make && make install

# install Jarvis

mkdir $HOME/.emacs.d
cp $(dirname $0)/init.el $HOME/.emacs.d
cp $(dirname $0)/jarvis.el $HOME/.emacs.d
cp $(dirname $0)/tmux.conf $HOME/.tmux.conf

chown -R $USER $HOME

# Open Emacs on boot
