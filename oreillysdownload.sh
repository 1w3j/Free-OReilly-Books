#!/usr/bin/env zsh
echo Checking number of files to be downloaded...
readmemd=$(curl -fsSL https://github.com/1992s/Free-OReilly-Books/raw/master/README.md)
books_list=$( echo ${readmemd} | grep -e '\.pdf' -e '\.epub' -e '\.mobi'  | sed -e 's/<\/br>//')
qty=$(echo ${books_list} | wc -l)
titles=$(echo ${readmemd} | grep '###' -c)
echo Detected ${qty} books and ${titles} titles
echo 'Continue with the bulk download?' && read
echo ${books_list} | while IFS="\n" read book; do 
    wget -c ${book}
done
