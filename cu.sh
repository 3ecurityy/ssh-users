if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -p  "Enter expire date ( y-m-d ) example 2023-06-10 : " date
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p "$pass" "$username" --shell=/bin/false
		usermod -e  "$date" "$username"
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system."
	exit 2
fi
