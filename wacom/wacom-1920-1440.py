import os
import subprocess

devices = subprocess.run(
        ["xsetwacom", "--list", "devices"],
        stdout=subprocess.PIPE
    ).stdout.decode('utf-8')

stylus = -1
pad = -1
for device in devices.split("\n"):
    device_line = device.split()
    if len(device) == 0:
        continue

    if device_line[-1] == "STYLUS":
        stylus = device_line[-3]
    elif device_line[-1] == "PAD":
        pad = device_line[-3]

if stylus == -1 or pad == -1:
    print("Error, pad or stylus not found")
    exit()

screen_output = subprocess.run(
        ["xrandr"],
        stdout=subprocess.PIPE
    ).stdout.decode('utf-8')
screen_line = next(x for x in screen_output.split("\n") if "1440" in x)
screen = screen_line.split()[0]

screen_width = 2560
screen_height = 1440
tablet_height = 13500
tablet_width = 21600
adjusted_width = screen_height * (tablet_width / tablet_height)
offset = 1920 + (2560 - adjusted_width) / 2
resolution_string = f'{int(adjusted_width)}x1440+{int(offset)}+0'
print(resolution_string)

os.system(f'xinput map-to-output {pad} {screen}')
os.system(f'xsetwacom set {stylus} MapToOutput {resolution_string}')
os.system(f'xsetwacom set {pad} Button 1 "key del"')
os.system(f'xsetwacom set {pad} Button 2 "key 5"')
os.system(f'xsetwacom set {pad} Button 3 "key +ctrl z -ctrl"')
os.system(f'xsetwacom set {pad} Button 8 "key shift"')
