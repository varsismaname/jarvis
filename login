#!/bin/bash

# We want to boot to Emacs from getty but still allow bash via ssh, etc.
if [ "$TERM" = "linux" ]; then
   exec emacs
else
   exec bash $@
fi
