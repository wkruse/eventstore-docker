# Event Store in Docker

Produces an image that runs [Event Store](http://geteventstore.com/).

## What is an Event Store?

The [Event Store](http://geteventstore.com/) is a database for supporting the concept of [Event Sourcing](http://martinfowler.com/eaaDev/EventSourcing.html).

## How to use this image?

### Start an Event Store

Start an Event Store node with
- binding to all network interfaces
- http server configured to respond to all prefixes
- user projections enabled

```bash
docker run --name some-eventstore -d -p 2113:2113 -p 1113:1113 wkruse/eventstore --ext-ip=0.0.0.0 --http-prefixes="http://*:2113/" --run-projections=all
```

This image includes `EXPOSE 2113 1113` (the `HTTP` and `TCP` ports), so standard container port mapping will make it available to the host. Go to `http://<docker-host-ip>:2113` for the web ui. 

The `EVENTSTORE_DB` and `EVENTSTORE_LOG` (set to `/data/db` and `/data/logs` respectively) are exposed as volumes.

### Inspect the image

To look around in the image, run:

```bash
docker run --rm --entrypoint="bash" -it -p 2113:2113 -p 1113:1113 wkruse/eventstore
```
