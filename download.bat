@echo off
echo Downloading minecraft_classic_server.zip...
curl -LSso jars/server/minecraft_classic_server.zip "https://web.archive.org/web/20130119200903id_/http://s3.amazonaws.com/MinecraftDownload/minecraft_classic_server.zip"
bin\7za.exe x jars/server/minecraft_classic_server.zip -aoa -ojars/server