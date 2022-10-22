#!/bin/bash

echo "1)xbps
      2)pacman
      -->  "
read manager

#installing dependencies.
case $manager in
	1)
		DISTRO=1 sudo xbps-install -S sxhkd picom yt-dlp dunst nitrogen flameshot brillo make cmake gcc xorg-minimal libXft-devel libXcursor-devel libXrandr-devel libXinerama-devel libXfont-devel libXfont2-devel pkg-config glava font-awesome6 font-hack-ttf void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree 
		;;
	2)
		DISTRO=2 sudo pacman -Sy sxhkd picom yt-dlp dunst nitrogen flameshot make cmake gcc xorg pkgconf glava ttf-hack ttf-font-awesome
		;;
esac

#applying the custom configs.
SRCDIR="$(pwd)"

DUNST=/etc/dunst
SXHKD=/home/$USER/.config/sxhkd
GLAVA=/etc/xdg/glava

#checking for your skill issues. 
if [[ ! -d "$SRCDIR/extras" ]]; then
	echo "run the script inside it's folder." && exit
	fi

#creating the folder if it doesn't exist, and applying the config.
if [[ ! -d "$DUNST" ]]; then
        sudo mkdir $DUNST && sudo cp $SRCDIR/extras/dunstrc $DUNST
else
	sudo cp $SRCDIR/extras/dunstrc $DUNST
	fi

#same as above but it's sxhkd.
if [[ ! -d "$SXHKD" ]]; then
	mkdir $SXHKD && cp $SRCDIR/extras/sxhkdrc $SXHKD
else
	cp $SRCDIR/extras/sxhkdrc $DUNST
	fi

#same as above but it's glava.
if [[ ! -d "$GLAVA" ]]; then
	sudo mkdir $GLAVA && sudo cp -r $SRCDIR/extras/glava $GLAVA
else
	sudo cp -r $SRCDIR/extras/glava $GLAVA
	fi

#compiling dwm, and it's gremlins.
cd $SRCDIR/dwm && sudo make install &&
cd $SRCDIR/slstatus && sudo make install &&
cd $SRCDIR/dmenu && sudo make install &&
cd $SRCDIR/st && sudo make install &&
cp $SRCDIR/extras/xinirc $HOME/.xinitrc

echo "everything done."
echo "do you wish to download all of wine's dependencies? (this is mainly for gaming.(you need to enable multilib on your distro.))"
echo "1)yes
      2)no
      -->  "

read end
if [[ $end == 2 ]] then
	exit
elif [[ $end == 1 && $DISTRO == 1 ]] then
	sudo xbps-install -S wine wine-tools wine-devel wine-gecko wine-mono winetricks giflib-devel libwine-32bit wine-32bit wine-devel-32bit giflib-devel-32bit libpng-devel libpng-devel-32bit libldap-devel libldap-devel-32bit gnutls-devel gnutls-devel-32bit mpg123 libmpg123-32bit libopenal-devel libopenal-devel-32bit v4l-utils-devel v4l-utils-devel-32bit libpulseaudio libpulseaudio-32bit alsa-plugins alsa-plugins-32bit alsa-lib-devel alsa-lib-devel-32bit libjpeg-turbo-devel libjpeg-turbo-devel-32bit libXcomposite-devel libXcomposite-devel-32bit libXinerama-devel libXinerama-devel-32bit ncurses-devel ncurses-devel-32bit libxslt-devel libxslt-devel-32bit libva-devel libva-devel-32bit gst-plugins-base1-devel gst-plugins-base1-devel-32bit Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers Vulkan-ValidationLayers-32bit libspa-vulkan libspa-vulkan-32bit vulkan-loader vulkan-loader-32bit cups samba dosbox

elif [[ $end == 1 && $DISTRO == 2 ]] then
	sudo pacman -Sy wine giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox
else
	echo "something went wrong. perhaps you should check your internet connection"
	fi

echo "all done."
