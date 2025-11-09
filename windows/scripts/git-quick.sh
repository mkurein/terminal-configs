#!/bin/bash

# ⚡ Git Quick - быстрые Git команды
# Использование: gq [команда]

COMMAND="${1:-menu}"

case $COMMAND in
    s|status)
        git status
        ;;
        
    a|add)
        git add .
        echo "✓ Все файлы добавлены в staging"
        ;;
        
    c|commit)
        shift
        if [[ -z "$1" ]]; then
            read -p "📝 Сообщение коммита: " msg
        else
            msg="$*"
        fi
        git commit -m "$msg"
        ;;
        
    p|push)
        branch=$(git branch --show-current)
        echo "📤 Push в $branch..."
        git push origin "$branch"
        ;;
        
    l|log)
        git log --oneline --graph --decorate --all -20
        ;;
        
    ac|quick)
        shift
        git add .
        if [[ -z "$1" ]]; then
            read -p "📝 Сообщение коммита: " msg
        else
            msg="$*"
        fi
        git commit -m "$msg"
        echo "✓ Коммит создан: $msg"
        ;;
        
    acp|full)
        shift
        git add .
        if [[ -z "$1" ]]; then
            read -p "📝 Сообщение коммита: " msg
        else
            msg="$*"
        fi
        git commit -m "$msg"
        branch=$(git branch --show-current)
        git push origin "$branch"
        echo "✓ Изменения запушены!"
        ;;
        
    sync)
        branch=$(git branch --show-current)
        echo "🔄 Синхронизация с main/master..."
        git fetch origin
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null
        echo "✓ Синхронизация завершена"
        ;;
        
    undo)
        echo "⚠️  Отменить последний коммит (сохранив изменения)"
        read -p "Продолжить? [y/N]: " confirm
        if [[ "$confirm" == "y" ]]; then
            git reset --soft HEAD~1
            echo "✓ Коммит отменен"
        fi
        ;;
        
    menu|*)
        echo "⚡ Git Quick Commands"
        echo ""
        echo "Использование: gq [команда]"
        echo ""
        echo "Команды:"
        echo "  s, status     - git status"
        echo "  a, add        - git add ."
        echo "  c, commit     - git commit с сообщением"
        echo "  p, push       - git push"
        echo "  l, log        - красивый git log"
        echo "  ac, quick     - add + commit"
        echo "  acp, full     - add + commit + push"
        echo "  sync          - синхронизация с main/master"
        echo "  undo          - отменить последний коммит"
        echo ""
        echo "Примеры:"
        echo "  gq s                    # статус"
        echo "  gq c \"Fix bug\"          # коммит"
        echo "  gq acp \"Update docs\"   # add + commit + push"
        ;;
esac

