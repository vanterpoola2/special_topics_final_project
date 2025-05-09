#!/bin/bash

# The output of this code contains text with incorrect spelling (insp), excluding the annotated corrections

# Folder Paths
input_folders=(
"soraUVALAL/BO/written/4"
"soraUVALAL/DK/written/4"
"soraUVALAL/SP/written/4"
)

# Output Directory
output_folder="cleaned_insp_files/"
mkdir -p "${output_folder}/training_data_set/BO" \
	 "${output_folder}/training_data_set/DK" \
	 "${output_folder}/training_data_set/SP" \
	 "${output_folder}/blind_data_set/BO" \
	 "${output_folder}/blind_data_set/DK" \
	 "${output_folder}/blind_data_set/SP" \

# Blind set files
bosnian_blind_files=(
"04.cha"
"08.cha"
"17.cha"
)

danish_blind_files=(
"06.cha"
"13.cha"
"16.cha"
)

spanish_blind_files=(
"02.cha"
"11.cha"
"15.cha"
)

# Loop through all the input directories
for folder in "${input_folders[@]}"; do
    echo "Processing files in $folder..."
    
    # Folder name determines language
    language=$(basename "$(dirname "$(dirname "$folder")")")

    # Set blind list
    if [ "$language" = "BO" ]; then
        blind_files=("${bosnian_blind_files[@]}")
    elif [ "$language" = "DK" ]; then
        blind_files=("${danish_blind_files[@]}")
    else
        blind_files=("${spanish_blind_files[@]}")
    fi

    # Loop through all .cha files in the current folder
    for file in "$folder"/*.cha; do
	base_name=$(basename "$file")

        # Determine output path
	target_folder="${output_folder}/training_data_set/${language}"
	
	for blind_file in "${blind_files[@]}"; do
	    if [ "$base_name" = "$blind_file" ]; then
                target_folder="${output_folder}/blind_data_set/${language}"
                break
            fi
        done
        
	echo "Cleaning $base_name --> $target_folder"

        # Process only lines starting with "*CHI:"
        cleaned_insp_text=$(grep -A1 '^\*CHI:' "$file" | \
            # Convert all text to lowercase
            tr 'A-Z' 'a-z' | \
            # Remove square brackets and their contents
	    sed -E 's/\[[^][]*\]//g' | \
            # Remove parentheses but keep the words inside
            sed 's/[()]//g' | \
            # Remove special characters
            sed 's/[=*()/\?+,<>:]//g' | \
	    # Remove "chi:" at the beginning of lines
	    sed -E 's/^chi//g' | \
	    # Remove three consecutive x's
            sed -E 's/\x{2,}/ /g' | \
            # Remove ellipses
            sed -E 's/\.{2,}/ /g' | \
	    # Convert all L1 words (signified by @) to the string L1
	    perl -pE 's/\b\S*@\S*\b/L1/g' | \
            # Collapse all tabs and multiple spaces into a single space
            tr -s '[:space:]' ' ' | \
            # Remove leading and trailing spaces
            sed 's/^ *//;s/ *$//g' | \
	    # Remove space at the beginning of line
            sed -E 's/^ ([a-z0-9]+)/\1/g' | \
	    # Remove the word @end at the end of the line
            sed 's/ @end$//g' | \
	    # Remove words with ~&
	    sed -E 's/\s*\S*&~\S*\s*//g' | \
            # Remove spaces before periods
            sed -E 's/([a-z0-9]) \. ([a-z0-9])/\1. \2/g' | \
            # Remove spaces before exclamation marks
            sed -E 's/([a-z0-9]) \! ([a-z0-9])/\1. \2/g' | \
            # Remove space before period at the end of line (with space after period)
            sed -E 's/ (.) $/\1/g' | \
	    # Remove space before period at the end of line
	    sed -E 's/ (.)$/\1/g' | \
            # Remove space before exclamation mark at the end of line
            sed -E 's/ (!) $/\1/g'
)

        # Check if cleaned insp text is non-empty
        if [[ -n "$cleaned_insp_text" ]]; then
            # Save cleaned insp text where each *CHI line is preserved
            echo "$cleaned_insp_text" > "${target_folder}/${base_name}"
            echo "Saved cleaned *CHI lines to ${target_folder}/${base_name}"
        else
            echo "No *CHI content found in $file"
        fi
    done
done
