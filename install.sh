#!/bin/bash

echo "Wich distro are you using?
      1)Void
      2)Arch\n
      ---> "

read manager

#Installing dependencies.
case $manager in
	1)
		DISTRO=1 sudo xbps-install -S sxhkd picom yt-dlp dunst nitrogen flameshot brillo make cmake gcc xorg-minimal libXft-devel libXcursor-devel libXrandr-devel libXinerama-devel libXfont-devel libXfont2-devel pkg-config glava font-awesome6 font-hack-ttf void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree gtk+ gtk+3 git wget
		;;
	2)
		DISTRO=2 sudo pacman -Sy --needed sxhkd picom yt-dlp dunst nitrogen flameshot make cmake gcc xorg pkgconf glava ttf-hack ttf-font-awesome gtk2 gtk3 git wget
		;;
esac

#applying the custom configs.
SRCDIR="$(pwd)"

DUNST=/etc/dunst
SXHKD=/home/$USER/.config/sxhkd
GLAVA=/etc/xdg/glava

#Checking for your skill issues. 
if [[ ! -d "$SRCDIR/extras" ]]; then
	echo "run the script inside it's folder." && exit
fi

#Creating dunst's config folder if it doesn't exist. And applying the config.
if [[ ! -d "$DUNST" ]]; then
        sudo mkdir $DUNST && sudo cp $SRCDIR/extras/dunstrc $DUNST
else
	sudo cp $SRCDIR/extras/dunstrc $DUNST
fi

#Same as above, but it's sxhkd.
if [[ ! -d "$SXHKD" ]]; then
	mkdir $SXHKD && cp $SRCDIR/extras/sxhkdrc $SXHKD
else
	cp $SRCDIR/extras/sxhkdrc $DUNST
fi

#Same as above, but it's glava.
if [[ ! -d "$GLAVA" ]]; then
	sudo mkdir $GLAVA && sudo cp -r $SRCDIR/extras/glava $GLAVA
else
	sudo cp -r $SRCDIR/extras/glava $GLAVA
fi

#Copying yt-dlp's config to /etc.
sudo cp $SRCDIR/extras/yt-dlp.conf /etc

#appying the themes.
THEMES=/usr/share/themes
ICONS=/usr/share/icons
GTK2=/etc/gtk-2.0
GTK3=/etc/gtk-3.0

#Creating the themes folder if it doesn't exist. And applying the themes.
if [[ ! -d "$THEMES" || ! -d "$THEMES/Default" ]]; then
	sudo mkdir $THEMES && sudo mkdir $THEMES/Default && sudo cp -r $SRCDIR/extras/themes/Sweet-Dark-v40 $THEMES && sudo cp -r $SRCDIR/extras/themes/index.theme $THEMES/Default
else
	sudo cp -R $SRCDIR/extras/themes/Sweet-Dark-v40 $THEMES && sudo cp -r $SRCDIR/extras/themes/index.theme $THEMES/Default
fi

#Same as above, but these are icons instead of themes. 
if [[ ! -d "$ICONS" ]]; then
	sudo mkdir $ICONS && sudo cp -r $SRCDIR/extras/themes/MB-Plum-Suru-GLOW $ICONS && sudo cp -r $SRCDIR/extras/themes/Sweet-cursors $ICONS
fi

#Creating the gtk2 config folder if it doesn't exist. And applying the config.
if [[ ! -d "$GTK2" ]]; then
	sudo mkdir $GTK2 && sudo cp $SRCDIR/extras/themes/gtkrc $GTK2
else
	sudo cp $SRCDIR/extras/themes/gtkrc $GTK2
fi

#Same as above, but it's gtk3.
if [[ ! -d "$GTK3" ]]; then
	sudo mkdir $GTK3 && sudo cp $SRCDIR/extras/themes/settings.ini $GTK3
else
	sudo cp $SRCDIR/extras/themes/settings.ini $GTK3
fi

#Compiling dwm, and it's gremlins + applying xinit's config.
cd $SRCDIR/dwm && sudo make install &&
cd $SRCDIR/slstatus && sudo make install &&
cd $SRCDIR/dmenu && sudo make install &&
cd $SRCDIR/st && sudo make install &&
cp $SRCDIR/extras/xinirc $HOME/.xinitrc

#Final steps.
echo "Everything done."
echo "Do you wish to download all of wine's dependencies? (This is mainly for gaming.(You need to enable multilib.))"
echo "1)Yes
      2)No\n
      -->  "

read end
if [[ $end == 2 ]] then
	exit
elif [[ $end == 1 && $DISTRO == 1 ]] then
	bash $SRCDIR/extras/GOOWDH-Void

elif [[ $end == 1 && $DISTRO == 2 ]] then
	bash $SRCDIR/extras/GOOWDH-Arch
else
	echo "something went wrong. perhaps you should check your internet connection"
fi

echo "all done."
