if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	 egrep "^$username" /etc/passwd >/dev/null
	  if [ $? -eq 0 ]; then
		echo -e "user $username exists!"
		exit 1
	  fi
	read -p "Enter expire date ( y-m-d ) example 2023-06-10 : " date
	read -p "Enter traffic (GB) : " traffic  
	read -p "Enter password : " password
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p "$pass" "$username" --shell=/bin/false
		usermod -e  "$date" "$username"
	
		prefix=1000000000
	        gb=$((traffic * prefix))
		iptables -A OUTPUT -p tcp -m owner --uid-owner $username -m quota --quota $gb -j ACCEPT
		[ $? -eq 0 ] &&  echo -e "user added :) "
    echo -e "----------------------------------------------"
    echo -e "username : "$username
    echo -e "expiry date : "$date
    echo -e "traffic (GB) : "$traffic
    echo -e "password : "$password
    echo -e "----------------------------------------------" || echo "Failed to add a user!"
    
else
	echo "Only root may add a user to the system."
	exit 2
fi
