# Testing giantswarm as environment for sos-berlin jobscheduler
# Variable for re-use in the file
GIANTSWARM_USERNAME := $(shell swarm user)


# Building your custom docker image
docker-build:
	docker build -t registry.giantswarm.io/$(GIANTSWARM_USERNAME)/jobscheduler .

# Starting mariadb container to run in the background
docker-run-mysql:
	@docker kill jobscheduler-mysql > /dev/null || true
	@docker rm jobscheduler-mysql > /dev/null || true
	docker run -d -p 3306:3306 \
	  -e "MYSQL_USER=jobscheduler" \
    -e "MYSQL_PASSWORD=jobscheduler" \
    -e "MYSQL_ROOT_PASSWORD=scheduler" \
    -e "MYSQL_DATABASE=jobscheduler" \
	--name jobscheduler-mysql mariadb:latest

# Running your custom-built docker image locally
docker-run:
	docker run --rm -p 4444:4444 -p 40444:40444 -ti \
		--link jobscheduler-mysql:mysql \
		--name jobscheduler \
		registry.giantswarm.io/$(GIANTSWARM_USERNAME)/jobscheduler

# Pushing the freshly built image to the registry
docker-push:
	docker push registry.giantswarm.io/$(GIANTSWARM_USERNAME)/jobscheduler

# Starting your service on Giant Swarm.
# Requires prior pushing to the registry ('make docker-push')
swarm-up:
	swarm up

# Removing your service again from Giant Swarm
# to free resources. Also required before changing
# the swarm.json file and re-issueing 'swarm up'
swarm-delete:
	swarm delete

# To remove the stuff we built locally afterwards
clean:
	docker rmi -f registry.giantswarm.io/$(GIANTSWARM_USERNAME)/jobscheduler
