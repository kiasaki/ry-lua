GO_FILES=main.go keys.go rt_key.go rt_screen.go rt_style.go rt_util.go

build: $(GO_FILES)
	go build -o ry *.go

run: build
	./ry
