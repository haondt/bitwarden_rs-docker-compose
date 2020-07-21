Make sure you generate a key and certificate for nginx ssl.
Put them in `bitwarden/nginx/cert.crt` and `bitwarden/nginx/key.key'. 

Daily db backups can be enabled with crontab. Make sure you set up rclone first.

```crontab
0 0 * * * /home/bitwarden/bitwarden/backups/backup.sh
```

The stack can be run with systemctl. 

```
cp bitwarden.service /etc/systemd/system
sudo systemctl enable bitwarden
sudo systemctl start bitwarden
``` 
