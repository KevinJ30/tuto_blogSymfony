build:
	$(MAKE) env-test
	$(MAKE) analyse
	$(MAKE) tests

analyse:
	composer valid
	npm audit
	php bin/console doctrine:schema:valid --skip-sync --env=test
	php vendor/bin/phpcs

.PHONY: tests
tests:
	php bin/phpunit

env-dev:
	npm install
	npm run dev
	composer install --prefer-dist
	php bin/console doctrine:database:drop --if-exists -f --env=dev
	php bin/console doctrine:database:create --env=dev
	php bin/console doctrine:schema:update -f --env=dev
	php bin/console doctrine:fixtures:load -n --env=dev

env-test:
	npm install
	npm run dev
	composer install --prefer-dist
	php bin/console cache:clear --env=test
	php bin/console doctrine:database:drop --if-exists -f --env=test
	php bin/console doctrine:database:create --env=test
	php bin/console doctrine:schema:update -f --env=test
	php bin/console doctrine:fixtures:load -n --env=test

