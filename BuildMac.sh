#!/bin/bash
buildImages()
{
    echo
    echo ------------------------------
    echo Creating Ellipsis Build Folder
    if [ -d BUILD ]; then
        rm -r BUILD
    fi
    mkdir -p BUILD/skin.ellipsis/media
    if [ $1  -eq 1 ] || [ $1  -eq 3 ]; then
        echo ------------------------------
        echo Copying Image Files...
        cp -r media/Default/ BUILD/skin.ellipsis/media
    fi
    if [ $1  -eq 2 ] || [ $1  -eq 4 ]; then
        echo ------------------------------
        echo Creating XBT File...
        ./media/TexturePackerMac/TexturePacker.sh
        echo ------------------------------
        echo Copying XBT Files...
        mv -f media/*.xbt BUILD/skin.ellipsis/media
    fi
    echo ------------------------------
    echo Building Skin Directory...
    cp -r 1080i BUILD/skin.ellipsis/1080i
    cp -r colors BUILD/skin.ellipsis/colors
    cp -r fonts BUILD/skin.ellipsis/fonts
    cp -r sounds BUILD/skin.ellipsis/sounds
    cp -r language BUILD/skin.ellipsis/language
    cp *.xml BUILD/skin.ellipsis
    cp *.txt BUILD/skin.ellipsis
    cp *.txt BUILD
    cp icon.png BUILD/skin.ellipsis
    cp fanart.png BUILD/skin.ellipsis
    echo ------------------------------
    echo Making Revision.xml Include
    echo "<includes>" > BUILD/skin.ellipsis/1080i/Revision.xml
    echo "    <include name='Revision'>" >> BUILD/skin.ellipsis/1080i/Revision.xml
    echo "        <label>Ellipsis [Compiled : date time]</label>" >> BUILD/skin.ellipsis/1080i/Revision.xml
    echo "    </include>" >> BUILD/skin.ellipsis/1080i/Revision.xml
    echo "</includes>" >> BUILD/skin.ellipsis/1080i/Revision.xml
    if [ $1  -eq 3 ] || [ $1  -eq 4 ] || [ $1  -eq 5 ]; then
        ps -cx -o pid,command | {
            while read pid command
            do
                if [ "$command" = "KODI" ]; then
                    echo ------------------------------
                    echo Killing KODI...
                    killall KODI
                    echo ------------------------------
                    echo Waiting for KODI to close...
                    while kill -0 "$pid"; do
                        sleep 0.5
                    done
                    break
                fi
            done
        }
        echo ------------------------------
        echo Copying Files...
        mkdir -p "$HOME/Library/Application Support/Kodi/addons/skin.ellipsis"
        if [ $1  -eq 3 ] || [ $1  -eq 4 ]; then
            rm -r "$HOME/Library/Application Support/Kodi/addons/skin.ellipsis/"
        fi
        cp -r BUILD/skin.ellipsis "$HOME/Library/Application Support/Kodi/addons/skin.ellipsis"
        rm -r BUILD
        echo ------------------------------
        echo Restarting KODI...
        open -a /Applications/Kodi.app
    fi
    echo ------------------------------
    echo
    echo Build Complete - Check above for errors.
    echo
}

cd $(dirname $0)
while [ true ]
do
    echo ------------------------------
    echo Ellipsis Build Menu
    echo ------------------------------
    echo
    echo   1 = Build \(Images\)
    echo   2 = Build \(XBT\)
    echo   3 = Build to Kodi \(Images\)
    echo   4 = Build to Kodi \(XBT\)
    echo   5 = Build to Kodi \(No Textures\)
    echo   6 = Exit
    echo
    echo -n "Your choice: "
    read answer
    case $answer in
        1) buildImages 1;;
        2) buildImages 2;;
        3) buildImages 3;;
        4) buildImages 4;;
        5) buildImages 5;;
        6) break;;
    esac
done

