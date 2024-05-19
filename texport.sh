#!/bin/bash

# Check if Inkscape and ImageMagick are installed
if ! command -v inkscape &> /dev/null
then
    echo "Inkscape could not be found. Please install it first."
    exit 1
fi

if ! command -v convert &> /dev/null
then
    echo "ImageMagick could not be found. Please install it first."
    exit 1
fi

# Create output directory
mkdir -p icons

# Generate duplicate entries sharing the same SVG
pwd
cd ./svgs
cp -v sfc.svg sufami.svg
cp -v sfc.svg satella.svg
cp -v md.svg segacd.svg

# Loop over all SVG files in the current directory
echo "Generating console icons"
for svg_file in *.svg; do
    # Remove file extension for the output file name
    base_name=$(basename "$svg_file" .svg)
    
    # Convert SVG to PNG with width 48 and height 48 (preserve aspect ratio)
    inkscape "$svg_file" --export-type=png --export-width=110 --export-height=110 --export-filename="${base_name}_temp.png"
    
    # Create a new PNG with dimensions 120x130 and place the 48x48 image at the top center
    convert -size 120x130 xc:none "${base_name}_temp.png" -geometry +5+0 -composite "../icons/${base_name}.png"
    
    # Remove temporary file
    rm "${base_name}_temp.png"
done
pwd

# Delete duplicate entries
rm -v satella.svg sufami.svg segacd.svg

cd ../app_svgs
echo "Generating app icons"

for svg_file in *.svg; do
    # Remove file extension for the output file name
    base_name=$(basename "$svg_file" .svg)
    # Convert SVG to PNG with width 48 and height 48 (preserve aspect ratio)
    inkscape "$svg_file" --export-type=png --export-width=74 --export-height=74 --export-filename="../icons/app/${base_name}.png"
done


echo "Conversion completed. Check the 'icons' directory for the PNG files."

