#!/bin/bash


create() {
    mutagen create --name=m23 --default-group-beta=www-data --default-owner-beta=www-data --sync-mode=two-way-resolved --default-file-mode=0664 --default-directory-mode=0755 --symlink-mode=posix-raw $* docker://root@m23/var/www/html/shared/
}

pause() {
    mutagen pause m23
}

resume() {
    mutagen resume m23
}

terminate() {
    mutagen terminate m23
}

list() {
    mutagen list
}

howTo() {
    echo ""
    echo " +---------------------------------------------------------------------------------------------------------------------------------------------+"
    echo " | To create mutagen session you need to use 'create' command together with the path to your working directory on your local machine, example: |"
    echo " +---------------------------------------------------------------------------------------------------------------------------------------------+"
    echo " +-----------------------------------------UNIX----------------------------------------------------------+"
    echo " | sh mutagen_session.sh create /Users/<YOUR_USER>/<PATH>/<TO>/<YOUR>/magento/magento2-dev-dk/instances/ |"
    echo " +-------------------------------------------------------------------------------------------------------+"
    echo " +-----------------------------------------Windows-----------------------------------+"
    echo " | bash mutagen_session.sh create C:\PATH\TO\YOUR\magento\magento2-dev-dk\instances\ |"
    echo " +-----------------------------------------------------------------------------------+"
    echo ""
    echo " +--------------------------------------------------------------------+"
    echo " | To pause mutagen session you need to use 'pause' command, example: |"
    echo " +--------------------------------------------------------------------+"
    echo " +-------------UNIX------------+"
    echo " | sh mutagen_session.sh pause |"
    echo " +-----------------------------+"
    echo " +------------Windows------------+"
    echo " | bash mutagen_session.sh pause |"
    echo " +-------------------------------+"
    echo ""
    echo " +---------------------------------------------------------------------+"
    echo " | To resume mutagen session you need to use 'pause' command, example: |"
    echo " +---------------------------------------------------------------------+"
    echo " +-------------UNIX-------------+"
    echo " | sh mutagen_session.sh resume |"
    echo " +------------------------------+"
    echo " +--------------Windows-----------+"
    echo " | bash mutagen_session.sh resume |"
    echo " +--------------------------------+"
    echo ""
    echo " +------------------------------------------------------------------------+"
    echo " | To terminate mutagen session you need to use 'pause' command, example: |"
    echo " +------------------------------------------------------------------------+"
    echo " +---------------UNIX--------------+"
    echo " | sh mutagen_session.sh terminate |"
    echo " +---------------------------------+"
    echo " +--------------Windows--------------+"
    echo " | bash mutagen_session.sh terminate |"
    echo " +-----------------------------------+"
    echo ""
    echo " +--------------------------------------------------------------------+"
    echo " | To list mutagen sessions you need to use 'pause' command, example: |"
    echo " +--------------------------------------------------------------------+"
    echo " +------------UNIX------------+"
    echo " | sh mutagen_session.sh list |"
    echo " +----------------------------+"
    echo " +-----------Windows------------+"
    echo " | bash mutagen_session.sh list |"
    echo " +------------------------------+"
    echo ""
}

case "$1" in
    create)
    shift 1
    create $*
    ;;

    pause)
    pause
    ;;

    resume)
    resume
    ;;

    terminate)
    terminate
    ;;

    list)
    list
    ;;

    *)
    howTo
    ;;
esac

exit 0