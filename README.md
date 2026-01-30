## GRUB Menu Theme for Dual Boot WinLin

Powered by Mavox-ID (https://github.com/ye-a.pp.ua) and community support, plus photos from Gemini 3 Pro

I really liked this design and wondered why it wasn't a theme, but just an image. It seems there's no easy way to make the selection menu in GRUB anything other than a vertical list of lines.

This is a unique theme that uses "icons" of elements stretched across the entire screen to give each element the look I want. I haven't seen this approach anywhere before.
I was bored with the standard GRUB theme for switching between Linux and Windows, and other themes didn't want much variety, so I created a simple but very cool WinLin theme for switching between Linux and Windows themes.

The tool, EFI, and power icons were generated using neural networks.

### Preview
![Preview](.prew/preview.gif)

### Selecting a resolution
To find out the resolution supported by your GRUB:
* At the GRUB screen, press `c` to enter the command line
* ​​Enter `vbeinfo` or `videoinfo`
* The extension used and the number will be listed below, for example: `1.4`

Once you get the value, return to Linux and run the following in the WinLin folder:

```bash
chmod +x build.sh && ./build.sh <Your resolution, for example: 1920x1080> <Your number, for example: 1.4>
```

> **Note!** Replace everything in <>, including the numbers, with your number.

### Installation
I recommend using the included `install.sh` script (It is located in the build folder when you have compiled your custom theme using `build.sh`). However, if you want to do this manually, make sure the GRUB_GFXMODE parameter exactly matches the resolution of the selected theme.

### Building for your resolution
Use the build.sh script. You will need the following programs:
* grub-mkfont
* convert from ImageMagick v6

You can download them using the ready-made install-apt.sh program by simply running the script. (Note: This is not the theme's build and installation file, but rather its tools.)
