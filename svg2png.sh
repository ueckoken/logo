for x in *.svg; do
	magick $x $x.png
done
