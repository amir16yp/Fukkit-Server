#!/bin/sh
echo "Minecraft Classic Development Pack v1.0 by Oliver Yasuna (oyasunadev)"
decompile() {
	side="$1"
	jarname="$2"
	if [ -f "jars/${side}/${jarname}.jar" ]; then
		echo "Decompiling the minecraft ${side}..."
		mkdir -p temp logs
		java -jar bin/jarjar-1.1.jar process \
			"config/${side}jarjar.rules" \
			"jars/${side}/${jarname}.jar" \
			"temp/${jarname}jj.jar"
		java -jar bin/retroguard.jar \
			"temp/${jarname}jj.jar" \
			"temp/${jarname}jjrg.jar" \
			"config/${side}retroguard.rgs" \
			"logs/${side}-retro.log"
		rm -rf "output/${side}"
		mkdir -p "output/${side}"
		cp "temp/${jarname}jjrg.jar" "output/${side}/${jarname}.jar"
		java -jar bin/fernflower.jar -dgs=1 -das=0 -ren=0 "temp/${jarname}jjrg.jar" temp/fernflower
		mkdir -p "output/${side}/src"
		7za x "temp/fernflower/${jarname}jjrg.jar" -o"output/${side}/src"
	else
		echo "${side} jar doesn't exist. Skipping..."
	fi
}

decompile client minecraft
decompile server minecraft-server

rm -rf temp
mkdir -p build/client build/server
echo "DONE WITH EVERYTHING! ENJOY!"
