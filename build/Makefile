clean:
	@rm -rf Dockerfile.deb Dockerfile.rpm

build-deb:
	@cp -a Dockerfile Dockerfile.deb
	@docker build -t projectdc/build:deb -f Dockerfile.deb .

push:
	@docker push projectdc/build:deb
