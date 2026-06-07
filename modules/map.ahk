// ============================================================================
//  map.ahk — отметка домов (!д) и особняков (!о) на GPS-карте
//
//  Навигация по меню /gps фиксированным числом {Down} — зависит от меню игры.
// ============================================================================

// Отметить дом (1..541)
:?:!д::
SendMessage, 0x50,, 0x4190419,, A
SendInput, /Введите номер дома:{space}
Sleep 50
Input, k, I L15 V, {Enter}
if k is number
{
    if (k < 542)
    {
        if (!checkHandles())
            checkHandles()
        Sleep 100
        addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}>  {ffffff}На вашей карте отмечен {94f8ff}дом {ffffff}под номером {94f8ff}" k)
    }
    else
    {
        if (!checkHandles())
            checkHandles()
        Sleep 100
        addChatMessageEx(0x4169E1, "{FF4D00} Вы указали неверный номер дома. Номера домов от 1 до 541, попробуйте заново")
        return
    }
}
else
{
    if (!checkHandles())
        checkHandles()
    Sleep 100
    addChatMessageEx(0x4169E1, "{FF4D00}Введённая переменная не является числом, попробуйте заново")
    return
}
Sleep 400
sendChat("/gps")
Sleep 200
SendInput, {Down 15}{Enter}
Sleep 200
SendInput, %k%{Enter}
return

// Отметить особняк (1..53)
:?:!о::
SendMessage, 0x50,, 0x4190419,, A
SendInput, /Введите номер особняка:{space}
Sleep 50
Input, osoba, I L15 V, {Enter}
if osoba is number
{
    if (osoba < 54)
    {
        if (!checkHandles())
            checkHandles()
        Sleep 100
        addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}>  {ffffff}На вашей карте отмечен {94f8ff}особняк {ffffff}под номером {94f8ff}" osoba)
    }
    else
    {
        if (!checkHandles())
            checkHandles()
        Sleep 100
        addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}> {FF4D00} Вы указали неверный номер особняка. Номера особняков от 1 до 53, попробуйте заново")
        return
    }
}
else
{
    if (!checkHandles())
        checkHandles()
    Sleep 100
    addChatMessageEx(0x4169E1, "{FF4D00}Введённая переменная не является числом, попробуйте заново")
    return
}
Sleep 400
sendChat("/gps")
Sleep 200
SendInput, {Down 16}{Enter}
Sleep 200
SendInput, %osoba%{Enter}
Return
