#Persistent
#NoEnv
SetBatchLines, -1

configPath := A_ScriptDir . "\config.ini"

IniRead, way, %configPath%, Config, way, C:\Users\ilusha\Desktop\PV GTA
IniRead, nickname, %configPath%, Config, CRMP_USER_NICKNAME, 
IniRead, poz, %configPath%, Config, poz, 
IniRead, dolz, %configPath%, Config, dolz, 
IniRead, zvan, %configPath%, Config, zvan, 
IniRead, goska, %configPath%, Config, goska, УФСИН

Gui, Add, Text, x20 y10 w200, Путь до папки PC:
Gui, Add, Edit, x20 y30 w380 h25 vway, %way%
Gui, Add, Button, x410 y30 w80 h25 gBrowseFolder, Выбрать папку

Gui, Add, Text, x20 y70 w200, Никнейм в игре:
Gui, Add, Edit, x20 y90 w400 h25 vnickname
GuiControl,, nickname, %nickname%

Gui, Add, Text, x20 y130 w200, Фамилия/Позывной:
Gui, Add, Edit, x20 y150 w400 h25 vpoz
GuiControl,, poz, %poz%

Gui, Add, Text, x20 y190 w200, Должность:
Gui, Add, Edit, x20 y210 w400 h25 vdolz
GuiControl,, dolz, %dolz%

Gui, Add, Text, x20 y250 w200, Звание:
Gui, Add, Edit, x20 y270 w400 h25 vzvan
GuiControl,, zvan, %zvan%

Gui, Add, Text, x20 y310 w200, Организация:
Gui, Add, DropDownList, x20 y330 w400 h120 vgoska, УМВД|ГАИ|УФСИН|другое
GuiControl, ChooseString, goska, %goska%

Gui, Add, Button, x150 y380 w100 h30 gSaveConfig, Сохранить
Gui, Add, Button, x270 y380 w100 h30 gCancelDialog, Отмена

Gui, Show, w520 h430, Конфигурация AHK_MVD
return

BrowseFolder:
FileSelectFolder, SelectedFolder, , 0, Выберите папку с папкой PC
if (SelectedFolder != "")
{
    GuiControl,, way, %SelectedFolder%
}
return

SaveConfig:
GuiControlGet, way
GuiControlGet, nickname
GuiControlGet, poz
GuiControlGet, dolz
GuiControlGet, zvan
GuiControlGet, goska

; Если выбрано "другое", открываем диалог ввода
if (goska = "другое")
{
    InputBox, customOrg, Введите организацию, Пожалуйста, введите название организации:
    if (ErrorLevel = 0 && customOrg != "")
    {
        goska := customOrg
    }
    else
    {
        MsgBox, 0, Отмена, Организация не введена. Операция отменена.
        return
    }
}

; Формируем полный путь: way + \PC\amazing\chatlog.txt
fullPath := way . "\amazing\chatlog.txt"

IniWrite, %fullPath%, %configPath%, Config, way
IniWrite, %nickname%, %configPath%, Config, CRMP_USER_NICKNAME
IniWrite, %poz%, %configPath%, Config, poz
IniWrite, %dolz%, %configPath%, Config, dolz
IniWrite, %zvan%, %configPath%, Config, zvan
IniWrite, %goska%, %configPath%, Config, goska

MsgBox, 0, Успех, Конфигурация сохранена успешно!`nПуть: %fullPath%
ExitApp
return

CancelDialog:
ExitApp
return

GuiClose:
ExitApp
return
