#!/bin/bash
set -e

# Check if counter file exists
if ! test -f "/home/bitwarden/bitwarden/backups/current.txt"; then
	echo -1 > /home/bitwarden/bitwarden/backups/current.txt
fi

# increment counter
cur=$(cat /home/bitwarden/bitwarden/backups/current.txt)
cur=$(($cur+1))

# loop counter
if (($cur > 5)); then
	cur=0
fi

# save counter
echo "$cur" > /home/bitwarden/bitwarden/backups/current.txt

# clone db
sqlite3 /bw-data/db.sqlite3 ".backup '/home/bitwarden/bitwarden/backups/backup_$cur.sqlite3'"

# backup db to google drive
rclone copy /home/bitwarden/bitwarden/backups/backup_$cur.sqlite3 google:bitwarden
