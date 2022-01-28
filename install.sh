generated="asd"
function create_from_template {
    generated="[Unit]
Type=simple
Description=Periodic Service Restarter For $1 Daemon

[Install]
WantedBy=multi-user.target

[Service]
ExecStart=/usr/bin/service-restarter.sh $1 $2";
}

read -p "Install new instance of service-restarter daemon? (Y/n) " choice
case "$choice" in 
  n|N )
    echo "Canceled";;
  * )
    read -p "What is the service name you want to restart periodically? > " service_name
    sleep --help
    read -p "Enter sleep duration before restart (5s) > " duration

    if [[ -z "$duration" ]] ; then
        duration=5s
    fi

    echo "Be careful!"
    read -p "This will restart $service_name each $duration. Are you sure? (Y/n) " choice
    case "$choice" in
        n|N )
            echo "Canceled";;
        * )
            echo "Copying restarter script to /usr/bin"
            cp ./service-restarter.sh /usr/bin
            echo "Generating systemd unit"
            create_from_template "$service_name" "$duration"
            service_filename="$service_name-restarter.service";
            echo "Writing systemd file"
            echo "$generated" > "/etc/systemd/system/$service_filename"
            echo "Starting $service_filename"
            systemctl start $service_filename;;
    esac
esac
