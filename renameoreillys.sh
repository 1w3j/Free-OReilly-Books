#!/usr/bin/env sh

downloaded_dir_path="<edit this path>"
oreilly_list=$(curl -fsSL https://raw.githubusercontent.com/1w3j/Free-OReilly-Books/master/README.md)

echo '[*] Input the folder path where you downloaded the files: ' && read -r downloaded_dir_path && if [[ ! -d "${downloaded_dir_path}" ]]; then echo "${downloaded_dir_path}: Such directory does not exist"; exit 3; fi # If you don't want to ask for input just comment this line, and change the downloaded_dir_path variable
downloaded_dir_path=$(realpath "${downloaded_dir_path}")

listnames(){
    >&1 ls "$1" -lam1N | tail -n+3
}

list_filenames_in_list() {
    grep -e '\.pdf' -e '\.epub' -e '\.mobi' ${oreilly_list} | sed -e 's/<\/br>//g' -e 's/^http.*\///gm' 
}

list_titles_and_trimmed_extension_filenames() {
    grep -e '\.pdf' -e '\.epub' -e '\.mobi' -e '###' ${oreilly_list} | sed -e 's/<\/br>//g' -e 's/^http.*\///gm' -e 's/\.pdf$//g' -e 's/\.epub$//g' -e 's/\.mobi$//g' | sort -u -m
}

get_book_title(){
    echo $(list_titles_and_trimmed_extension_filenames | tr -d '#:?' | sed -e 's/[ \t]*$//' -e 's/^[ \t]*//' | grep "${1}" -B1 | head -n+1)
}

rename_them(){
    for book in $(listnames "${downloaded_dir_path}"); do
        from="${downloaded_dir_path}/${book}"
        to_extension="${book##*.}"
        to="${downloaded_dir_path}/$(get_book_title ${book%%.*}).${to_extension}"
        mv -v "${from}" "${to}"
    done
}

renameoreillys() {
    if [[ ! ${1} = '-N' ]]; then
        if [[ $(listnames "${downloaded_dir_path}" | sort) = $(list_filenames_in_list | sort) ]]; then
            rename_them
        else
            echo -e "[*] CAUTION: Downloaded files do not match files on the O'Reilly list, carefully check if you downloaded the complete set of books and BE SURE is the actual folder all books were downloaded at, if you don't want to check for this, use the -N flag"
        fi
    else
        echo '[*] CAUTION: Using -N flag, showing 10 random files in selected folder:'
        listnames "${downloaded_dir_path}" | sort -R | head
        echo '[*] Continue?' && read
        rename_them
    fi
}

renameoreillys "${@}"
