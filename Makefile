build:
	go build -o ry *.go

run: build
	./ry
