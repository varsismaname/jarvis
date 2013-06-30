# Jarvis

<img src="https://raw.github.com/technomancy/jarvis/master/jarvis.jpg" align="right" />

An automobile assistant.

Featuring a binary clock, music player, navigation, and
diagnostics driven by Emacs running on a headless Raspberry Pi.

The included `setup.sh` script should handle installing all the
necessary dependencies and loading Jarvis at boot time if you run it
as root on your pi.

## Hardware

* [Raspberry Pi](http://raspberrypi.org)
* [Lighter->USB power adapter](http://www.amazon.com/Griffin-Powerjolt-Universal-Micro-Colors/dp/B0042B9U8Q)
* Small USB keyboard
* Stereo with auxiliary input
* [Adafruit Ultimate GPS board](https://www.adafruit.com/products/746)
* [USB to TTL serial cable](https://www.adafruit.com/products/954)
* [USB ODB2 scanner](http://www.amazon.com/Crescent-OBD2-Multi-Protocol-Diagnostic-Scanner/dp/B001MT0XPK/)
* USB hub (if using wifi, diagnostics, or GPS concurrently)

## Binary Clock

The `jarvis-hour-pins` and `jarvis-minute-pins` lists in `jarvis.el`
map the digits of the hour and minute readout to GPIO pins, so each of
those need to be wired into an LED with a current-limiting
resistor. A different color should be used for hours vs minutes.

## Music

Jarvis includes an Emacs-based frontend to [mpd](http://musicpd.org),
the music player daemon. Populate the `/home/pi/music` directory with
your music collection and run `mpc update` whenever you add any new
files. The `jarvis-choose` command prompts you for an album to play
using `ido`, Emacs's predicative fuzzy-matching completion. The
`jarvis-toggle`, `jarvis-next`, `jarvis-prev`, and `jarvis-random`
commands also control music playback.

## Navigation

Get [map files](http://maps3.navit-project.org/) from the Navit
downloader and place them in the `maps/` directory in your Jarvis
checkout.

## Diagnostics

TODO

http://codeseekah.com/2012/02/22/elm327-to-rs232-in-linux/
