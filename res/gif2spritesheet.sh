file_name=$(echo $1 | sed 's/\(.*\)\..*/\1/')
montage $1 -tile x1 -geometry '1x1+0+0<' -alpha On -background "rgba(0, 0, 0, 0.0)" -quality 100 $file_name.png
