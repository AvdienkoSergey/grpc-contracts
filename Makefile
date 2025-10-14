.PHONY: help generate clean install-tools pr-view release-view repo-view check-gh

# Определяем GitHub username и repo из git remote
GITHUB_USER := $(shell git remote get-url origin | sed -n 's/.*github.com[:/]\(.*\)\/.*\.git/\1/p' || echo "")
GITHUB_REPO := $(shell git remote get-url origin | sed -n 's/.*github.com[:/].*\/\(.*\)\.git/\1/p' || echo "")

help:
	@echo "Доступные команды:"
	@echo ""
	@echo "Proto генерация:"
	@echo "  make install-tools  - Установить инструменты для proto"
	@echo "  make generate       - Сгенерировать Go код из proto файлов"
	@echo "  make clean          - Очистить сгенерированные файлы"
	@echo ""
	@echo "GitHub команды:"
	@echo "  make pr-view        - Открыть Pull Requests в браузере"
	@echo "  make release-view   - Открыть Releases в браузере"
	@echo "  make repo-view      - Открыть репозиторий в браузере"
	@echo "  make actions-view   - Открыть GitHub Actions в браузере"
	@echo ""
	@echo "Примечание: для GitHub команд желательно установить GitHub CLI:"
	@echo "  brew install gh     (macOS)"
	@echo "  Или используйте: make <команда> без gh"

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
		proto/auth/v1/*.proto \
		proto/user/v1/*.proto
	@echo "Готово!"

clean:
	@echo "Очистка..."
	rm -rf gen/go/*
	@echo "Готово!"

# Проверка наличия gh CLI
check-gh:
	@which gh > /dev/null 2>&1 || (echo "⚠️  GitHub CLI не установлен. Открываю через браузер..." && exit 1)

# GitHub команды с fallback на браузер
pr-view:
	@if which gh > /dev/null 2>&1; then \
		gh pr view --web 2>/dev/null || gh pr list --web; \
	else \
		echo "Открываю Pull Requests в браузере..."; \
		open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/pulls" 2>/dev/null || \
		xdg-open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/pulls" 2>/dev/null || \
		echo "Перейдите по ссылке: https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/pulls"; \
	fi

release-view:
	@if which gh > /dev/null 2>&1; then \
		gh release view --web 2>/dev/null || gh release list --web; \
	else \
		echo "Открываю Releases в браузере..."; \
		open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/releases" 2>/dev/null || \
		xdg-open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/releases" 2>/dev/null || \
		echo "Перейдите по ссылке: https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/releases"; \
	fi

repo-view:
	@if which gh > /dev/null 2>&1; then \
		gh repo view --web; \
	else \
		echo "Открываю репозиторий в браузере..."; \
		open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)" 2>/dev/null || \
		xdg-open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)" 2>/dev/null || \
		echo "Перейдите по ссылке: https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)"; \
	fi

actions-view:
	@if which gh > /dev/null 2>&1; then \
		gh workflow view release-please.yml --web 2>/dev/null || \
		echo "Открываю Actions в браузере через URL..."; \
		open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/actions" 2>/dev/null || \
		xdg-open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/actions" 2>/dev/null || \
		echo "Перейдите по ссылке: https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/actions"; \
	else \
		echo "Открываю Actions в браузере..."; \
		open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/actions" 2>/dev/null || \
		xdg-open "https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/actions" 2>/dev/null || \
		echo "Перейдите по ссылке: https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/actions"; \
	fi

.DEFAULT_GOAL := help