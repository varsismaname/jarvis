if [ `ps awx | grep emacs | grep -v grep` ] = "" ]; then
   exec dbus-launch emacs
fi