# Ionos-Dyndns for Docker

Keeps your domains at **IONOS** pointing to your current home IP address (Dynamic DNS).

Home internet connections usually get a new public IP address from time to time. This container checks your IP on a schedule you define and updates the DNS records of your domains whenever it changed. That way, `myhome.example.com` always reaches your home network.

It is a small Docker wrapper around the Python tool [Domain Connect Dyndns](https://github.com/Domain-Connect/DomainConnectDDNS-Python).

- **Source code, issues and releases:** https://github.com/philipp-luettecke/ionos-dyndns-docker
- **Supported architectures:** `linux/amd64`, `linux/arm64` (e.g. Raspberry Pi 4/5)

## Image tags

| Tag | Description |
| --- | --- |
| `latest` | Newest stable release |
| `1` | Newest release of major version 1 (no breaking changes) |
| `1.2` | Newest patch release of version 1.2 |
| `1.2.3` | Exact release, never changes |
| `dev` | Latest development build from the `main` branch, may be unstable |

For automatic updates without surprises use `1`. For fully reproducible setups pin an exact version like `1.2.3`.

## What you need

- A computer or server that is always on (e.g. a Raspberry Pi, NAS or home server)
- [Docker](https://docs.docker.com/get-docker/) with Docker Compose installed
- A domain hosted at IONOS

## Quick start

1. **Create a folder** for the container and go into it:
   ```console
   mkdir ionos-dyndns && cd ionos-dyndns
   ```
2. **Create a file named `docker-compose.yml`** with this content:
   ```yaml
   services:
     ionos-dyndns:
       image: philippluettecke/ionos-dyndns:latest
       container_name: ionos-dyndns
       restart: unless-stopped
       environment:
         - CRON_SCHEDULE=*/15 * * * *
         - TZ=Europe/Berlin
       volumes:
         - ./config:/config
       network_mode: host
       user: 1000:1000
   ```
3. **Create the config folder** (it stores your domain settings and login tokens):
   ```console
   mkdir config
   ```
   > The container runs as user `1000:1000` (the first normal user on most Linux systems). If you use a different user, adjust `user:` and make sure that user may write to `./config`.
4. **Start the container:**
   ```console
   docker compose up -d
   ```
5. **Add your domain** (see the section "Adding a domain" below).

That's it. From now on the container updates your domains automatically and restarts itself after a reboot.

## Adding a domain

Run this once per domain, and replace `<DOMAIN>` with your domain, e.g. `home.example.com`:

```console
docker exec -it ionos-dyndns domain-connect-dyndns setup --domain <DOMAIN>
```

The tool prints a link. Open it in your browser, log in to IONOS and confirm the access. Afterwards paste the requested code back into the terminal if asked. The result is saved in `./config/domains.txt`.

> Already have a settings file from the Domain Connect Dyndns tool? Rename it to `domains.txt` and put it into the `config` folder before starting the container, then no setup is needed.

## Settings

All settings are environment variables in the `environment:` section of `docker-compose.yml`.

| Variable | Default | Description |
| --- | --- | --- |
| `CRON_SCHEDULE` | `*/15 * * * *` | When to update your domains, in cron format (see below) |
| `TZ` | `UTC` | Your time zone, e.g. `Europe/Berlin`. Cron times are interpreted in this zone |

After changing a setting, apply it with `docker compose up -d`.

### The update schedule (cron format)

`CRON_SCHEDULE` consists of five fields separated by spaces:

```
┌───────── minute (0-59)
│ ┌─────── hour (0-23)
│ │ ┌───── day of month (1-31)
│ │ │ ┌─── month (1-12)
│ │ │ │ ┌─ day of week (0-7, Sunday = 0 or 7)
│ │ │ │ │
* * * * *
```

`*` means "every", `*/15` means "every 15th".

| Example | Meaning |
| --- | --- |
| `*/15 * * * *` | every 15 minutes |
| `0 * * * *` | every full hour |
| `30 3 * * *` | every day at 03:30 |
| `0 6 * * 1-5` | Monday to Friday at 06:00 |

If the expression is invalid, the container stops and prints an error in the log. All domains are additionally updated once every time the container starts.

## Everyday commands

Check what the container is doing (shows the update log):
```console
docker logs ionos-dyndns
docker logs -f ionos-dyndns    # follow live, quit with Ctrl+C
```

Update a domain right now:
```console
docker exec -it ionos-dyndns domain-connect-dyndns update --domain <DOMAIN>
```

Remove a domain:
```console
docker exec -it ionos-dyndns domain-connect-dyndns remove --domain <DOMAIN>
```

Stop / start the container:
```console
docker compose stop
docker compose start
```

Install a new version of the image:
```console
docker compose pull
docker compose up -d
```

## Troubleshooting

- **Container keeps restarting:** run `docker logs ionos-dyndns`. Most often `CRON_SCHEDULE` is invalid or `./config` is not writable for the configured `user`.
- **"Permission denied" on `domains.txt`:** the folder `./config` must be writable by the user in `user:`. Fix with `sudo chown -R 1000:1000 config`.
- **Wrong update times:** check that `TZ` is set to your time zone.
- **IONOS login expired:** repeat the setup step (see "Adding a domain") for the domain.

## Security note

`config/domains.txt` contains access tokens for your IONOS account. Keep it private and never commit or share it. This repository ignores the `config/` folder by default.

## Building the image yourself

```console
git clone https://github.com/philipp-luettecke/ionos-dyndns-docker.git
cd ionos-dyndns-docker
docker compose up -d --build
```
