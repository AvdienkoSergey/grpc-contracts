.PHONY: help generate clean install-tools pr-view release-view repo-view check-gh check-protoc check-deps

# Определяем GitHub username и repo из git remote
GITHUB_USER := $(shell git remote get-url origin | sed -n 's/.*github.com[:/]\(.*\)\/.*\.git/\1/p' || echo "")
GITHUB_REPO := $(shell git remote get-url origin | sed -n 's/.*github.com[:/].*\/\(.*\)\.git/\1/p' || echo "")

# Определяем операционную систему
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	OS := linux
endif
ifeq ($(UNAME_S),Darwin)
	OS := macos
endif
ifeq ($(findstring MINGW,$(UNAME_S)),MINGW)
	OS := windows
endif
ifeq ($(findstring MSYS,$(UNAME_S)),MSYS)
	OS := windows
endif

help:
	@echo "Доступные команды:"
	@echo ""
	@echo "Проверка окружения:"
	@echo "  make check-deps     - Проверить все зависимости"
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
	@echo "Система: $(OS)"
	@echo ""
	@echo "Примечание: для GitHub команд желательно установить GitHub CLI:"
	@echo "  brew install gh     (macOS)"
	@echo "  Или используйте: make <команда> без gh"

install-tools:
	@echo "Установка инструментов..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@echo "Готово!"

# Проверка наличия protoc
check-protoc:
	@echo "Проверка protoc..."
	@if which protoc > /dev/null 2>&1; then \
		echo "SUCCESS. protoc установлен: $(protoc --version)"; \
	else \
		echo "FAIL. protoc НЕ установлен!"; \
		echo ""; \
		echo "Установите protoc:"; \
		if [ "$(OS)" = "macos" ]; then \
			echo "  brew install protobuf"; \
		elif [ "$(OS)" = "linux" ]; then \
			echo "  sudo apt-get install -y protobuf-compiler  # Debian/Ubuntu"; \
			echo "  sudo yum install -y protobuf-compiler      # RedHat/CentOS"; \
		elif [ "$(OS)" = "windows" ]; then \
			echo "  choco install protoc                       # Chocolatey"; \
			echo "  или скачайте с https://github.com/protocolbuffers/protobuf/releases"; \
		else \
			echo "  Скачайте с https://github.com/protocolbuffers/protobuf/releases"; \
		fi; \
		echo ""; \
		exit 1; \
	fi

# Проверка всех зависимостей
check-deps: check-protoc
	@echo ""
	@echo "Проверка Go..."
	@if which go > /dev/null 2>&1; then \
		echo "SUCCESS. Go установлен: $(go version)"; \
	else \
		echo "FAIL. Go НЕ установлен!"; \
		echo "Скачайте с https://go.dev/dl/"; \
		exit 1; \
	fi
	@echo ""
	@echo "Проверка protoc-gen-go..."
	@if which protoc-gen-go > /dev/null 2>&1; then \
		echo "SUCCESS. protoc-gen-go установлен: $(protoc-gen-go --version)"; \
	else \
		echo "FAIL. protoc-gen-go НЕ установлен"; \
		echo "Запустите: make install-tools"; \
	fi
	@echo ""
	@echo "Проверка protoc-gen-go-grpc..."
	@if which protoc-gen-go-grpc > /dev/null 2>&1; then \
		echo "SUCCESS. protoc-gen-go-grpc установлен"; \
	else \
		echo "FAIL. protoc-gen-go-grpc НЕ установлен"; \
		echo "Запустите: make install-tools"; \
	fi
	@echo ""
	@echo "Проверка make..."
	@if which make > /dev/null 2>&1; then \
		echo "SUCCESS. make установлен: $(make --version | head -n 1)"; \
	else \
		echo "FAIL. Make НЕ установлен (но вы же его используете...)"; \
	fi
	@echo ""
	@echo "Опционально: GitHub CLI"
	@if which gh > /dev/null 2>&1; then \
		echo "SUCCESS. gh установлен: $(gh --version | head -n 1)"; \
	else \
		echo "FAIL. gh НЕ установлен (опционально)"; \
		if [ "$(OS)" = "macos" ]; then \
			echo "  brew install gh"; \
		elif [ "$(OS)" = "linux" ]; then \
			echo "  https://github.com/cli/cli/blob/trunk/docs/install_linux.md"; \
		elif [ "$(OS)" = "windows" ]; then \
			echo "  choco install gh"; \
			echo "  или scoop install gh"; \
		fi; \
	fi
	@echo ""
	@echo "Проверка завершена!"

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
	@which gh > /dev/null 2>&1 || (echo "FAIL. GitHub CLI не установлен. Открываю через браузер..." && exit 1)

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