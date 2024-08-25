#!/bin/bash

# Base directories
WORK_DIR=$(pwd)"/work/server"
OUTPUT_DIR=$(pwd)"/output/server"
PATCHES_DIR=$(pwd)"/patches/server"

# Function to generate patches from ./output/server/ to ./work/server/
generate_patches() {
    echo "Generating patches from $OUTPUT_DIR to $WORK_DIR recursively"
    mkdir -p "$PATCHES_DIR"

    # Generate patches for files in ./output/server/ compared to ./work/server/
    cd "$OUTPUT_DIR"
    find . -type f | while read -r file; do
        relative_path="${file#./}"
        patch_file="$PATCHES_DIR/${relative_path}.patch"
        patch_dir=$(dirname "$patch_file")
        mkdir -p "$patch_dir"
        
        dos2unix "$file"
        
        if [ -f "$WORK_DIR/$relative_path" ]; then
            dos2unix "$WORK_DIR/$relative_path"
            diff -Naur --label "a/$relative_path" --label "b/$relative_path" "$file" "$WORK_DIR/$relative_path" > "$patch_file"
            
            if [ ! -s "$patch_file" ]; then
                rm "$patch_file"
            fi
        else
            echo "File removed: $relative_path" > "$patch_file"
        fi
    done
    cd - > /dev/null

    # Copy new files and directories from work/ to patches/ as .new
    cd "$WORK_DIR"
    find . -type f | while read -r file; do
        relative_path="${file#./}"
        if [ ! -f "$OUTPUT_DIR/$relative_path" ]; then
            mkdir -p "$(dirname "$PATCHES_DIR/$relative_path")"
            cp "$file" "$PATCHES_DIR/${relative_path}.new"
        fi
    done
    cd - > /dev/null
}

# Function to apply patches to ./work/server/
apply_patches() {
    echo "Applying patches to $WORK_DIR recursively"
    
    # First, copy all files from OUTPUT_DIR to WORK_DIR
    echo "Copying files from $OUTPUT_DIR to $WORK_DIR"
    mkdir -p "$WORK_DIR"
    
    # Remove files in WORK_DIR that don't exist in OUTPUT_DIR
    find "$WORK_DIR" -type f | while read -r file; do
        relative_path="${file#$WORK_DIR/}"
        if [ ! -f "$OUTPUT_DIR/$relative_path" ]; then
            rm "$file"
        fi
    done
    
    # Copy files from OUTPUT_DIR to WORK_DIR
    cd "$OUTPUT_DIR"
    find . -type f | while read -r file; do
        relative_path="${file#./}"
        mkdir -p "$(dirname "$WORK_DIR/$relative_path")"
        cp "$file" "$WORK_DIR/$relative_path"
    done
    cd - > /dev/null
    
    # Apply patches
    find "$PATCHES_DIR" -name "*.patch" | while read -r patch_file; do
        relative_path="${patch_file#$PATCHES_DIR/}"
        relative_path="${relative_path%.patch}"
        
        if grep -q "File removed:" "$patch_file"; then
            echo "Removing file: $relative_path"
            rm -f "$WORK_DIR/$relative_path"
        else
            patch_dir=$(dirname "$WORK_DIR/$relative_path")
            mkdir -p "$patch_dir"
            
            dos2unix "$patch_file"
            
            if [ -f "$WORK_DIR/$relative_path" ]; then
                dos2unix "$WORK_DIR/$relative_path"
                patch -p1 -d "$WORK_DIR" --no-backup-if-mismatch < "$patch_file" || echo "Failed to apply patch: $patch_file"
            fi
        fi
    done

    # Copy .new files from patches/ to work/
    find "$PATCHES_DIR" -name "*.new" | while read -r new_file; do
        relative_path="${new_file#$PATCHES_DIR/}"
        relative_path="${relative_path%.new}"
        
        target_dir=$(dirname "$WORK_DIR/$relative_path")
        mkdir -p "$target_dir"
        
        cp "$new_file" "$WORK_DIR/$relative_path"
        dos2unix "$WORK_DIR/$relative_path"
    done
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to ensure required tools are installed
ensure_tools() {
    if ! command_exists dos2unix; then
        echo "Error: dos2unix is not installed. Please install it first."
        exit 1
    fi
}

# Main execution
ensure_tools

# The script will not automatically run any functions.
# You should call the desired function(s) from other scripts that source this file.

# Example usage:
# generate_patches
# apply_patches