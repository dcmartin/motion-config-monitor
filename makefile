run: all configuration.yaml
	docker start homeassistant

stop:
	-docker stop homeassistant

restart: stop tidy logclean run

logs:
	docker logs -f homeassistant

## clean and clean and clean ..

tidy: 
	@echo "making $@"

clean: stop logclean tidy
	@echo "making $@"
	rm -f .storage/lovelace 
	rm -f .storage/core.restore_state

realclean: clean
	rm -f known_devices.yaml
	rm -fr home-assistant.log
	rm -fr home-assistant_v2.*

logclean:
	@for i in $$(sudo find "/var/lib/docker/containers" -name "*.log" -print); do echo "Cleaning $${i}" && sudo cp /dev/null $${i}; done

distclean: realclean
	rm -fr .uuid .HA_VERSION .cloud deps tts .storage
	rm -f secrets.yaml

.PHONY: all default build run stop logs restart clean realclean distclean $(PACKAGES)
