// ============================================================================
//  docs.ahk — управление оверлеями справки (устав ВУ, постановление ФП),
//  быстрое меню (!X) и список команд (!помощь).
//  Содержимое оверлеев (vu1..3, fp1..3, help, help1) — в docs_content.ahk.
// ============================================================================

// Внутренний устав (ВУ): открыть/закрыть
:?:!ву::
{
    SendInput, {Enter}
    if (current_doc != 1) {
        CloseAllDocs()
        current_doc := 1
        flvu1 := True
        vu1(flvu1)
    } else {
        CloseAllDocs()
        current_doc := 0
    }
    Return
}

// Федеральное постановление (ФП): открыть/закрыть
:?:!фп::
{
    SendInput, {Enter}
    if (current_doc != 2) {
        CloseAllDocs()
        current_doc := 2
        flfp1 := True
        fp1(flfp1)
    } else {
        CloseAllDocs()
        current_doc := 0
    }
    Return
}

// Список команд
:?:!помощь::
help1()
Return

// Быстрое меню помощи (тумблер)
!X::
{
    State4 := !State4
    help(State4)
    Return
}

// Листание страниц активного документа.
// #If: когда документ не открыт (current_doc = 0), PgUp/PgDn работают штатно.
#If (current_doc = 1)
PgUp::NavigateVU("next")
PgDn::NavigateVU("prev")
#If (current_doc = 2)
PgUp::NavigateFP("next")
PgDn::NavigateFP("prev")
#If

NavigateVU(direction) {
    global flvu1, flvu2, flvu3
    if (flvu1) {
        flvu1 := False
        flvu2 := (direction == "next")
        flvu3 := (direction == "prev")
        if (flvu2)
            vu2(True)
        if (flvu3)
            vu3(True)
    }
    else if (flvu2) {
        flvu2 := False
        flvu3 := (direction == "next")
        flvu1 := (direction == "prev")
        if (flvu3)
            vu3(True)
        if (flvu1)
            vu1(True)
    }
    else if (flvu3) {
        flvu3 := False
        flvu1 := (direction == "next")
        flvu2 := (direction == "prev")
        if (flvu1)
            vu1(True)
        if (flvu2)
            vu2(True)
    }
}

NavigateFP(direction) {
    global flfp1, flfp2, flfp3
    if (flfp1) {
        flfp1 := False
        flfp2 := (direction == "next")
        flfp3 := (direction == "prev")
        if (flfp2)
            fp2(True)
        if (flfp3)
            fp3(True)
    }
    else if (flfp2) {
        flfp2 := False
        flfp3 := (direction == "next")
        flfp1 := (direction == "prev")
        if (flfp3)
            fp3(True)
        if (flfp1)
            fp1(True)
    }
    else if (flfp3) {
        flfp3 := False
        flfp1 := (direction == "next")
        flfp2 := (direction == "prev")
        if (flfp1)
            fp1(True)
        if (flfp2)
            fp2(True)
    }
}

CloseAllDocs() {
    global flvu1, flvu2, flvu3, flfp1, flfp2, flfp3
    Gui Destroy
    flvu1 := flvu2 := flvu3 := False
    flfp1 := flfp2 := flfp3 := False
}
