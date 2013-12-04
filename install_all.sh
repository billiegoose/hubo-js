set -e
npm install
docpad generate --env static
cd hubo-ach_server
./install.sh
echo "Copy the contents of drchubo.js/out/drc to Apache."
