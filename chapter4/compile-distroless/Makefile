build:
	docker build . -t memory-test

MEMORY_LIMIT=100M
CONTAINER_NAME=memory-container
run:
	@docker run -m $(MEMORY_LIMIT) --name $(CONTAINER_NAME) memory-test \
	  || docker inspect -f '{{.State}}' $(CONTAINER_NAME)
	@docker rm -v memory-container &> /dev/null
