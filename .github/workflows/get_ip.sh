# Args:
# $1 -> kitchen instance name

if [ "$#" -ne 1 ]; then
    echo "Illegal number of arguments"
    echo "Usage: get_ip.sh <KITCHEN_INSTANCE>"
    exit 1
fi

CONTAINER_ID=`docker ps | grep $1 | awk '{print $2}' | awk -F'[:]' '{print $1}'`
CONTAINER_IP=`docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID`
echo $CONTAINER_IP