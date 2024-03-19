docker volume ls -q | while read -r volume; do
    containers=$(docker ps -q --filter volume="$volume")
    if [ -n "$containers" ]; then
        echo "Volume $volume is used by container(s): $containers"
    else
        echo "Volume $volume is not used by any container."
    fi
done
