#!/bin/bash
#author: @disnhau

function help() {
	echo "-o/--output out put file | default ./output.txt"
    echo "-u/--url url"
    echo "-h/--help help"
    echo "-t/--timeout request timeout in seconds | default 3 seconds"
    echo "example"
    echo "- ./script.sh -o output.txt -u https://aaaa.com"
    echo "- cat urls.txt | ./script.sh -o output.txt"
	exit 0
}

function getRobots() {
	url="$1"
	[ -z "$(echo "$url" | grep '^http')" ] && url="https://$url"
	[ -z "$(echo "$url" | grep '/$')" ] && url="$url"
    url=$(echo "$url" | sed 's@/$@@')
	orgUrl="$url"
	url="${url}/robots.txt"

	curl 2>/dev/null -k --max-time $TIMEOUT -L $url | grep -E "^(Disallow|Allow):" | cut -d" " -f2 | grep -vE "^(Disallow|Allow)" | sed "s@^@$orgUrl@" | tee -a $OUTPUT
}

OUTPUT="output.txt"
TIMEOUT=3

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -o|--output)
    OUTPUT="$2"
    shift
    shift
    ;;

    -u|--url)
    url="$2"
    shift
    shift
    ;;

    -t|--timeout)
	TIMEOUT=$2
    shift
    shift
    ;;

    -h|--help)
	help
    shift
    shift
    ;;

    *) 
	help
esac
done

set -- "${POSITIONAL[@]}"

[ -t 0 -a -z "$url" ] && echo "please input url" && exit 0

[ -z "$url" ] && url=$(cat)

urls=($(echo "$url" | tr ' ' '\n'))

for j in ${urls[@]}; do
	getRobots $j & # uncomment # before & to run in background
    sleep 1
done;

exit 0
