#!/bin/bash
clear
echo "██▀ █░█ ▀█▀ █░░ █░█░█ █▀█ █▀█ ██▀"
echo "█▄▄ ▀▄▀ ▄█▄ █▄▄ █▄█▄█ █▀█ █▀▄ █▄▄"
echo 
echo "      ▀█▀ █░█ █▀▀ █▀▄▀█ █▀▀"
echo "      ░█░ █▀█ ██▄ █░▀░█ ██▄"
echo 
echo "         from viewport "
echo "        to r/unixporn <3"
echo 
echo "This theme includes customizations for"
echo "AwesomeWM, Edex-UI, Rofi, Kitty, Picom,"
echo "VSCode, Blender, Xournal++, a GTK theme,"
echo "an icon theme, and a cursor theme."
echo
echo "Select a distro:"
echo "  1. Arch based"
echo "  2. Debian based "

read -p "- " distroSelected
if [ $distroSelected -eq 1 ]; then
    echo "  Installing required packages..."
    sudo pacman -S kitty lxappearance picom rofi
else 
    sudo apt install kitty lxappearance picom rofi
fi

clear
echo "Select theme installation type:"
echo "  1. Minimal (GTK theme, icons, fonts, cursor, transparency effects, kitty terminal, rofi theme)"
echo "  2. Full (Same as minimal but including a custom Awesome Windows Manager and eDEX-UI)"

read -p "- " typeSelected
if [ $typeSelected -eq 2 ]; then
    echo "  Installing required packages..."
    if [ $distroSelected -eq 1 ]; then
        sudo pacman -S awesome maim xclip arandr git mplayer pcmanfm cmatrix
        git clone https://aur.archlinux.org/paru.git
        cd ./paru && makepkg -si && cd ..
        rm -r ./paru
        paru -S edex-ui
    else 
        sudo apt install awesome maim xclip arandr wget mplayer pcmanfm cmatrix
        wget https://github.com/GitSquared/edex-ui/releases/download/v2.2.8/eDEX-UI-Linux-x86_64.AppImage
        sudo mv ./eDEX-UI-Linux-x86_64.AppImage /usr/bin/edex-ui
        sudo chmod +x /usr/bin/edex-ui
    fi
fi

clear 
echo "Setup windows opacity: "
echo "  Now you've got the magic touch!"
echo "  Press any key, then click on any window you want to add transparency to."
echo "  Then choose an opacity value [0-100], and repeat the process."
echo "  Or press Q to skip."

while true; do
    read -s -n 1 key
    if [[ $key == "q" ]]; then
        break
    else
        windowClass=$(xprop WM_CLASS | awk -F ", " '{print $2}' | tr -d '"')
        echo "  Window class: $windowClass"
        read -p "   Opacity value [0-100]: " opacityValue
        sed -i "139i \"$opacityValue:class_g = '$windowClass'\"," ./dotfiles/home/.config/picom/picom.conf > /dev/null 2>&1
        echo "  Config updated."
        echo "  Press any key. Q to finish."
    fi
done

clear
if [ $typeSelected -eq 2 ]; then
    echo "Setup key bindings and preferred apps:"
    echo "  - win + enter -> terminal (kitty)"
    echo "  - win + d -> open program (rofi)"
    echo "  - win + s -> switch to program (rofi)"
    echo "  - win + b -> web browser (firefox)"
    echo "  - win + e -> file explorer (pcmanfm)"
    echo "  - win + shift + s -> screenshot selected area to clipboard"
    echo "  - win + c -> lateral gaps on"
    echo "  - win + v -> lateral gaps off"
    echo "  - win + q -> close window"
    echo "  - win + space -> change windows layout"
    echo "  - win + f -> fullscreen"
    echo "  - win + m -> maximize"

    echo "  Press enter to edit AwesomeWM file. Press Q to skip"
    read -s -n 1 key
    if [[ $key == "q" ]]; then
        break
    else
        nano +105 ./dotfiles/home/.config/awesome/rc.lua
        sleep 1
        echo "Done!"
        sleep 1
        clear
    fi

    echo "Setup startup programs and animations"
    echo "  If you want to have custom animations in each screen, change wallpapers,"
    echo "  setup touchscreens, or run apps automatically after booting"
    echo "  Press enter to edit startup file."
    echo "  Or just press Q to use default settings (zenbook duo settings)."
    read -s -n 1 key
    if [[ $key == "q" ]]; then
        break
    else
        nano ./dotfiles/usr/bin/startup
        sleep 1
        echo "Done!"
        sleep 1
        clear
    fi
fi

clear
echo "  Copying dotfiles & themes..."
if [ $typeSelected -eq 2 ]; then
    cp -r ./dotfiles/home/.config $HOME/
    cp ./dotfiles/home/screen* $HOME/
    sudo cp -r ./dotfiles/usr /usr
    sudo chmod +x /usr/bin/edex-start
    sudo chmod +x /usr/bin/screenshot
    sudo chmod +x /usr/bin/startup
    sudo chmod +x /usr/bin/touchsetup
    sudo chmod +x /usr/bin/stylussetup
else
    rsync -av --exclude="awesome/" ./dotfiles/home/.config $HOME/
fi
cp -r ./dotfiles/home/.themes $HOME/
cp -r ./dotfiles/home/.icons $HOME/
cp -r ./dotfiles/home/.fonts $HOME/
cp -r ./dotfiles/home/.vscode $HOME/

clear
echo "Change appearance settings: "
echo "  Lxappearance will open."
echo "  If you want to use the GTK theme, select EVILWARE under the Widget tab and"
echo "  change the default font to Terminess Nerd Font."
echo "  If you want to use the custom icons, go to the Icon Theme tab and select EVILWARE."
echo "  Finally, if you want to use the custom cursor, go to the Mouse Cursor tab, click on"
echo "  Install, and then choose the tar.gz file from the cursor_theme folder."
lxappearance > /dev/null 2>&1

clear
echo "Nice!, now you just have to change the default windows manager to AwesomeWM"
echo
echo "RECOMMENDATIONS:"
echo "  If you decided to set applications to open at boot, i recommend not moving the"
echo "  cursor until they’ve all finished opening to avoid any mess. "
echo "  Also if you have any trouble with the multiple screen settings, you can use"
echo "  aRandr to change screens positions and then export it as a script to add in /usr/bin/startup"
echo
echo "EXTRA:"
echo "  If you use blender, i let you a custom EVILWARE theme in the ./blender_theme folder"
echo "  Also you can use the Cyan Black theme in visual studio code if you want"
echo
echo "Enjoy your trip to cyber insanity"
echo "- viewport"