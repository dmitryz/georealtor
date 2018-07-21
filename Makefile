.PHONY: test
test: test-rspec test-rubocop

.PHONY: test-rspec
test-rspec: deps .env.test.local
	@echo === Running $@…
	RAILS_ENV=test bundle exec rspec
	@echo

.PHONY: test-rubocop
test-rubocop: deps .env.test.local
	@echo === Running $@…
	RAILS_ENV=test bundle exec rubocop
	@echo

.PHONY: deps
deps: Gemfile.lock
	@echo === Installing gems…
	bundle install --quiet
	@echo
