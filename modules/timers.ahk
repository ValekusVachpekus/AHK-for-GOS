// ============================================================================
//  timers.ahk — /t: время до ближайших угонок, ограблений и поездов
//
//  Если ваш часовой пояс отличается от игрового — раскомментируйте строки
//  CurrentTime := CorrectTime(CurrentTime) и задайте смещение в CorrectTime().
// ============================================================================

:?:/t::
SendInput, {esc}
sendchat("/time")
Sleep 100
SetTimer, CheckTime,  -1
SetTimer, CheckTime2, -1
SetTimer, CheckTime3, -1
return

// Угонки (каждый час 08:00–02:00)
CheckTime:
FormatTime, CurrentTime,, HH:mm
// CurrentTime := CorrectTime(CurrentTime)
TimeArray := ["08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "00:00", "01:00", "02:00"]
MinRemaining := -1, TargetTime := ""
Loop, % TimeArray.MaxIndex()
{
    Remaining := GetRemainingMinutes(CurrentTime, TimeArray[A_Index])
    if (Remaining >= 0 && (MinRemaining = -1 || Remaining < MinRemaining)) {
        MinRemaining := Remaining
        TargetTime := TimeArray[A_Index]
    }
}
if (TargetTime != "")
    addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff}До ближайшей угонки в {94f8ff}`n" TargetTime " {ffffff}осталось {94f8ff}" MinRemaining " мин.")
Return

// Ограбления (каждые 3 часа от 08:00)
CheckTime2:
FormatTime, CurrentTime,, HH:mm
// CurrentTime := CorrectTime(CurrentTime)
TimeArray := ["08:00", "11:00", "14:00", "17:00", "20:00", "23:00", "02:00"]
MinRemaining := -1, TargetTime := ""
Loop, % TimeArray.MaxIndex()
{
    Remaining := GetRemainingMinutes(CurrentTime, TimeArray[A_Index])
    if (Remaining >= 0 && (MinRemaining = -1 || Remaining < MinRemaining)) {
        MinRemaining := Remaining
        TargetTime := TimeArray[A_Index]
    }
}
if (TargetTime != "") {
    Hours := Floor(MinRemaining / 60)
    Minutes := MinRemaining - (Hours * 60)
    addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff}До ближайшего ограбления в {94f8ff}" TargetTime " {ffffff}осталось {94f8ff}" Hours " ч. " Minutes " мин.")
}
Return

// Поезд (15:00 и 19:00)
CheckTime3:
FormatTime, CurrentTime,, HH:mm
// CurrentTime := CorrectTime(CurrentTime)
TimeArray := ["15:00", "19:00"]
MinRemaining := -1, TargetTime := ""
Loop, % TimeArray.MaxIndex()
{
    Remaining := GetRemainingMinutes(CurrentTime, TimeArray[A_Index])
    if (Remaining >= 0 && (MinRemaining = -1 || Remaining < MinRemaining)) {
        MinRemaining := Remaining
        TargetTime := TimeArray[A_Index]
    }
}
if (TargetTime != "") {
    Hours := Floor(MinRemaining / 60)
    Minutes := MinRemaining - (Hours * 60)
    addChatMessageEx(0xFFFFFF, "{94f8ff} AHK_MVD {155912}> {ffffff}До ближайшего поезда в {94f8ff}" TargetTime " {ffffff}осталось {94f8ff}" Hours " ч. " Minutes " мин.")
}
Return

// Минут от Current до Target (с переходом через полночь)
GetRemainingMinutes(Current, Target) {
    CurrentMinutes := SubStr(Current, 1, 2) * 60 + SubStr(Current, 4, 2)
    TargetMinutes  := SubStr(Target, 1, 2) * 60 + SubStr(Target, 4, 2)
    if (TargetMinutes < CurrentMinutes)
        TargetMinutes += 1440
    return TargetMinutes - CurrentMinutes
}

// Коррекция часового пояса (по умолчанию -2 часа). Замените 2 на своё смещение.
CorrectTime(originalTime) {
    hour   := SubStr(originalTime, 1, 2)
    minute := SubStr(originalTime, 4, 2)
    newHour := (hour - 2 < 0) ? 24 + (hour - 2) : hour - 2
    return Format("{:02d}:{:02d}", newHour, minute)
}
