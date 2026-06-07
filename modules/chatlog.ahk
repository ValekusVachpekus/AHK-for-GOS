// ============================================================================
//  chatlog.ahk — парсер чатлога (запускается по таймеру из main.ahk)
//
//  Каждый тик читает все новые строки от %strings% до конца файла и
//  реагирует на события. На EOF цикл выходит (никакого busy-wait).
// ============================================================================

ProcessChatLog:
{
    Loop {
        FileReadLine, line, %way%, %strings%
        if ErrorLevel          // строк больше нет — ждём следующего тика
            break

        // --- Пробив ООП: запрос местоположения от нашего ника -> /id ---
        if (InStr(line, CRMP_USER_NICKNAME) && InStr(line, "местоположение")) {
            if RegExMatch(line, "\[(\d+)\]", zapros)
                sendChat("/id " zapros1)
        }

        // --- Тазер/дубинка: оглушение -> пробить ID или маску ---
        else if (InStr(line, "Вы оглушили") && (InStr(line, "с помощью дубинки") || InStr(line, "с помощью электрошокера"))) {
            if (InStr(line, "Неизвестный [")) {
                RegExMatch(line, "Вы оглушили Неизвестный \[(.*)\] с помощью", pmask)
                saveMasktwo(pmask1)
            } else {
                RegExMatch(line, "Вы оглушили (.*) с помощью", name)
                sendChat("/id " name1)
            }
        }

        // --- Сигнализация дома -> предложить отметить на GPS ---
        else if (InStr(line, "[R] Внимание всем постам") && InStr(line, "Сработала сигнализация дома")) {
            RegExMatch(line, "Сработала сигнализация дома (.*), возможно", pid)
            RegHomeId := pid1
            addChatMessageEx(-1, "{94f8ff} AHK_MVD {155912}> {ffffff}Нажмите {94f8ff}Y{FFFFFF} если вы хотите отметить дом {94f8ff}" RegHomeId ".")
            ograb(RegHomeId)
        }

        // --- Употребление наркотиков рядом -> предложить записать ID/маску ---
        else if (InStr(line, "употребил(-а)") && (InStr(line, "мятную пудру") || InStr(line, "зеленый чай"))) {
            if (InStr(line, "Неизвестный [")) {
                RegExMatch(line, "Неизвестный \[(\d+)\]", pmmask)
                addChatMessageEx(-1, "{94f8ff} AHK_MVD {155912}> {ffffff}Рядом с вами употребили наркотики, нажмите {94f8ff}Y{FFFFFF}, чтобы записать маску игрока")
                narkosham(pmmask1)
            } else {
                RegExMatch(line, "(\w+_\w+) употребил", narko)
                addChatMessageEx(-1, "{94f8ff} AHK_MVD {155912}> {ffffff}Рядом с вами употребили наркотики, нажмите {94f8ff}Y{FFFFFF}, чтобы записать ID игрока")
                narkosha(narko1)
            }
        }

        // --- Преследование за подозреваемым -> пробить его ID ---
        else if (InStr(line, CRMP_USER_NICKNAME) && InStr(line, "преследование")) {
            if RegExMatch(line, "\[(\d+)\] начал преследование за (\w+_\w+) \[(\d+)\]", presled)
                sendChat("/id " presled3)
        }

        // --- "Игроки онлайн:" (/find) -> взять ID из строки совпадения ---
        else if (InStr(line, "Игроки онлайн:")) {
            nickLine := strings + 2
            Sleep 25
            FileReadLine, nick, %way%, %nickLine%
            if (!ErrorLevel && !InStr(nick, "Совпадений не найдено")) {
                if RegExMatch(nick, "\}\[(.*)\]", pid) {
                    UserID := pid1
                    addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}>  {94f8ff}ID {ffffff}подозреваемого был обновлен на {94f8ff}" UserID)
                }
            }
            strings += 2          // пропускаем заголовок + строку совпадения
        }

        // --- ПДП: начали спасать игрока -> предложить авто-наручники ---
        else if (InStr(line, "Вы начали") && InStr(line, "спасать игрока")) {
            if (!InStr(line, "Неизвестный [")) {
                if RegExMatch(line, "Вы начали спасать игрока (\w+_\w+)!", acuff)
                    autocuff(acuff1)
            }
        }

        // --- ПДП: спасли игрока + согласие -> автоматический залом ---
        else if (InStr(line, "Вы спасли") && cufffl) {
            SendChat("/cuff " . UserID)
            Sleep 500
            SendChat("/frac " . UserID)
            Sleep 300
            SendInput {sc2}{sc2}
            Sleep 200
            SendInput {sc5}{sc5}
            cufffl := False
        }

        strings += 1
    }
}
return
