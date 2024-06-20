# Pixel_scripts

This repo is a collection of scripts for driving flip dot displays made by PIXEL Bydgoszcz. 

These scripts were tested on a 16x112 display with Linux, might not work well with different display/on WSL with Windows.

### Requirements 

- Cheap USB - RS485 converter

- The display itself


### How to use
`img2hex.py example.png`  converts B/W 16px wide 112px high image to hex

`sendit.py -s data` Sends ready to go data to the display on id 0

`./size.sh` Can use argument as input or after starting the script, it accepts hex data from img2hex.py or other scripts, calculates everything that's needed and sends it to sendit.py

`clock.sh`  Shows current system time on the display

`./txt2line2hex.sh -s1 top text -s2 bottom text`  Converts characters to hex and displays it in 2 lines, unknown characters will display as "?"

`pixel data_en.txt` example data pulled from the display driver with instructions on how to make your own 

