PC=0				# PC0 or PC1
N=2					# Responders 12
M=2					# Requesters 12
INT="eth0"			# interface
PREFIX="192.168.1"	# network prefix
# REQUEST SETTINGS IN ./src/request.sh

# Destroy residuals
docker kill $(docker ps -q --filter "name=requester")
docker kill $(docker ps -q --filter "name=responder") 
docker container rm $(sudo docker container ls -a --filter "name=requester" --format '{{.ID}}')
docker container rm $(sudo docker container ls -a --filter "name=responder" --format '{{.ID}}')

# Build new
docker network create -d macvlan --subnet=$PREFIX.0/24 --gateway=$PREFIX.1 -o parent=$INT mymacvlan
docker build -t requester -f requester.Dockerfile . --network=host
docker build -t responder -f responder.Dockerfile . --network=host

# Space start
START=30

# Deploy responders
LIMIT=$((START+N))
for ((i=$START;i<=$LIMIT;i++)); do
	if [ $PC -eq 1 ]; then
		IP="${PREFIX}.${PC}${i}"
		TARGET_URL="${PREFIX}.${i}:90${i}"
		PORT="91${i}"
	else
		IP="${PREFIX}.${i}"
		TARGET_URL="${PREFIX}.1${i}:91${i}"
		PORT="90${i}"
	fi
	CONTAINER_NAME="-${i}"
	docker run -d --network mymacvlan --name responder$CONTAINER_NAME --ip $IP -e PORT=$PORT responder
done

# Deploy requesters
LIMIT=$((START+M))
for ((i=$START;i<=$LIMIT;i++)); do
	j=$((43+i-30))
	if [ $PC -eq 1 ]; then
		IP="${PREFIX}.${PC}${j}"
		TARGET_URL="192.168.1.${i}:90${i}"
		PORT="91${i}"
	else
		IP="${PREFIX}.${j}"
		TARGET_URL="${PREFIX}.1${i}:91${i}"
		PORT="90${i}"
	fi
	CONTAINER_NAME="-${i}"
	docker run -d --network mymacvlan --name requester$CONTAINER_NAME --ip $IP -e TARGET_URL=$TARGET_URL/echo requester
done

