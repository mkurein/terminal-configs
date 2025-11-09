#!/bin/bash

# 🛠️ Dev Environment Setup - быстрая настройка окружения для проекта
# Автоматически определяет тип проекта и настраивает нужное окружение

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR" || exit

echo "🛠️ Настройка окружения разработки..."
echo "📁 Проект: $(pwd)"
echo ""

# Определение типа проекта
detect_project_type() {
    if [[ -f "package.json" ]]; then
        echo "nodejs"
    elif [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]] || [[ -f "pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "go.mod" ]]; then
        echo "go"
    else
        echo "unknown"
    fi
}

PROJECT_TYPE=$(detect_project_type)

case $PROJECT_TYPE in
    nodejs)
        echo "📦 Node.js проект обнаружен"
        echo ""
        
        if [[ ! -d "node_modules" ]]; then
            read -p "Установить зависимости? (npm install) [y/N]: " install
            if [[ "$install" == "y" ]]; then
                npm install
            fi
        fi
        
        echo ""
        echo "Доступные команды:"
        if [[ -f "package.json" ]]; then
            echo "  npm run dev    - запуск dev сервера"
            echo "  npm test       - тесты"
            echo "  npm run build  - сборка"
        fi
        ;;
        
    python)
        echo "🐍 Python проект обнаружен"
        echo ""
        
        # Проверка виртуального окружения
        if [[ ! -d "venv" ]] && [[ ! -d ".venv" ]]; then
            read -p "Создать виртуальное окружение? [y/N]: " create_venv
            if [[ "$create_venv" == "y" ]]; then
                python3 -m venv venv
                echo "✓ Виртуальное окружение создано"
            fi
        fi
        
        # Активация venv
        if [[ -d "venv" ]]; then
            echo "Для активации: source venv/bin/activate"
        elif [[ -d ".venv" ]]; then
            echo "Для активации: source .venv/bin/activate"
        fi
        
        # Установка зависимостей
        if [[ -f "requirements.txt" ]]; then
            read -p "Установить зависимости? (pip install -r requirements.txt) [y/N]: " install
            if [[ "$install" == "y" ]]; then
                pip install -r requirements.txt
            fi
        fi
        ;;
        
    rust)
        echo "🦀 Rust проект обнаружен"
        echo ""
        echo "Доступные команды:"
        echo "  cargo build    - сборка"
        echo "  cargo run      - запуск"
        echo "  cargo test     - тесты"
        echo "  cargo check    - быстрая проверка"
        ;;
        
    go)
        echo "🐹 Go проект обнаружен"
        echo ""
        
        read -p "Загрузить зависимости? (go mod download) [y/N]: " install
        if [[ "$install" == "y" ]]; then
            go mod download
        fi
        
        echo ""
        echo "Доступные команды:"
        echo "  go run .       - запуск"
        echo "  go test ./...  - тесты"
        echo "  go build       - сборка"
        ;;
        
    *)
        echo "❓ Тип проекта не определен"
        echo ""
        echo "Структура папки:"
        ls -la
        ;;
esac

echo ""
echo "✓ Готово!"

