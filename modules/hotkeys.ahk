// ============================================================================
//  hotkeys.ahk — основные горячие клавиши (Alt + 1..9, Numpad, перезагрузка)
//
//  Бинды клавиш: ! = LAlt, ^ = Ctrl. SendMessage 0x50 ... 0x4190419 —
//  принудительное переключение раскладки на английскую перед вводом команды.
// ============================================================================

// Вбить ID подозреваемого вручную
!1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
Sleep 100
SendInput, /Введите ID подозреваемого:{space}
Sleep 50
Input, UserID, I L6 V, {Enter}
addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}>  {94f8ff}ID {ffffff}подозреваемого был обновлен на {94f8ff}" UserID)
Return

// Представление
!2::
SendChat("Здравия желаю, " . dolz . ", " . zvan . " " . poz . "." )
Return

// /chase на подозреваемого
!3::
if (UserID < 1000)
    SendChat("/chase " . UserID)
else
    SendChat("/chaseid " . UserID)
Return

// /deject на подозреваемого
!4::
if (UserID < 1000)
    SendChat("/deject " . UserID)
else
    SendChat("/dejectid " . UserID)
Return

// Наручники + залом
!5::
SendChat("/cuff " . UserID)
Sleep 500
SendChat("/frac " . UserID)
Sleep 300
SendInput {sc2}{sc2}
Sleep 200
SendInput {sc5}{sc5}
Return

// Посадить в авто
!6::
SendChat("/incar " . UserID)
Sleep 500
SendChat("/me открыл дверь автомобиля, посадил задержанного в автомобиль, пристегнул ремнем безопасности")
Return

// "К обочине"
!7::
SendChat("/m [" . goska . "] Водитель, останавливаемся и прижимаемся к обочине")
Sleep 500
SendChat("/m [" . goska . "] В случае неподчинения, я открываю огонь по колёсам")
Return

// Пропуск спецтранспорта
!8::
SendChat("/m [" . goska . "] Водитель, уходим в другую полосу")
Sleep 500
SendChat("/m [" . goska . "] Пропускаем спец.транспорт")
Return

// Проблесковые маячки
!9::
SendChat("/police")
Sleep 500
SendChat("/me нажал на кнопку вкл/выкл проблесковых маячков")
Return

// /chase (окно преследования)
Numpad0::
SendChat("/chase")
Return

// /frac на подозреваемого
Numpad1::
SendChat("/frac " . UserID)
Return

// Оплата всех штрафов (Госуслуги)
Numpad5::
SendChat("/call")
Sleep 120
SendInput, {Down 10}
Sleep 120
SendInput, {Enter}
Sleep 100
SendInput, {Enter}
Sleep 100
SendInput, {Enter}
Return

// "Бакинский передок" — удержание Numpad8 (тумблер)
!Numpad9::
    Num8State := !Num8State
    if (Num8State) {
        Send, {Numpad8 down}
        addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}> {ffffff}Бакинский передок {94f8ff}включен")
    } else {
        Send, {Numpad8 up}
        addChatMessageEx(0x4169E1, "{94f8ff} AHK_MVD {155912}> {ffffff}Бакинский передок {ff2428}выключен")
    }
return

// Перезагрузка скрипта
!Numpad0::
Sleep 50
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff}Перезагрузка AHK")
reload
return
