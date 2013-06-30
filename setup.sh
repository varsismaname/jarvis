#!/bin/bash

set -e

if [ `whoami` != "root" ] ; then
  echo "You must be root."
  exit 1
fi

echo "APT::Install-Recommends \"0\";" > /etc/apt/apt.conf.d/50norecommends

apt-get update
apt-get install -y avahi-daemon tmux build-essential navit mpd mpc \
    libdbus-1-dev libncurses5-dev

# Shaves 10s off boot time
update-rc.d -f rsyslog remove

# Get rid of desktoppy gunk
rm -rf Desktop indiecity ocr_pi.png python_games || true

# build Emacs 24

if [ "$(emacs --version | grep 24)" = "" ]; then
    cd /tmp
    wget http://mirrors.kernel.org/gnu/emacs/emacs-24.3.tar.gz
    tar xzf emacs-24.3.tar.gz
    cd emacs-24.3
    ./configure --without-x && make && make install
fi

# Boot straight to Emacs
sed -i s_/sbin/getty\ --noclear_/sbin/getty\ --autologin\ pi_ /etc/inittab

# install Jarvis

HOME=/home/pi
mkdir $HOME/.emacs.d
ln -s $(dirname $0)/init.el $HOME/.emacs.d
ln -s $(dirname $0)/jarvis.el $HOME/.emacs.d
ln -s $(dirname $0)/tmux.conf $HOME/.tmux.conf
ln -s $(dirname $0)/bash_profile $HOME/.bash_profile

# music
mkdir $HOME/music
sed -i s_/var/lib/mpd/music_/home/pi/music_ /etc/mpd.conf
/etc/init.d/mpd restart

chown -R pi $HOME
