#! /bin/bash
# This is bar symbol
bar="\033[7m \033[0m"
pgmajfault=$(grep pgmajfault /proc/vmstat | awk '{print $2}')
while true
do
    active_pages=$(grep nr_active_file /proc/vmstat | awk '{print $2}')
    inactive_pages=$(grep nr_inactive_file /proc/vmstat | awk '{print $2}')
    pgmajfault_new=$(grep pgmajfault /proc/vmstat | awk '{print $2}')
    total=$(echo $(grep ^MemTotal /proc/meminfo | awk '{print $2}')/4 | bc)

    # Percentage we need to display within 1 terminal
    active_percentage=$(echo $active_pages*100/$total | bc)
    inactive_percentage=$(echo $inactive_pages*100/$total | bc)

    echo "ACTIVE: $(echo ${active_percentage} | bc)%"
    for ((i=0; i<=active_percentage; i++))
    do
        echo -ne "\033[7m \033[0m"
    done
    # We need extra space
    echo
    echo "INACTIVE: $(echo ${inactive_percentage} | bc)%"
    for ((i=0; i<=inactive_percentage; i++))
    do
        echo -ne "\033[7m \033[0m"
    done

    if [ "$pgmajfault_new" -gt "$pgmajfault" ]; then
        pgmajfault=$pgmajfault_new
        echo
        echo "PAGEFAULT!"
    fi

    sleep 1
    clear
done
