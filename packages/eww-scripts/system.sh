#!/usr/bin/env bash

EWW=$(which eww)

close_eww() {
	${EWW} close logout suspend lock reboot shutdown resources quotes
}

## Options #############################################
if  [[ $1 = "--lock" ]]; then
	close_eww
	loginctl lock-session "${XDG_SESSION_ID-}"

elif  [[ $1 = "--logout" ]]; then
	close_eww
    #openbox --exit
		loginctl terminate-session "${XDG_SESSION_ID-}"

elif  [[ $1 = "--suspend" ]]; then
	close_eww
	mpc pause
	systemctl suspend

elif  [[ $1 = "--reboot" ]]; then
		close_eww
    systemctl reboot

elif  [[ $1 = "--shutdown" ]]; then
		close_eww
    systemctl poweroff

## Help Menu #############################################
else
echo "
Available options:
--lock	--logout	--suspend	--reboot	--shutdown
"
fi
