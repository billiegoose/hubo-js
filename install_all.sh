set -e
npm install
./node_modules/.bin/docpad generate --env static
cp -R ./out/* /var/www/hubo
cd hubo-ach_server
./install.sh
