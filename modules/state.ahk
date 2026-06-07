// ============================================================================
//  state.ahk — общее состояние и вспомогательные функции
//  (регистрация ID/маски, интерактивные Y/N-подтверждения, приветствие)
// ============================================================================

// Приветствие при загрузке
loadInGame() {
    global CRMP_USER_NICKNAME
    if (!checkHandles())
        checkHandles()
    Sleep 1500
    addChatMessageEx(0, "          ")
    addChatMessageEx(0, "{FFFFFF} AHK_MVD {155912}>{FFFFFF} Приветствуем, {94f8ff}" CRMP_USER_NICKNAME)
    addChatMessageEx(0, "{0082D1} AHK_MVD {155912}>{FFFFFF} Чтобы увидеть подсказку введите {94f8ff} !помощь")
    addChatMessageEx(0, "{D1000C} AHK_MVD {155912}>{FFFFFF} Автор AHK - {94f8ff}Vladislav_Shetkov{FFFFFF}/{94f8ff}Vladislav_Valekus{FFFFFF}")
    addChatMessageEx(0, "          ")
}

// Регистрация маски как активного ID (используется при употреблении наркотиков)
saveMask(maskID) {
    global UserID, playerMask
    if (playerMask != maskID) {
        playerMask := maskID
        UserID := maskID
        addChatMessageEx(-1, "{94f8ff} AHK_MVD {155912}>{FFFFFF} Маска игрока {94f8ff}" maskID " {FFFFFF}зарегистрирована")
    } else {
        addChatMessageEx(-1, "{94f8ff} AHK_MVD {155912}>{FFFFFF} Маска игрока уже в системе!")
    }
}

// Интерактивная регистрация маски (Y — принять, N — отклонить), 15 сек
saveMasktwo(maskID) {
    global UserID, playerMask
    addChatMessageEx(-1, "{94f8ff} AHK_MVD {155912}>{FFFFFF} Нажмите клавишу {155912}Y{FFFFFF}, чтобы зарегистрировать маску, {b9181b}N{FFFFFF} для отмены")
    endTime := A_TickCount + 15000
    while (A_TickCount < endTime) {
        if GetKeyState("Y", "P") {
            if (playerMask != maskID) {
                playerMask := maskID
                UserID := maskID
                addChatMessageEx(-1, "{94f8ff} AHK_MVD {155912}>{FFFFFF} Маска {94f8ff}" maskID " {FFFFFF}зарегистрирована")
            } else {
                addChatMessageEx(-1, "{94f8ff} AHK_MVD {155912}>{FFFFFF} Маска игрока уже в системе!")
            }
            return
        }
        if GetKeyState("N", "P") {
            addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}>{FFFFFF} Отклонено!")
            return
        }
        Sleep 10
    }
    addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}>{FFFFFF} Время принятия истекло")
}

// Предложение надеть наручники после спасения (ПДП). Y — да, N — нет, 15 сек.
// Выставляет cufffl, который ловит парсер на строке "Вы спасли".
autocuff(acuff) {
    global cufffl
    cufffl := False
    addChatMessageEx(-1, "{94f8ff} AHK_MVD {176114}>{FFFFFF} Вы спасаете игрока {94f8ff}" acuff "{FFFFFF}. Нажмите клавишу {94f8ff}Y{FFFFFF}, чтобы надеть на него наручники после спасения")
    addChatMessageEx(-1, "{94f8ff} AHK_MVD {176114}>{FFFFFF} Нажмите клавишу {ff2428}N{FFFFFF}, чтобы отклонить предложение")
    endTime := A_TickCount + 15000
    while (A_TickCount < endTime) {
        if GetKeyState("Y", "P") {
            cufffl := True
            sendChat("/id " acuff)
            return
        } else if GetKeyState("N", "P") {
            cufffl := False
            addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {176114}>{FFFFFF} Отклонено!")
            return
        }
        Sleep 10
    }
    addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {176114}>{FFFFFF} Время принятия истекло")
}

// Сигнализация дома: Y в течение 10 сек — отметить дом на GPS
ograb(houseId) {
    endTime := A_TickCount + 10000
    while (A_TickCount < endTime) {
        if GetKeyState("Y", "P") {
            Sleep 100
            sendChat("/gps")
            Sleep 200
            SendInput, {Down 15}{Enter}
            Sleep 200
            SendInput, %houseId%{Enter}
            return
        }
        Sleep 10
    }
}

// Наркотики рядом (известный игрок): Y — пробить ID
narkosha(playerName) {
    endTime := A_TickCount + 10000
    while (A_TickCount < endTime) {
        if GetKeyState("Y", "P") {
            sendChat("/id " playerName)
            return
        }
        Sleep 10
    }
}

// Наркотики рядом (Неизвестный): Y — зарегистрировать маску
narkosham(maskID) {
    endTime := A_TickCount + 10000
    while (A_TickCount < endTime) {
        if GetKeyState("Y", "P") {
            saveMask(maskID)
            return
        }
        Sleep 10
    }
}
