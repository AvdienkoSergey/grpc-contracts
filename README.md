# gRPC Contracts

Централизованный репозиторий Protocol Buffers контрактов для gRPC сервисов.

## 📋 Описание

Этот репозиторий содержит определения Protocol Buffers для микросервисной архитектуры, включающей:

- **Auth Service** - сервис аутентификации и авторизации
- **User Service** - сервис управления пользователями
- **Common** - общие типы и структуры данных

## 🚀 Быстрый старт

### Требования

- Go 1.25.1 или выше
- Protocol Buffers compiler (protoc)
- Make

### Установка protoc

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

### Установка инструментов

```bash
make install-tools
```

Эта команда установит:
- `protoc-gen-go` - генератор Go кода для protobuf
- `protoc-gen-go-grpc` - генератор Go кода для gRPC

### Генерация кода

```bash
make generate
```

Сгенерированный код будет размещен в директории `gen/go/`

## 📁 Структура проекта

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

## 🔧 Доступные команды

```bash
make help           # Показать все доступные команды
make install-tools  # Установить необходимые инструменты
make generate       # Сгенерировать Go код из proto файлов
make clean          # Очистить сгенерированные файлы
```

## 📦 Использование в других проектах

### Добавление зависимости

```bash
go get github.com/AvdienkoSergey/grpc-contracts@latest
```

### Импорт в Go коде

```go
import (
    authv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/auth/v1"
    userv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/user/v1"
    commonv1 "github.com/AvdienkoSergey/grpc-contracts/gen/go/common/v1"
)
```

### Пример использования

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

## 📚 API Документация

### Auth Service

Сервис аутентификации предоставляет следующие методы:

- `Login` - вход пользователя
- `RefreshToken` - обновление токена доступа
- `ValidateToken` - валидация токена
- `Logout` - выход пользователя
- `GetUserInfo` - получение информации о пользователе

### User Service

Сервис управления пользователями:

- `CreateUser` - создание пользователя
- `GetUser` - получение пользователя по ID
- `UpdateUser` - обновление данных пользователя
- `DeleteUser` - удаление пользователя
- `ListUsers` - список пользователей с пагинацией
- `SearchUsers` - поиск пользователей
- `GetUserByEmail` - получение пользователя по email

### Common Types

Общие типы данных:

- `Pagination` - пагинация для списков
- `Error` - структура ошибок
- `Metadata` - метаданные (created_at, updated_at и т.д.)

## 🔄 Версионирование

Проект использует [Semantic Versioning](https://semver.org/) и [Conventional Commits](https://www.conventionalcommits.org/).

### Формат коммитов

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

## 🤝 Contribution

1. Создайте feature branch (`git checkout -b feature/amazing-feature`)
2. Commit изменения (`git commit -m 'feat: add amazing feature'`)
3. Push в branch (`git push origin feature/amazing-feature`)
4. Откройте Pull Request

## 📝 Лицензия

MIT

## 👥 Авторы

- Sergey Avdienko - [@AvdienkoSergey](https://github.com/AvdienkoSergey)

## 🔗 Полезные ссылки

- [Protocol Buffers Documentation](https://protobuf.dev/)
- [gRPC Documentation](https://grpc.io/docs/)
- [gRPC Go Quick Start](https://grpc.io/docs/languages/go/quickstart/)
- [Conventional Commits](https://www.conventionalcommits.org/)