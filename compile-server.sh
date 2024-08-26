#!/bin/bash

# Function to get the script directory
get_script_directory() {
    echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

# Define the source and destination directories relative to the script's location
my_dir=$(get_script_directory)
script_dir="$my_dir/work/server/"
source_dir="$script_dir/src"
destination_dir="./serverout"
jar_file_path="$destination_dir/server.jar"
main_class="com.mojang.minecraft.server.MinecraftServer"  # Replace with your main class package and name

# Prepare output directory
echo "Preparing output directory..."
rm -rf "$destination_dir"
mkdir -p "$destination_dir"

# Function to copy items safely
copy_item_safely() {
    local source="$1"
    local destination="$2"
    if [ "$source" != "$destination" ]; then
        cp -R "$source" "$destination"
    fi
}

# Copy files and directories from source to destination, excluding .java files
find "$source_dir" -type d | while read -r dir; do
    relative_path="${dir#$source_dir/}"
    mkdir -p "$destination_dir/$relative_path"
done

find "$source_dir" -type f ! -name "*.java" | while read -r file; do
    relative_path="${file#$source_dir/}"
    destination_path="$destination_dir/$relative_path"
    copy_item_safely "$file" "$destination_path"
done

# Compile Java source code
echo "Compiling Java source code..."
find "$source_dir" -name "*.java" | xargs javac -d "$destination_dir" -sourcepath "$source_dir"

# Create MANIFEST.MF file
manifest_content="Main-Class: $main_class"
manifest_file_path="$destination_dir/MANIFEST.MF"
echo "$manifest_content" > "$manifest_file_path"

# Create JAR file
echo "Creating JAR file..."
jar -cfm "$jar_file_path" "$manifest_file_path" -C "$destination_dir" .
