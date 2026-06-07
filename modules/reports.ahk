// ============================================================================
//  reports.ahk — доклады (департамент, СОС, патруль, пост, угон, ВК, поезд)
//
//  ВНИМАНИЕ: !деп использует {right 8} — сдвиг курсора зависит от длины
//  названия организации. Если организация из 4 букв -> {right 9}, из 5 -> {right 10}.
// ============================================================================

// Связь с департаментом
:?:!деп::
SendMessage, 0x50,, 0x4190419,, A
SendInput /d [%goska%/] Говорит %dolz% %zvan% %poz%.{left 100}{right 8}
Return

// СОС: выезд / прибытие
:?:!сос::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %zvan% %poz%. Выехал на вызов СОС.
Return

:?:!сос1::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r Докладывает: %zvan% %poz%. Прибыл на вызов СОС.
Return

// Патруль: начало / продолжение / завершение
:?:!патруль::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r  Докладывает %zvan% %poz%: Начал патруль НО. Состав-2, Код-1.{left 8}
Return

:?:!патруль1::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r  Докладывает %zvan% %poz%: Продолжаю патруль НО. Состав-2, Код-1.{left 8}
Return

:?:!патруль2::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r  Докладывает %zvan% %poz%: Завершил патруль НО. Состав-2, Код-1.{left 8}
Return

// Пост: начало / продолжение / завершение
:?:!пост::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r  Докладывает %zvan% %poz%: Начал дежурство на посту . Состав-1, Состяние стабильное{left 31}
Return

:?:!пост1::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r  Докладывает %zvan% %poz%: Продолжаю дежурство на посту . Состав-1, Состяние стабильное{left 31}
Return

:?:!пост2::
SendMessage, 0x50,, 0x4190419,, A
SendInput /r  Докладывает %zvan% %poz%: Завершил дежурство на посту . Состав-1, Состяние стабильное{left 31}
Return

// Угон авто: выезд / прибытие
:?:!угон::
SendInput, {Enter}
SendChat("/r Докладывает " . zvan . " " . poz . ": выехал на вызов об автоугоне.")
Return

:?:!угон1::
SendInput, {Enter}
SendChat("/r Докладывает " . zvan . " " . poz . ": прибыл на вызов об автоугоне.")
Return

// Военная колонна: начало / завершение
:?:!вк::
SendMessage, 0x50,, 0x4190419,, A
SendInput, /r Докладывает: %zvan% %poz%. Начал сопровождение военной колонны C-1, К-1.{left 6}
Return

:?:!вк1::
SendMessage, 0x50,, 0x4190419,, A
SendInput, /r Докладывает: %zvan% %poz%. Завершил сопровождение военной колонны C-1, К-1.{left 6}
Return

// Доклад о крушении поезда (1/2/3 — место, 4 — отмена), 15 сек
:?:!поезд::
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff} Нажмите на кнопку {94f8ff}1{ffffff}, если поезд потерпел крушение в {94f8ff}пгт.Батырево")
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff} Нажмите на кнопку {94f8ff}2{ffffff}, если поезд потерпел крушение в {94f8ff}г.Лыткарино")
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff} Нажмите на кнопку {94f8ff}3{ffffff}, если поезд потерпел крушение на заводе {94f8ff}г.Арзамас")
addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff} Нажмите на кнопку {ff2428}4{ffffff}, для {94f8ff}отмены действия")
endTime := A_TickCount + 15000
while (A_TickCount < endTime) {
    if GetKeyState("1", "P") {
        sendChat("/r Докладывает: " . zvan . "." . poz . ". Крушение поезда произошло в пгт.Батырево")
        break
    }
    if GetKeyState("2", "P") {
        sendChat("/r Докладывает: " . zvan . "." . poz . ". Крушение поезда произошло в г.Лыткарино.")
        break
    }
    if GetKeyState("3", "P") {
        sendChat("/r Докладывает: " . zvan . "." . poz . ". Крушение поезда произошло на заводе г.Арзамас.")
        break
    }
    if GetKeyState("4", "P") {
        addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff}Выбор отменен")
        break
    }
    Sleep 10
}
Return
