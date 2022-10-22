#!/bin/bash

echo "Wich distro are you using? 
1)Void	2)Arch"


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
	sudo cp -r $SRCDIR/extras/themes/Sweet-Dark-v40 $THEMES && sudo cp $SRCDIR/extras/themes/index.theme $THEMES/Default
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

#Compiling some good stuff.
#Some of these are unneeded right now. But they might come in handy IF i start experimenting with some other distros.
mkdir $SRCDIR/builds

NITROGEN_GIT="https://github.com/l3ib/nitrogen.git"
PICOM_GIT="https://github.com/yshui/picom.git"
DUNST_GIT="https://github.com/dunst-project/dunst.git" 	#As a developer. You can put these types of crappy messages anywere. It's so nice. 
SXHKD_GIT="https://github.com/baskerville/sxhkd.git"
XSCT_GIT="https://github.com/X11-good-tools/xsct.git"
BRILLO_GIT="https://github.com/CameronNemo/brillo.git"
FLAMESHOT_GIT="https://github.com/flameshot-org/flameshot.git"

cd $SRCDIR/builds

if [[ $DISTRO == 1 ]]; then
	git clone $XSCT_GIT && cd xsct && sudo make install && sudo mv xsct /usr/local/bin

elif [[ $DISTRO == 2 ]]; then
	git clone $XSCT_GIT && git clone $BRILLO_GIT && cd xsct && sudo make install && sudo mv xsct /usr/local/bin && cd ../brillo && sudo make install
fi
	

#Compiling dwm, and it's gremlins + applying xinit's config.
cd $SRCDIR/dwm && sudo make install &&
cd $SRCDIR/slstatus && sudo make install &&
cd $SRCDIR/dmenu && sudo make install &&
cd $SRCDIR/st && sudo make install &&
mv $HOME/.xinitrc $HOME/.xinitrc-old && cp $SRCDIR/extras/xinirc $HOME/.xinitrc && cd $HOME


#Final steps.
#Gayming.
echo "Would tou like to download all of wine's dependencies? (This is mainly for gaming.(You need to enable multilib.))"
echo "1)Yes 2)No"

read end
if [[ $end == 2 ]] then
	echo "Skipping...." #Skipping DEZNUTZ

elif [[ $end == 1 && $DISTRO == 1 ]] then
	bash $SRCDIR/extras/GOOWDH-Void

elif [[ $end == 1 && $DISTRO == 2 ]] then
	bash $SRCDIR/extras/GOOWDH-Arch
else
	echo "something went wrong. perhaps you should check your internet connection"
fi


echo "Would you like to install Oh my bash? (It's the bash shell, but it's more responsive and nicer to use.)"
echo "1)Yes 2)No"

read omb

case $omb in
	1)
		bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
		;;
	2)
		echo "Perhaps you should."
		;;
esac 				#Perhaps you REALLY should.

echo "all done." #Ok, but when is despacito 2 going to release?
