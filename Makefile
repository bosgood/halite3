TYPE ?= debug

.PHONY: run
run: needs_name build
	mkdir -p replays
	./halite --replay-directory replays/ -vvv \
		--width 30 --height 30 \
		"RUST_BACKTRACE=1 target/$(TYPE)/$(BOT)" \
		"RUST_BACKTRACE=1 target/$(TYPE)/$(BOT)" \
		"RUST_BACKTRACE=1 target/$(TYPE)/$(BOT)" \
		"RUST_BACKTRACE=1 target/$(TYPE)/$(BOT)"

.PHONY: build
build:
	@./build_all.sh

.PHONY: release
release:
	@./release_all.sh

.PHONY: clean
clean:
	rm replays/* || true
	ls | grep "bot-\d.log" | xargs rm || true

.PHONY: deepclean
deepclean:
	@./deep_clean.sh

.PHONY: needs_name
needs_name:
ifndef BOT
	$(error BOT must be defined, example: "BOT=sample_bot make zip")
endif

.PHONY: zip
zip: needs_name clean deepclean
	@./make_upload.sh $(BOT)

# broken don't use
.PHONY: upload
upload: needs_name zip
	pipenv run python -m hlt_client bot -b packaged_$(BOT).zip upload

.PHONY: bootstrap
bootstrap:
	pipenv --three
	pipenv install appdirs
	pipenv install trueskill

.PHONY: view
view:
	# drag and drop your local replay file into the viewer
	@open -a "Firefox" https://halite.io/watch-games
	@open replays/

.PHONY: register
register: needs_name
	# for example
	# pipenv run python -m hlt_client gym register DistanceBasedGoalSetter(9.98) "RUST_BACKTRACE=1 target/debug/DistanceBasedGoalSetter 9 98"
	pipenv run python -m hlt_client gym register $(BOT) "RUST_BACKTRACE=1 target/release/$(BOT)"

.PHONY: deregister
deregister: needs_name
	yes | pipenv run python -m hlt_client gym deregister "$(BOT)"

.PHONY: gym
gym: release
	# time pipenv run python -m hlt_client gym --db-path ./pathfinding.db evaluate -b ./halite --output-dir gymming -i 20
	mkdir -p gymming
	time pipenv run python -m hlt_client gym evaluate -b ./halite --output-dir gymming -i 50

.PHONY: bots
bots:
	# pipenv run python -m hlt_client gym --db-path ./pathfinding.db bots
	pipenv run python -m hlt_client gym bots
