.PHONY: install build test lint vet fmt clean list

install: vet fmt test
	go install

build: vet fmt test
	go build

test:
	test/end-to-end -v

lint:
	golint

vet:
	go vet

fmt:
	! gofmt -d -e -s *.go 2>&1 | tee /dev/tty | read

clean:
	go clean

CWD=$(shell pwd)
spawn:
	docker run -p 6380:6380 -v $(CWD):/rafka --network kafkacluster_default skroutz/rafka

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs
