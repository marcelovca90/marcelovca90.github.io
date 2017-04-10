#!/bin/bash

if [[ "$#" == "0" ]] ; then
	FOLDER=$(pwd)
elif [[ "$#" == "1" ]] ; then
	FOLDER=$1
else
	echo "Usage: ./m-sort-folders.sh [FOLDER]"
fi

for file in "$FOLDER"/*
do

	# should not process '_*' directory(ies)
	if [[ ( $(basename "$file") == "_"* ) ]] ; then
		echo "Skipping '$file'"
		continue;
	fi

	filename=$(basename "$file")
	extension="${filename##*.}"
	extension_lower=$(echo "$extension" | tr '[:upper:]' '[:lower:]')
	filename="${filename%.*}"

	# if it is a directory
	if [[ -d $file ]] ; then

		# if the _dir folder does not exist
		if [[ ! -d "$FOLDER/_dir" ]] ; then
			echo "Creating directory $FOLDER/_dir"
			mkdir "$FOLDER/_dir"
		fi

		# move the directory to ./_dir
		echo "Moving directory [$file] to [$FOLDER/_dir/]"
		mv -f "$file" "$FOLDER/_dir/"

	# if it is a file
	else 

		# if the _$extension folder does not exist
		if [[ ! -d "$FOLDER/_$extension" ]] ; then
			echo "Creating directory $FOLDER/_$extension_lower"
			mkdir "$FOLDER/_$extension_lower"
		fi

		# move the fire to ./_$extension
		echo "Moving file [$file] to [$FOLDER/_$extension_lower/]"
		mv -f "$file" "$FOLDER/_$extension_lower/"
	fi

done

