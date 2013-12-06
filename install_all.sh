set -e
npm install
./node_modules/.bin/docpad generate --env static
cd hubo-ach_server
./install.sh
cp -R ./out/* /var/www/hubo
