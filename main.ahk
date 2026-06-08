#CommentFlag //
// ============================================================================
//  AHK-for-GOS — биндер для Amazing Online (МВД/ГАИ/УФСИН)
//  AutoHotkey v1 (Unicode-сборка, файлы в UTF-8 with BOM).
//
//  Точка входа: загрузка конфига, объявление глобалов, инициализация,
//  запуск парсера чатлога по таймеру. Хоткеи/функции — в modules\*.
//
//  ВАЖНО: #CommentFlag // должен идти ПЕРВОЙ строкой — иначе //-комментарии
//  выше неё парсятся как код. Модули подключаются ниже, флаг уже активен.
// ============================================================================

#NoEnv
#SingleInstance Force
#Persistent
#KeyHistory 0
SetBatchLines, -1

// ---------------------------------------------------------------------------
//  Авто-подъём прав администратора
//  (без админ-прав OpenProcess не откроет игру → инъекция/чат не работают)
// ---------------------------------------------------------------------------
if (!A_IsAdmin) {
    try Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
    ExitApp
}

// ---------------------------------------------------------------------------
//  Загрузка конфигурации
// ---------------------------------------------------------------------------
configPath := A_ScriptDir . "\config.ini"
IniRead, way,                %configPath%, Config, way,                C:\Amazing Games\Amazing Online\PC\amazing\chatlog.txt
IniRead, CRMP_USER_NICKNAME, %configPath%, Config, CRMP_USER_NICKNAME, Vladislav_Shetkov
IniRead, poz,                %configPath%, Config, poz,                Фантом
IniRead, dolz,               %configPath%, Config, dolz,               инспектор СР ДПС
IniRead, zvan,               %configPath%, Config, zvan,               прапорщик
IniRead, goska,              %configPath%, Config, goska,              ГАИ

// ---------------------------------------------------------------------------
//  Глобальное состояние (super-global — видно во всех функциях и #If)
// ---------------------------------------------------------------------------
global CRMP_USER_NICKNAME, poz, dolz, zvan, goska, way

global UserID      := ""      // ID/маска активного подозреваемого ("" = не задан)
global playerMask  := ""      // последняя зарегистрированная маска
global cufffl      := False   // флаг "надеть наручники после спасения (ПДП)"
global strings     := 1       // номер следующей читаемой строки чатлога
global Num8State   := False   // состояние "бакинского передка" (!Numpad9)

// Состояние оверлеев справки (ВУ/ФП)
global current_doc := 0
global flvu1 := False, flvu2 := False, flvu3 := False
global flfp1 := False, flfp2 := False, flfp3 := False
global State4 := False         // состояние быстрого меню (!X)

// Хендлы процесса игры и буферы инъекции (UDF/common.ahk).
// ВАЖНО: объявлять super-global ИМЕННО ЗДЕСЬ (auto-execute секция). Если оставить
// эти global только в common.ahk (подключается ниже, после return) — они НЕ станут
// super-global, и checkHandles() будет всегда возвращать false → чат/инъекция мертвы.
global hGTA := 0x0, dwGTAPID := 0x0, dwSAMP := 0x0, pMemory := 0x0
global pParam1 := 0x0, pParam2 := 0x0, pParam3 := 0x0, pParam4 := 0x0, pParam5 := 0x0
global pInjectFunc := 0x0, iRefreshHandles := 0
global GAME_MP_ModuleName := "azmp.dll"   // имя модуля мультиплеера
global GAME_PID := "AMAZING ONLINE"       // заголовок окна игры (для WinGet PID)

// ---------------------------------------------------------------------------
//  Инициализация
// ---------------------------------------------------------------------------
Sleep 1000
loadInGame()

// Чистим старый чатлог, чтобы парсер начинал с пустого файла
if FileExist(way)
    FileDelete, %way%

// Парсер читает новые строки чатлога каждые 100 мс (без busy-wait)
SetTimer, ProcessChatLog, 100
return   // <-- конец auto-execute; ниже только подключения модулей

// ---------------------------------------------------------------------------
//  Модули
// ---------------------------------------------------------------------------
#Include %A_ScriptDir%\lib\UDF.ahk
#Include %A_ScriptDir%\modules\state.ahk
#Include %A_ScriptDir%\modules\chatlog.ahk
#Include %A_ScriptDir%\modules\hotkeys.ahk
#Include %A_ScriptDir%\modules\reports.ahk
#Include %A_ScriptDir%\modules\roleplay.ahk
#Include %A_ScriptDir%\modules\fines.ahk
#Include %A_ScriptDir%\modules\map.ahk
#Include %A_ScriptDir%\modules\timers.ahk
#Include %A_ScriptDir%\modules\docs.ahk
#Include %A_ScriptDir%\modules\docs_content.ahk
