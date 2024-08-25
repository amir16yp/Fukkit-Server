#!/bin/sh
echo "Downloading minecraft.jar..."
curl -LSso jars/client/minecraft.jar https://web.archive.org/web/20130329205246id_/https://s3.amazonaws.com/MinecraftDownload/classic/minecraft.jar
echo "Downloading minecraft_classic_server.zip..."
curl -LSso jars/server/minecraft_classic_server.zip https://web.archive.org/web/20130119200903id_/http://s3.amazonaws.com/MinecraftDownload/minecraft_classic_server.zip
sha256sum -c <<-EOF
	3bfaa9ceccfd49f62d4c1863d5cd565c24de1f83bab982a38e4811ac369993a5 *jars/client/minecraft.jar
	f68691ab8252950c2a51039acb9a22199e9a3c151c73b63990d16b5771283089 *jars/server/minecraft_classic_server.zip
EOF
7za x jars/server/minecraft_classic_server.zip -aoa -ojars/server
