# gRPC Contracts | gRPC Контракты

[English](#english) | [Русский](#russian)

---

<a name="english"></a>
## English

Centralized Protocol Buffers contracts repository for gRPC services.

### Table of Contents
- [Description](#description)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Available Commands](#available-commands)
- [Usage in Other Projects](#usage-in-other-projects)
- [API Documentation](#api-documentation)
- [Versioning](#versioning)
- [Contributing](#contributing)
- [License](#license)
- [Authors](#authors)
- [Useful Links](#useful-links)

### Description

This repository contains Protocol Buffers definitions for microservices architecture, including:

- **Auth Service** - authentication and authorization service
- **User Service** - user management service
- **Common** - shared types and data structures

### Quick Start

#### Requirements

- Go 1.25.1 or higher
- Protocol Buffers compiler (protoc)
- Make

#### Installing protoc

**macOS:**
```bash
brew install protobuf
```

**Linux:**
```bash
apt-get install -y protobuf-compiler
```

**Verify installation:**
```bash
protoc --version
```

#### Installing Tools

```bash
make install-tools
```

This command will install:
- `protoc-gen-go` - Go code generator for protobuf
- `protoc-gen-go-grpc` - Go code generator for gRPC

#### Code Generation

```bash
make generate
```

Generated code will be placed in the `gen/go/` directory

### Project Structure

```
grpc-contracts/
├── proto/
│   ├── auth/v1/          # Authentication service
│   │   └── auth.proto
│   ├── user/v1/          # User management service
│   │   └── user.proto
│   └── common/v1/        # Common types
│       └── common.proto
├── gen/go/               # Generated Go code
│   ├── auth/v1/
│   ├── user/v1/
│   └── common/v1/
├── Makefile              # Commands for generation
├── go.mod
└── README.md
```

### Available Commands

```bash
make help           # Show all available commands
make install-tools  # Install required tools
make generate       # Generate Go code from proto files
make clean          # Clean generated files
```

### Usage in Other Projects

#### Adding Dependency

```bash
go get github.com/AvdienkoSergey/grpc-contracts@latest
```

#### Import in Go Code

```go
import (
    authv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/auth/v1"
    userv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/user/v1"
    commonv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/common/v1"
)
```

#### Usage Example

```go
package main

import (
    "context"
    "log"
    
    authv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/auth/v1"
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
)

func main() {
    // Connect to gRPC server
    conn, err := grpc.NewClient(
        "localhost:50051",
        grpc.WithTransportCredentials(insecure.NewCredentials()),
    )
    if err != nil {
        log.Fatal(err)
    }
    defer conn.Close()

    // Create client
    client := authv1.NewAuthServiceClient(conn)

    // Call method
    resp, err := client.Login(context.Background(), &authv1.LoginRequest{
        Username: "user@example.com",
        Password: "password",
        Realm:    "master",
        ClientId: "my-client",
    })
    if err != nil {
        log.Fatal(err)
    }

    log.Printf("Access Token: %s", resp.AccessToken)
}
```

### API Documentation

#### Auth Service

Authentication service provides the following methods:

- `Login` - user login
- `RefreshToken` - refresh access token
- `ValidateToken` - token validation
- `Logout` - user logout
- `GetUserInfo` - get user information

#### User Service

User management service:

- `CreateUser` - create user
- `GetUser` - get user by ID
- `UpdateUser` - update user data
- `DeleteUser` - delete user
- `ListUsers` - list users with pagination
- `SearchUsers` - search users
- `GetUserByEmail` - get user by email

#### Common Types

Common data types:

- `Pagination` - pagination for lists
- `Error` - error structure
- `Metadata` - metadata (created_at, updated_at, etc.)

### Versioning

The project uses [Semantic Versioning](https://semver.org/) and [Conventional Commits](https://www.conventionalcommits.org/).

#### Commit Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat` - new feature
- `fix` - bug fix
- `docs` - documentation changes
- `style` - code formatting
- `refactor` - refactoring
- `test` - adding tests
- `chore` - dependency updates, etc.

**Examples:**
```bash
feat(auth): add password reset method
fix(user): correct email validation
docs: update README with examples
```

### Contributing

1. Create a feature branch (`git checkout -b feature/amazing-feature`)
2. Commit your changes (`git commit -m 'feat: add amazing feature'`)
3. Push to the branch (`git push origin feature/amazing-feature`)
4. Open a Pull Request

### License

MIT

### Authors

- Sergey Avdienko - [@AvdienkoSergey](https://github.com/AvdienkoSergey)

### Useful Links

- [Protocol Buffers Documentation](https://protobuf.dev/)
- [gRPC Documentation](https://grpc.io/docs/)
- [gRPC Go Quick Start](https://grpc.io/docs/languages/go/quickstart/)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

<a name="russian"></a>
## Русский

Централизованный репозиторий Protocol Buffers контрактов для gRPC сервисов.

### Содержание
- [Описание](#описание)
- [Быстрый старт](#быстрый-старт)
- [Структура проекта](#структура-проекта)
- [Доступные команды](#доступные-команды)
- [Использование в других проектах](#использование-в-других-проектах)
- [API Документация](#api-документация)
- [Версионирование](#версионирование)
- [Участие в разработке](#участие-в-разработке)
- [Лицензия](#лицензия)
- [Авторы](#авторы)
- [Полезные ссылки](#полезные-ссылки)

### Описание

Этот репозиторий содержит определения Protocol Buffers для микросервисной архитектуры, включающей:

- **Auth Service** - сервис аутентификации и авторизации
- **User Service** - сервис управления пользователями
- **Common** - общие типы и структуры данных

### Быстрый старт

#### Требования

- Go 1.25.1 или выше
- Protocol Buffers compiler (protoc)
- Make

#### Установка protoc

**macOS:**
```bash
brew install protobuf
```

**Linux:**
```bash
apt-get install -y protobuf-compiler
```

**Проверка установки:**
```bash
protoc --version
```

#### Установка инструментов

```bash
make install-tools
```

Эта команда установит:
- `protoc-gen-go` - генератор Go кода для protobuf
- `protoc-gen-go-grpc` - генератор Go кода для gRPC

#### Генерация кода

```bash
make generate
```

Сгенерированный код будет размещен в директории `gen/go/`

### Структура проекта

```
grpc-contracts/
├── proto/
│   ├── auth/v1/          # Сервис аутентификации
│   │   └── auth.proto
│   ├── user/v1/          # Сервис управления пользователями
│   │   └── user.proto
│   └── common/v1/        # Общие типы
│       └── common.proto
├── gen/go/               # Сгенерированный Go код
│   ├── auth/v1/
│   ├── user/v1/
│   └── common/v1/
├── Makefile              # Команды для генерации
├── go.mod
└── README.md
```

### Доступные команды

```bash
make help           # Показать все доступные команды
make install-tools  # Установить необходимые инструменты
make generate       # Сгенерировать Go код из proto файлов
make clean          # Очистить сгенерированные файлы
```

### Использование в других проектах

#### Добавление зависимости

```bash
go get github.com/AvdienkoSergey/grpc-contracts@latest
```

#### Импорт в Go коде

```go
import (
    authv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/auth/v1"
    userv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/user/v1"
    commonv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/common/v1"
)
```

#### Пример использования

```go
package main

import (
    "context"
    "log"
    
    authv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/auth/v1"
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
)

func main() {
    // Подключение к gRPC серверу
    conn, err := grpc.NewClient(
        "localhost:50051",
        grpc.WithTransportCredentials(insecure.NewCredentials()),
    )
    if err != nil {
        log.Fatal(err)
    }
    defer conn.Close()

    // Создание клиента
    client := authv1.NewAuthServiceClient(conn)

    // Вызов метода
    resp, err := client.Login(context.Background(), &authv1.LoginRequest{
        Username: "user@example.com",
        Password: "password",
        Realm:    "master",
        ClientId: "my-client",
    })
    if err != nil {
        log.Fatal(err)
    }

    log.Printf("Access Token: %s", resp.AccessToken)
}
```

### API Документация

#### Auth Service

Сервис аутентификации предоставляет следующие методы:

- `Login` - вход пользователя
- `RefreshToken` - обновление токена доступа
- `ValidateToken` - валидация токена
- `Logout` - выход пользователя
- `GetUserInfo` - получение информации о пользователе

#### User Service

Сервис управления пользователями:

- `CreateUser` - создание пользователя
- `GetUser` - получение пользователя по ID
- `UpdateUser` - обновление данных пользователя
- `DeleteUser` - удаление пользователя
- `ListUsers` - список пользователей с пагинацией
- `SearchUsers` - поиск пользователей
- `GetUserByEmail` - получение пользователя по email

#### Common Types

Общие типы данных:

- `Pagination` - пагинация для списков
- `Error` - структура ошибок
- `Metadata` - метаданные (created_at, updated_at и т.д.)

### Версионирование

Проект использует [Semantic Versioning](https://semver.org/) и [Conventional Commits](https://www.conventionalcommits.org/).

#### Формат коммитов

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Типы:**
- `feat` - новая функциональность
- `fix` - исправление ошибок
- `docs` - изменения в документации
- `style` - форматирование кода
- `refactor` - рефакторинг
- `test` - добавление тестов
- `chore` - обновление зависимостей и прочее

**Примеры:**
```bash
feat(auth): add password reset method
fix(user): correct email validation
docs: update README with examples
```

### Участие в разработке

1. Создайте feature branch (`git checkout -b feature/amazing-feature`)
2. Закоммитьте изменения (`git commit -m 'feat: add amazing feature'`)
3. Запушьте в branch (`git push origin feature/amazing-feature`)
4. Откройте Pull Request

### Лицензия

MIT

### Авторы

- Sergey Avdienko - [@AvdienkoSergey](https://github.com/AvdienkoSergey)

### Полезные ссылки

- [Protocol Buffers Documentation](https://protobuf.dev/)
- [gRPC Documentation](https://grpc.io/docs/)
- [gRPC Go Quick Start](https://grpc.io/docs/languages/go/quickstart/)
- [Conventional Commits](https://www.conventionalcommits.org/)