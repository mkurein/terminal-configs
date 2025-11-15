════════════════════════════════════════════════════════════════════
           📝 КАК ИЗМЕНИТЬ МЕНЮ ВЫБОРА WORKSPACE
════════════════════════════════════════════════════════════════════

📂 ФАЙЛ ДЛЯ РЕДАКТИРОВАНИЯ:

   ~/start-zellij-choose.sh
   
   Или в репозитории:
   ~/Project/terminal-configs/macos/scripts/start-zellij-choose.sh

   🔧 КАК ДОБАВИТЬ НОВЫЙ ПУНКТ В МЕНЮ:

1. Откройте файл:
   n ~/start-zellij-choose.sh

2. Измените секцию echo (строки 14-17):
   
   echo "Выберите workspace layout:"
   echo "1) workspaceVPNmanage (40% лево / 60% право)"
   echo "2) workspaceVPNmanage-5050 (50% / 50%)"
   echo "3) Мой новый layout"                    # ← новый пункт
   echo "4) Запустить без layout"                # ← сдвинули на 4
   echo ""

3. Добавьте новый case (после строки 29):
   
   case $choice in
       1)
           echo "Запускаю workspaceVPNmanage..."
           exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage.kdl"
           ;;
       2)
           echo "Запускаю workspaceVPNmanage-5050..."
           exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage-5050.kdl"
           ;;
       3)                                          # ← новый пункт
           echo "Запускаю мой новый layout..."
           exec zellij --layout "$HOME/.config/zellij/layouts/my-new-layout.kdl"
           ;;
       4)                                          # ← сдвинули
           echo "Запускаю без layout..."
           exec zellij
           ;;
       *)
           echo "Неверный выбор, запускаю по умолчанию..."
           exec zellij --layout "$HOME/.config/zellij/layouts/workspaceVPNmanage.kdl"
           ;;
   esac

4. Сохраните файл

5. Обновите локальный файл (если редактировали в репозитории):
   cp ~/Project/terminal-configs/macos/scripts/start-zellij-choose.sh ~/

════════════════════════════════════════════════════════════════════

📋 ТЕКУЩАЯ СТРУКТУРА МЕНЮ:

┌─────────────────────────────────────────────────────────────────┐
│ Выберите workspace layout:                                     │
│ 1) workspaceVPNmanage (40% лево / 60% право)                  │
│ 2) workspaceVPNmanage-5050 (50% / 50%)                         │
│ 3) Запустить без layout                                         │
│                                                                  │
│ Ваш выбор (1-3): _                                             │
└─────────────────────────────────────────────────────────────────┘

════════════════════════════════════════════════════════════════════

🎯 ПРИМЕР: ДОБАВЛЕНИЕ 4-ГО ПУНКТА

Если хотите добавить ещё один layout:

1. Создайте layout файл:
   cp ~/.config/zellij/layouts/workspaceVPNmanage.kdl \
      ~/.config/zellij/layouts/my-project.kdl

2. Отредактируйте my-project.kdl под свой проект

3. Добавьте в start-zellij-choose.sh:
   
   echo "4) my-project (мой проект)"

4. Добавьте case:
   
   4)
       echo "Запускаю my-project..."
       exec zellij --layout "$HOME/.config/zellij/layouts/my-project.kdl"
       ;;

5. Измените пункт "без layout" на 5

════════════════════════════════════════════════════════════════════

💡 ВАЖНЫЕ МОМЕНТЫ:

• Файл должен быть исполняемым: chmod +x ~/start-zellij-choose.sh
• Layout файлы должны быть в: ~/.config/zellij/layouts/
• После изменений перезапустите Alacritty
• Если редактируете в репозитории, скопируйте обратно в ~/

════════════════════════════════════════════════════════════════════

🔍 ПРОВЕРКА:

   # Посмотреть текущий файл
   cat ~/start-zellij-choose.sh
   
   # Проверить права
   ls -la ~/start-zellij-choose.sh
   
   # Проверить layout файлы
   ls -la ~/.config/zellij/layouts/

════════════════════════════════════════════════════════════════════