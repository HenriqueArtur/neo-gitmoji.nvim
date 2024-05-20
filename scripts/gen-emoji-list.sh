#!/bin/sh

destination_folder="./lua/neo-gitmoji/"
file="${destination_folder}emoji-list.lua"
tmp_file="${destination_folder}emoji-list-tmp.lua"

almost_parsed=$(curl https://raw.githubusercontent.com/carloscuesta/gitmoji/master/packages/gitmojis/src/gitmojis.json \
| jq .gitmojis \
| sed 's/\"\(\w*\)\"\:/\1\ \=/' \
| sed 's/null/nil/')

last_line=$(wc -l <$almost_parsed)
echo "$almost_parsed" \
| sed '1s/\[/return\ \{/' \
| sed "${last_line}s/\]/\}/" \
>> $tmp_file

if [ -f $tmp_file ]; then
	if cmp "$file" "$tmp_file"; then
		rm $tmp_file
	else
		rm $file
		mv $tmp_file $file
	fi
fi

