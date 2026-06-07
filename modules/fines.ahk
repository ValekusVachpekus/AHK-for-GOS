// ============================================================================
//  fines.ahk — штрафы и розыск (!ш — обычный, !шук — уголовный, !су — розыск)
// ============================================================================

// Обычный штраф (КД 30 сек)
:?:!ш::
SendInput, {Enter}
SendChat("/frac " . UserID)
Sleep 300
SendInput {sc2}{sc2}
Sleep 200
SendInput {sc7}{sc7}
Sleep 200
SendInput {sc2}{sc2}
Sleep 200
SendChat("/me достал КПК, авторизовался как " . dolz . ", ввел данные гражданина, начал выписывать штраф")
Sleep 30000
addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}> {ffffff} 30 секунд прошло!")
Return

// Уголовный штраф: дробит сумму по 50000 за итерацию.
// На последней итерации списывается ОСТАТОК, а не фиксированные 50000.
:?:!шук::
SendMessage, 0x50,, 0x4190419,, A
SendInput, /Введите сумму штрафа:{space}
Sleep 50
Input, fine_amount, I L10 V, {Enter}

SendInput, {F6}
Sleep 100
SendInput, /Введите номер статьи (ст. <Номер> УК):{space}
Sleep 50
Input, article_number, I L5 V, {Enter}
Sleep, 200

repetitions := Ceil(fine_amount / 50000)
remaining   := fine_amount

SendInput, {Enter}
Sleep, 300

Loop, %repetitions%
{
    thisAmount := (remaining > 50000) ? 50000 : remaining

    addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}> {ffffff} Не нажимайте кнопки несколько секунд, выписывается штраф {94f8ff}")
    Sleep 500
    SendChat("/frac " . UserID)
    Sleep 400
    SendInput {sc2}{sc2}
    Sleep 300
    SendInput {sc7}{sc7}
    Sleep 300
    SendInput {sc2}{sc2}
    Sleep 300
    SendInput {Down}
    Sleep 300
    SendInput {Enter}
    Sleep 300

    SendInput, %thisAmount%
    Sleep 300
    SendInput {Tab}
    Sleep 300

    SendInput, ст. %article_number% УК
    Sleep 300
    SendInput {Enter}
    Sleep 300

    remaining -= thisAmount
    current_progress := fine_amount - remaining
    addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}> {ffffff} Процесс выписывания штрафа {94f8ff}(" current_progress "/" fine_amount ")")

    if (A_Index < repetitions)
        Sleep, 27700
}

addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}> {ffffff} Штраф на сумму {94f8ff}" fine_amount " руб.{ffffff} по {94f8ff}ст. " article_number " УК{ffffff} выписан полностью!")

fine_amount := ""
article_number := ""
repetitions := ""
remaining := ""
current_progress := ""
Return

// Выдать розыск (КД 20 сек)
:?:!су::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {Enter}
if (UserID = "") {
    addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff} Вы не зарегистрировали ID в системе")
} else {
    SendChat("/su " . UserID)
    Sleep 500
    SendChat("/me достал КПК, авторизовался как " . dolz . ", ввел данные гражданина")
    Sleep 3000
    SendChat("/do Личное дело найдено.")
    Sleep 3000
    SendChat("/me начал вводить корректировки")
    Sleep 14000
    addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}> {ffffff} 20 секунд прошло!")
}
return
