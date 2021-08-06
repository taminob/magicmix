#!/bin/sh

output_name()
{
	img="$@"
	echo "$(basename "$img" .png)_out.png"
}

crop_centered()
{
	img="$1"
	new_size="$2"
	output="$(output_name $img)"
	convert "$img" -gravity center -crop "$new_size"+0+0 +repage "$output"
}

scale()
{
	img="$1"
	new_size="$2"
	output="$(output_name $img)"
	convert "$img" -resize "$new_size" "$output"
}

invert_colors()
{
	img="$1"
	output="$(output_name $img)"
	convert "$img" -channel RGB -negate "$output"
}

for img in $@; do
#	crop_centered "$img" 1152x824
#	scale "$img" 512x512\!
	invert_colors "$img"
done
