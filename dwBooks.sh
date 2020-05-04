#!/bin/bash
# $ grep -o 'http://link.springer.com/openurl?genre=book&isbn=978-[0-9]*[0-9]*[0-9]*-[0-9]*[0-9]*[0-9]*[0-9]*-[0-9]*[0-9]*[0-9]*[0-9]*[0-9]*-[0-9]*' ../../Downloads/Springer_Ebooks.txt
echo "Starting download of all Springer books"
mkdir Springer_Books
bookLinksFile="./springer_book_links.txt"
echo "$bookLinksFile"
while read URL 
do
#	echo "$URL"

	# Because our initial URL will redirect, I will save the actual URL that contains HTML data
	finalURL="$(curl -Ls -o /dev/null -w %{url_effective} "$URL")"
	# Here I scrape the HTML to find the respective EBook name, I first remove the opening header tag and later I remove the closing tag from the String
	bookName="$(curl -s "${finalURL}" | grep -o '<h1>[a-zA-Z ]*</h1>' | cut -c 5-)"
	bookName=${bookName::-5}
	# Here I am going through the HTML and obtaining the href of the button that will direct us to the pdf file on the Springer server
	pdfLink="$(curl -s "${finalURL}" | grep -m 1 -o '/content/pdf/[a-zA-Z0-9+-.%]*[.pdf]')"
#	echo "$pdfLink"
	# Initiating the download of our pdf book
	wget -O ./Springer_Books/"$bookName".pdf -q --show-progress --progress=bar:force 2>&1 link.springer.com"$pdfLink"
done < $bookLinksFile
