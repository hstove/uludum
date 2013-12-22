heroku pgbackups:capture --expire
rm -r backups
mkdir backups
curl -o backups/latest.dump `heroku pgbackups:url`
pg_restore -d ludum_development backups/latest.dump -c -C
rake db:migrate
rm -r backups