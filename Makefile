.PHONY: help generate clean install-tools

help:
	@echo "Доступные команды:"
	@echo "  make install-tools  - Установить инструменты"
	@echo "  make generate       - Сгенерировать Go код"
	@echo "  make clean          - Очистить сгенерированные файлы"

install-tools:
	@echo "Установка инструментов..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@echo "Готово!"

generate: clean
	@echo "Генерация Go кода..."
	@mkdir -p gen/go
	protoc \
		--proto_path=. \
		--go_out=gen/go \
		--go_opt=paths=source_relative \
		--go-grpc_out=gen/go \
		--go-grpc_opt=paths=source_relative \
		proto/common/v1/*.proto \
		proto/auth/v1/*.proto
	@echo "Готово!"

clean:
	@echo "Очистка..."
	rm -rf gen/go/*
	@echo "Готово!"

.DEFAULT_GOAL := help
