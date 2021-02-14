#!/bin/bash
limit=$(cat /proc/sys/fs/inotify/max_user_watches)
paths=$(dirname $0)'/paths'
priv_key=$1
echo "$priv_key"
username=$2
remote_host=$3
backup_path=$4
if [ -f "$paths" ]
then 
	paths=$(echo $(sed 's| |\\ |g' "$paths" | sed 's|;| |g'))

	number_of_paths=$(echo "$paths" | awk -F";" '{print NF}')
	if [ $number_of_paths -gt $limit ]
	then
		echo "Paths limit reached, edit your /proc/sys/fs/inotify/max_user_watches file or remove some paths!"
		exit 0
	fi

	inotifywait $paths -m -r -e close_write,moved_to,delete |
		while read -r directory event filename
		do
			echo $directory
			back_path=$(echo "$directory" | sed "s|$HOME/||g")
			echo "$back_path"	
			rsync -av --bwlimit=2000 "$directory" -e "ssh -i \"$priv_key\"" "$username"@"$remote_host":"$backup_path"/"$back_path" --delete
		done
else
	echo "File $paths not found!"
fi
