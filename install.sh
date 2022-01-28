if [ "$EUID" -ne 0 ]; then
    echo "Attempting to run the script with user"
    sudo su -c "./install.sh"
    exit
fi

generated=""
function create_from_template {
    generated="[Unit]
Type=simple
Description=Periodic Service Keepalive For $1 Daemon

[Install]
WantedBy=multi-user.target

[Service]
ExecStart=/usr/bin/service-keepalive.sh $1 $2"
}

read -p "Install new instance of service-keepalive daemon? (Y/n) " choice
case "$choice" in 
  n|N )
    echo "Canceled";;
  * )
    read -p "What is the service name you want to check periodically? > " service_name
    sleep --help
    read -p "Enter sleep duration before recheck (5s) > " duration

    if [[ -z "$duration" ]] ; then
        duration=5s
    fi

    echo "Be careful!"
    read -p "This will check and start $service_name each $duration. Are you sure? (Y/n) " choice
    case "$choice" in
        n|N )
            echo "Canceled";;
        * )
            echo "Copying keepalive script to /usr/bin"
            cp ./service-keepalive.sh /usr/bin
            echo "Generating systemd unit"
            create_from_template "$service_name" "$duration"
            service_filename="$service_name-keepalive.service";
            echo "Writing systemd file"
            echo "$generated" > "/etc/systemd/system/$service_filename"
            echo "Enable $service_filename"
            systemctl enable --now $service_filename;;
    esac
esac
