#!/bin/sh

destination_folder="./lua/neo-gitmoji/"
file="${destination_folder}emoji-list.lua"
tmp_file="${destination_folder}emoji-list-tmp.lua"

curl -s https://raw.githubusercontent.com/carloscuesta/gitmoji/master/packages/gitmojis/src/gitmojis.json \
| jq .gitmojis \
| sed 's/"\([a-zA-Z_][a-zA-Z0-9_]*\)":/\1 =/' \
| sed 's/null/nil/' \
| sed '1s/\[/return {/' \
| sed '$s/\]/}/' \
> $tmp_file

if [ -f $tmp_file ]; then
	if cmp -s "$file" "$tmp_file"; then
		rm $tmp_file
	else
		rm $file
		mv $tmp_file $file
	fi
fi
