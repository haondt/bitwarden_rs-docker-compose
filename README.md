# Set up [Bitwarden_rs](https://github.com/dani-garcia/bitwarden_rs) with [docker-compose](https://docs.docker.com/compose/)

# DEPRECATED

I have since integrated this repo into my homelab IaC environment: https://github.com/haondt/Gabbro

### Features

* bitwarden_rs
* nginx -> forwards http and https to bitwarden_rs:80. Some applications, like the chrome webapp, won't work without ssl. Other programs, like the bitwarden desktop client won't work with a self-signed certificate, but will work without ssl. If you have a certificate signed by a trusted CA, you can remove the port 80 proxying from `nginx.conf`.
* rclone script -> 5 count rolling backup of the encrypted database to the `/home/bitwarden/bitwarden/backups/` directory, plus uploading backups via rclone.

### Dependencies

```
docker
docker-compose
sqlite3
rclone
```

### Guide

This setup uses `/home/bitwarden/bitwarden/` as a working directory.

Create the directory bitwarden_rs will use

```bash
mkdir /bw-data
```

Clone and move the repo

```bash
git clone https://github.com/haondt/bitwarden_rs-docker-compose
mv bitwarden_rs-docker-compose /home/bitwarden/bitwarden
```

Generate a signed certificate using your method of choice.
Put the certificate and key in `/home/bitwarden/bitwarden/nginx/cert.crt` and `/home/bitwarden/bitwarden/nginx/key.key`. 


Run bitwarden_rs and nginx with your standard docker-compose

```bash
cd /home/bitwarden/bitwarden
docker-compose up -d
```

Make sure you have write permission on the sqlite3 db

```bash
chmod ug+=rw /bw-data/db.sqlite3
```

Daily db backups can be enabled with crontab. The script uses rclone to send it to `google:bitwarden`, edit the script as you need, depending on your rclone setup.

```
crontab -e

Add this line:
0 0 * * * /home/bitwarden/bitwarden/backups/backup.sh
```

The stack can be started on boot with systemctl 

```
cp /home/bitwarden/bitwarden/bitwarden.service /etc/systemd/system/
sudo systemctl enable bitwarden
sudo systemctl start bitwarden
``` 
