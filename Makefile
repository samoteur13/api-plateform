DOCKER=docker compose
COMPOSER=symfony composer

.DEFAULT_GOAL := docker-install

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?## .*$$)|(^## )' Makefile | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

composer-install:
	$(COMPOSER) install

clean: ## restet your symfony project
	rm -Rf bin config migrations public src tests translations var vendor .env .env.test .gitignore composer.* symfony.lock phpunit* templates

docker-install: Dockerfile docker-compose.yaml clean ## Reset and install your environment
	$(DOCKER) down
	$(DOCKER) up -d --build
	$(DOCKER) ps
	$(DOCKER) logs -f

docker-up: ## Start the docker container
	$(DOCKER) down
	$(DOCKER) up -d

docker-build: ## Start the docker container
	$(DOCKER) build

docker-sh: ## Connect to the docker container
	$(DOCKER) exec -it api zsh
