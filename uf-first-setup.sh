#! /bin/env sh
#
# Updated by December 15th, 2022
#
# Written by Mikhail Patricio Ortiz-Lunyov
# This SH script is licensed under the GNU Public License Version 3 (GPLv3).
# More information about license in readme and bottom.

# Checks for root user
RootCheck() {
    # Checks whoami
    if [ "$(whoami)" != "root" ] ; then
        # Alerts user to lack of root execution
        printf "\e[1mMISSING ROOT!\e[0m\n"
        # Gives user advices for intended use
        echo "Update_Full is intended to be used by sysadmins and others authorized to update Linux and UNIX-based systems."
        echo "As such, it is best for the script to have limited writing and executing permissions."
        echo "This first setup script changes the script's permission."
        printf "\nAs such, this script needs to be executed as root to improve the update_full's permissions.\n"
        exit 0
    else
        echo "Script run as root..."
    fi
}

# Sets default (root) settings
DefaultSettings() {
    # Sets owner
    OWNERNAME="root"
    # Sets group
    GROUPNAME="root"
    chown $OWNERNAME:$GROUPNAME $SCRIPTNAME
    chmod 744 $SCRIPTNAME
}

# Sets custom settings for chown
CustomChown() {
    # Starts loop
    Q_LOOP1=true
    while [ "$Q_LOOP1" = true ] ; do
        read -p "File owner name: " OWNERNAME
        read -p "File group name: " GROUPNAME
        chown $OWNERNAME:$GROUPNAME $SCRIPTNAME
        if [ "$?" != "0" ] ; then
            clear
            echo "Something went wrong, try again!"
        else
            Q_LOOP1=false
        fi
    done
}

# Sets custom settings for Chmod
CustomChmod() {
    # Starts loop
    Q_LOOP2=true
    while [ "$Q_LOOP2" = true ] ; do
        read -p "Owner rights code: " OWNERRIGHTS
        read -p "Group rights code: " GROUPRIGHTS
        read -p "Others rights code: " OTHERSRIGHTS
        chmod $OWNERRIGHTS$GROUPRIGHTS$OTHERSRIGHTS $SCRIPTNAME
        if [ "$?" != "0" ] ; then
            clear
            echo "Something went wrong, try again!"
        else
            Q_LOOP2=false
        fi
    done
}

# Main
clear
# Runs Root check function
RootCheck
SCRIPTNAME="update_full-sh.sh"
# Start default check loop
DEFAULT_Q_LOOP=true
while [ "$DEFAULT_Q_LOOP" = true ] ; do
    echo "Do you want to use defaults ($SCRIPTNAME is owned by root, $SCRIPTNAME can only be read, writen, and executed by user (root), and read by everyone else)?"
    echo "!!!RECOMMENDED!!!"
    read -p "[Y]es/[N]o < " DEFAULT_Q
    if [ "$DEFAULT_Q" = "Y" -o "$DEFAULT_Q" = "y" -o "$DEFAULT_Q" = "Yes" -o "$DEFAULT_Q" = "yes" ] ; then
        DefaultSettings
        DEFAULT_Q_LOOP=false
    elif [ "$DEFAULT_Q" = "N" -o "$DEFAULT_Q" = "n" -o "$DEFAULT_Q" = "No" -o "$DEFAULT_Q" = "no" ] ; then
        Q_LOOP0=true
        while [ "$Q_LOOP0" = true ] ; do
            echo "What do you want to change?"
            printf "\t[1] chown (change file owner and group)\n\t[2] chmod (change file mode bits)\n\t[3] Both\n\t[4] Use defaults instead\n"
            read -p " < " Q_0
            if [ "$Q_0" = "1" ] ; then
                CustomChown
                Q_LOOP0=false
            elif [ "$Q_0" = "2" ] ; then
                CustomChmod
                Q_LOOP0=false
            elif [ "$Q_0" = "3" ] ; then
                CustomChown
                CustomChmod
                Q_LOOP0=false
            elif [ "$Q_0" = "4" ] ; then
                DefaultSettings
                Q_LOOP0=false
            fi
        done
    else
        clear
        echo "Invalid response, try again."
    fi
done
# Notifies user to changes permissions
printf "\n\e[1mPermissions changed for $SCRIPTNAME!\e[0m\n"
# Describes changes
echo "$SCRIPTNAME's owner is now '$OWNERNAME' in group '$GROUPNAME'."
printf "This script will now delf-destruct.\n\tIf you need different permissions and ownership, change it manually!\n"
rm -f $0
exit 0

# uf-first-setup.sh  Copyright (C) 2022  Mikhail Patricio Ortiz-Lunyov
#   This program comes with ABSOLUTELY NO WARRANTY.
#   This is free software, and you are welcome to redistribute it
#   under certain conditions.
