#!/bin/bash
# $ grep -o 'http://link.springer.com/openurl?genre=book&isbn=978-[0-9]*[0-9]*[0-9]*-[0-9]*[0-9]*[0-9]*[0-9]*-[0-9]*[0-9]*[0-9]*[0-9]*[0-9]*-[0-9]*' ../../Downloads/Springer_Ebooks.txt
echo "Starting download of all Springer books"

bookLinksFile="./springer_book_links.txt"
echo "$bookLinksFile"
while read URL 
do
	echo "$URL"

	# Because our initial URL will redirect, I will save the actual URL that contains HTML data
	finalURL="$(curl -Ls -o /dev/null -w %{url_effective} "$URL")"
	# Here I am going through the HTML and obtaining the href of the button that will direct us to the pdf file on the Springer server
	pdfLink="$(curl -s "${finalURL}" | grep -m 1 -o '/content/pdf/[a-zA-Z0-9+-.%]*[.pdf]')"
	echo "$pdfLink"
	# Initiating the download of our pdf book
	wget link.springer.com"$pdfLink"
done < $bookLinksFile
