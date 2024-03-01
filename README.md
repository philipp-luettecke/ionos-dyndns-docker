# Ionos-Dyndns for Docker

This docker container is based on the Domain Connect Dyndns tool developed in python.

https://github.com/Domain-Connect/DomainConnectDDNS-Python

## Setup the container

To use the docker container, you have two options.

1. You can use your existing `settings.txt` file by putting it into the `./config` folder and then starting up your container.
1. You can just start the container and add you new domains manually by following the instructions below.


## Working with domains

To setup, remove or update domains, you can simply use the existing commands provided by the domain-connect-dyndns tool.

### Setup
```console
docker exec -it ionos-dyndns bash -c 'domain-connect-dyndns setup --domain <<DOMAIN>>'
```

### Remove
```console
docker exec -it ionos-dyndns bash -c 'domain-connect-dyndns remove --domain <<DOMAIN>>'
```

### Manually Update
```console
docker exec -it ionos-dyndns bash -c 'domain-connect-dyndns update --domain <<DOMAIN>>'
```