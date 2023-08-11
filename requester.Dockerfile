FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y apache2-utils
COPY ./src ./
RUN chmod +x /request.sh
ENTRYPOINT ["/request.sh"]
