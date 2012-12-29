# qt-4.7.0~git20100908-0maemo1
#!/bin/sh

## based on the original silly little script made for Qt 4.6 =)

# silly little script that fetches the Qt 4.7 libraries from Maemo's
# repositories and unpacks them into a MADDE sysroot

# Adjust MADDE_PATH to the path of your MADDE installation
# e.g. MADDE_PATH=$HOME/.madde/0.6.72/sysroots/fremantle-arm-sysroot-10.2010.19-1-slim/ 
MADDE_PATH=i_did_not_read_the_instructions

QT_VERSION=4.7.0~git20100908-0maemo1
MAEMO_REPO=http://repository.maemo.org/extras-devel/pool/fremantle/free/q/qt4-experimental

QT_LIBS="dev core dbus gui maemo5 multimedia network opengl phonon script sql sql-sqlite svg test translations webkit xml xmlpatterns declarative"

KERNEL=`uname -s`

# Check whether MADDE is installed
if [ ! -d $MADDE_PATH ] ; then
    echo "Unable to find madde in $MADDE_PATH, adjust MADDE_PATH in this script!"
    exit 1
fi

for lib in $QT_LIBS ; do

    echo "Installing Qt $lib..."

    CURRENT_DEB="$MAEMO_REPO/libqt4-experimental-${lib}_${QT_VERSION}_armel.deb"

    if [ "$KERNEL" = "Darwin" ] ; then
        # Fetch each lib using curl, extracting to stdout, piping to tar to get the data.tar.gz
        # from the ar file, then piping again to tar to extract data.tar.gz into the MADDE dir
        # Ugly? Yes :) But doesn't leave temporary files around and doesn't overuse your hard drive
        curl --progress-bar $CURRENT_DEB | tar -O -x data.tar.gz | tar -C "$MADDE_PATH" -xz
    elif [ "$KERNEL" = "Linux" ] ; then
        # GNU tar can't extract ar files directly. Use dpkg-deb to do the job, and wget instead of curl

        # remove old file first
        rm -f /tmp/libqt4-experimental-${lib}_${QT_VERSION}_armel.deb
        wget -P /tmp -nc $CURRENT_DEB || exit 1
        dpkg-deb -x /tmp/libqt4-experimental-${lib}_${QT_VERSION}_armel.deb $MADDE_PATH || exit 1
        rm -f /tmp/libqt4-experimental-${lib}_${QT_VERSION}_armel.deb
    else
        echo "Unsupported OS, this script runs only on Mac and Linux"
        exit 1
    fi
done

echo "done."
