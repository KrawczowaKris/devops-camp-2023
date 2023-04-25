build:
	docker build . -t memory-test

MEMORY_LIMIT=100M
run:
	docker run -m $(MEMORY_LIMIT) --name memory-container memory-test || docker inspect -f '{{.State}}' memory-container
