set -e
npm install
./node_modules/.bin/docpad generate --env static
cd hubo-ach_server
./install.sh
echo "Copy the contents of drchubo.js/out/drc to Apache."
