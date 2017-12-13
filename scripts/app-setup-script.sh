#!/bin/bash
# Bash Menu Script for installing services alongside testchain...

PS3='Please enter your selection: '
options=("management interface" "test apps" "block explorer" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "management interface")
            echo "now installing the management interface for your blockchain"
            ;;
        "test apps")
            echo "now installing test apps"
            ;;
        "block explorer")
            echo "installing and starting up block explorer"
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
