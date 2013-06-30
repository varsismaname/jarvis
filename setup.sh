#!/bin/bash

set -e

if [ `whoami` != "root" ] ; then
  echo "You must be root."
  exit 1
fi

echo "APT::Install-Recommends \"0\";" > /etc/apt/apt.conf.d/50norecommends

apt-get update
apt-get install -y avahi-daemon tmux build-essential navit mpd mpc \
    festival festvox-kallpc16k emacs23

# TODO: british voice
# http://festvox.org/databases/cstr_uk_rab_diphone/packed/cstr_uk_rab_diphone.tar.bz2
# into /usr/share/festival/voices/english

# Shaves 10s off boot time
update-rc.d -f rsyslog remove

# Get rid of desktoppy gunk
rm -rf Desktop indiecity ocr_pi.png python_games || true

# Boot straight to Emacs
sed -i s_/sbin/getty\ --noclear_/sbin/getty\ --autologin\ pi_ /etc/inittab

# install Jarvis

HOME=/home/pi
mkdir -p $HOME/.emacs.d
ln -s $(dirname $0)/init.el $HOME/.emacs.d || true
ln -s $(dirname $0)/jarvis.el $HOME/.emacs.d || true
ln -s $(dirname $0)/tmux.conf $HOME/.tmux.conf || true
ln -s $(dirname $0)/bash_profile $HOME/.bash_profile || true

# music
mkdir -p $HOME/music
sed -i s_/var/lib/mpd/music_/home/pi/music_ /etc/mpd.conf
/etc/init.d/mpd restart

chown -R pi $HOME
