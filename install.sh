#!/bin/bash

echo "Wich distro are you using? 
1)Void	2)Arch"

read DISTRO 

echo "
Installing dependencies."
case $DISTRO in
	1)
		sudo xbps-install -S alacritty dbus xrandr sxhkd picom yt-dlp dunst nitrogen flameshot brillo make cmake gcc psmisc xorg-minimal libXft-devel libXcursor-devel libXrandr-devel libXinerama-devel libXfont-devel libXfont2-devel pkg-config glava font-awesome6 font-hack-ttf void-repo-multilib void-repo-nonfree void-repo-multilib-nonfree gtk+ gtk+3 git wget
		;;
	2)
		sudo pacman -Sy --needed alacritty dbus xrandr sxhkd picom yt-dlp dunst nitrogen flameshot make cmake gcc xorg pkgconf glava ttf-hack ttf-font-awesome gtk2 gtk3 git wget
		;;
esac

echo "

Applying the custom configs."
SRCDIR="$(pwd)"

DUNST=/etc/dunst
SXHKD=$HOME/.config/sxhkd
GLAVA=/etc/xdg/glava
ALARITTY=$HOME/.config/alacritty/

#Checking for your skill issues. 
if [[ ! -d "$SRCDIR/extras" ]]; then
	echo "
	Run the script inside its folder." && exit
fi

#Creating dunst's config folder if it doesn't exist. And applying its config.
echo "
Applying dunst's config."
if [[ ! -d "$DUNST" ]]; then
        sudo mkdir $DUNST && sudo cp $SRCDIR/extras/configs/dunstrc $DUNST
else
	sudo cp $SRCDIR/extras/configs/dunstrc $DUNST
fi

#Same as above, but it's sxhkd.
echo "
Applying sxhkd's config."
if [[ ! -d "$SXHKD" ]]; then
	mkdir $SXHKD && cp $SRCDIR/extras/configs/sxhkdrc $SXHKD
else
	cp $SRCDIR/extras/configs/sxhkdrc $DUNST
fi

#Same as above, but it's glava.
echo "
Applying glava's config."
if [[ ! -f "$GLAVA" ]]; then
	sudo rm -rf $GLAVA && sudo cp -r $SRCDIR/extras/configs/glava $GLAVA
else
	sudo cp -r $SRCDIR/extras/configs/glava $GLAVA
fi

#Same as above, but it's alacritty.
echo "
Applying alacritys's config."
if [[ ! -d "$ALACIRTTY" ]]; then
	sudo mkdir $ALACRITTY && sudo cp $SRCDIR/extras/configs/alacritty.yml $ALACRITTY
else
	sudo cp $SRCDIR/extras/configs/alacritty.yml $ALACRITTY
fi

#Copying yt-dlp's config to /etc. And copying picom's config to /etc/xdg.
echo "
Applying yt-dlp's config." 
sudo cp $SRCDIR/extras/configs/yt-dlp.conf /etc &&
echo "
Applying picom's config."
sudo cp $SRCDIR/extras/configs/picom.conf /etc/xdg

#appying the themes.
THEMES=/usr/share/themes
ICONS=/usr/share/icons
GTK2=/etc/gtk-2.0
GTK3=/etc/gtk-3.0

#Creating the themes folder if it doesn't exist. And applying the themes.
echo "
Applying themes."
if [[ ! -d "$THEMES" || ! -d "$THEMES/Default" ]]; then
	sudo mkdir $THEMES && sudo mkdir $THEMES/Default && sudo cp -r $SRCDIR/extras/themes/Sweet-Dark-v40 $THEMES && sudo cp -r $SRCDIR/extras/themes/index.theme $THEMES/Default
else
	sudo cp -r $SRCDIR/extras/themes/Sweet-Dark-v40 $THEMES && sudo cp $SRCDIR/extras/themes/index.theme $THEMES/Default
fi

#Same as above, but these are icons instead of themes. 
echo "
Applying icons"
if [[ ! -d "$ICONS" ]]; then
	sudo mkdir $ICONS && sudo cp -r $SRCDIR/extras/themes/MB-Plum-Suru-GLOW $ICONS && sudo cp -r $SRCDIR/extras/themes/Sweet-cursors $ICONS
else
	sudo cp -r $SRCDIR/extras/themes/MB-Plum-Suru-GLOW $ICONS && sudo cp -r $SRCDIR/extras/themes/Sweet-cursors $ICONS
fi

#Creating the gtk2 config folder if it doesn't exist. And applying its config.
echo "
Applying gtk2's config."
if [[ ! -d "$GTK2" ]]; then
	sudo mkdir $GTK2 && sudo cp $SRCDIR/extras/themes/gtkrc $GTK2
else
	sudo cp $SRCDIR/extras/themes/gtkrc $GTK2
fi 	#Have you ever noticed that programmers are people who are just really good at grammar? Like. Pro... Grammar... Get it?

#Same as above, but it's gtk3.
echo "
Applying gtk3's config."
if [[ ! -d "$GTK3" ]]; then
	sudo mkdir $GTK3 && sudo cp $SRCDIR/extras/themes/settings.ini $GTK3
else
	sudo cp $SRCDIR/extras/themes/settings.ini $GTK3
fi

#Compiling some good stuff.
#Some of these are unneeded right now. But they might come in handy IF i start experimenting with some other distros.
echo "
Preparing git repositories.
"
mkdir $SRCDIR/builds

NITROGEN_GIT=https://github.com/l3ib/nitrogen.git
PICOM_GIT=https://github.com/yshui/picom.git
DUNST_GIT=https://github.com/dunst-project/dunst.git 
SXHKD_GIT=https://github.com/baskerville/sxhkd.git
XSCT_GIT=https://github.com/X11-good-tools/xsct.git
BRILLO_GIT=https://github.com/CameronNemo/brillo.git
FLAMESHOT_GIT=https://github.com/flameshot-org/flameshot.git
ALACRITTY_GIT=https://github.com/alacritty/alacritty

cd $SRCDIR/builds

if [[ $DISTRO == 1 ]]; then
	git clone $XSCT_GIT && cd xsct && echo "
	Compiling xsct." && sudo make install

elif [[ $DISTRO == 2 ]]; then
	git clone $XSCT_GIT && git clone $BRILLO_GIT && cd xsct && echo "
	Compiling xsct." && sudo make install && cd ../brillo && echo "
	Compiling brillo." && sudo make install
fi
	

#Compiling dwm, and its gremlins.
echo "
Compiling dwm, slstatus, dmenu and st.

"
cd $SRCDIR/dwm && sudo make install
cd $SRCDIR/slstatus && sudo make install
cd $SRCDIR/dmenu && sudo make install
cd $SRCDIR/st && sudo make install

#Checking if .xinitrc exists. If it does, then it renames it, and applies a new one. 
echo "
Applying xinit's config."
if [[ -f "$HOME/.xinitrc" ]]; then
	mv $HOME/.xinitrc $HOME/.xinitrc-old && cp $SRCDIR/extras/configs/xinitrc $HOME/.xinitrc && cd
else
	cp $SRCDIR/extras/configs/xinitrc $HOME/.xinitrc && cd
fi

#Final steps.
#Gayming.
echo "

Would you like to download all of wine's dependencies? (This is mainly for gaming. (You need to enable multilib.))"
echo "1)Yes 2)No"

read end
if [[ $end == 2 ]]; then
	echo "
Quite rare." 

elif [[ $end == 1 && $DISTRO == 1 ]]; then
	bash $SRCDIR/extras/GOOWDH-Void

elif [[ $end == 1 && $DISTRO == 2 ]]; then
	bash $SRCDIR/extras/GOOWDH-Arch
fi

#"Oh my bash"... The conumdrum... Of life.
echo "

Would you like to install Oh my bash? (It's the bash shell, but it's more responsive, and nicer to use.)"
echo "1)Yes 2)No"

read omb

case $omb in
	1)
		bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
		;;
	2)
		echo "
		Perhaps you should.
		"
		;;
esac 				#Perhaps you REALLY should.
