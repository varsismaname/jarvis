# Jarvis

An automobile assistant.

## Features

* Music
* Diagnostics
* Location

## GPIO cheat sheet

    sudo su -
    echo 18 > /sys/class/gpio/export
    echo 23 > /sys/class/gpio/export
    echo out > /sys/class/gpio/gpio18/direction
    echo out > /sys/class/gpio/gpio23/direction
    echo 1 > /sys/class/gpio/gpio18/value
    echo 0 > /sys/class/gpio/gpio23/value

    echo 0 > /sys/class/gpio/export
    echo in > /sys/class/gpio/gpio0/direction
    cat /sys/class/gpio/gpio0/value


## To order

* printer
* GPS
* USB/TTL cable
* case

* LCD screen?
* keyboard
* LEDs
* battery
* micro-SD adapter

## ODB

http://codeseekah.com/2012/02/22/elm327-to-rs232-in-linux/
