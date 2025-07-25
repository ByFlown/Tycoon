using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters }
using { /Verse.org/Assets }
using { /Fortnite.com/UI }

Player_Tycoon_Class := class {
    AgentOB : agent

    var IsAlreadyOwnerOfTycoon : logic = false

    MainPlayerUIClass : Player_Tycoon_Main_UI = Player_Tycoon_Main_UI{}
}


Player_Tycoon_Main_UI := class {
    var AmountOfCashImage : texture = VerseUIImages.MoneyCurrencyAmount
    var AmountOfGemsImage : texture = VerseUIImages.MoneyCurrencyAmount
    var AmountOfRebirthTokensImage : texture = VerseUIImages.MoneyCurrencyAmount

    StringToMessage< localizes>(value:string) : message = "{value}"

    var AmountOfCash : text_block = text_block {
        DefaultTextColor := MakeColorFromHex("#FFFFFF")
    }

    var AmountOfGems : text_block = text_block {
        DefaultTextColor := MakeColorFromHex("#00FF00")
    }

    var AmountOfRebirthTokens : text_block = text_block {
        DefaultTextColor := MakeColorFromHex("#FFD700")
    }

    Init(Player : player) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            PlayerUI.AddWidget(AddAllCurrencyUI())
            # Initialize text with current values
            UpdateAllCurrencies(Player, 0, 0, 0)
        }
    }

    UpdateCash(Player : player, Cash : int) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            AmountOfCash.SetText(StringToMessage(AbbreviateNumber((Cash) * 1.0)))
        }
    }

    UpdateGems(Player : player, Gems : int) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            AmountOfGems.SetText(StringToMessage(AbbreviateNumber((Gems) * 1.0)))
        }
    }

    UpdateRebirthTokens(Player : player, RebirthTokens : int) : void = {
        if (PlayerUI := GetPlayerUI[Player]) {
            AmountOfRebirthTokens.SetText(StringToMessage(AbbreviateNumber((RebirthTokens) * 1.0)))
        }
    }

    UpdateAllCurrencies(Player : player, Cash : int, Gems : int, RebirthTokens : int) : void = {
        UpdateCash(Player, Cash)
        UpdateGems(Player, Gems)
        UpdateRebirthTokens(Player, RebirthTokens)
    }

    AbbreviateNumber(value:float) : string = {
        if (value >= 1000000000.0) {
            return ToTruncatedString(value / 1000000000.0, 2) + "B"
        } else if (value >= 1000000.0) {
            return ToTruncatedString(value / 1000000.0, 2) + "M"
        } else if (value >= 1000.0) {
            return ToTruncatedString(value / 1000.0, 2) + "K"
        } else {
            return ToTruncatedString(value, 0)
        }
    }

    ToTruncatedString< public>(Number:float, Decimals:int):[]char=
        var Str:[]char = ToString(Number)
        if:
            DotIndex := Str.Find['.']
            StopIndex := if (Decimals > 0) then Min(DotIndex+Decimals+1,Str.Length) else DotIndex
            if (StrT := Str.Slice[0, StopIndex]) {
                set Str = StrT
            }
        return Str


    AddAllCurrencyUI() : canvas = {
        NewCanvas := canvas{
            Slots := array {
                # Cash Currency Display
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.0, Y := 0.0}}
                    Offsets := margin{Left := 20.0, Top := 420.0, Right := 68.0, Bottom := 468.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 0
                    Widget := texture_block{
                        DefaultImage := AmountOfCashImage
                        DefaultDesiredSize := vector2{X := 48.0, Y := 48.0}
                    }
                }
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := 80.0, Top := 424.0, Right := 0.0, Bottom := 476.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 1
                    Widget := AmountOfCash
                }
                # Gems Currency Display  
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.0, Y := 0.0}}
                    Offsets := margin{Left := 20.0, Top := 490.0, Right := 68.0, Bottom := 538.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 0
                    Widget := texture_block{
                        DefaultImage := AmountOfGemsImage
                        DefaultDesiredSize := vector2{X := 48.0, Y := 48.0}
                    }
                }
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := 80.0, Top := 494.0, Right := 0.0, Bottom := 546.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 1
                    Widget := AmountOfGems
                }
                # Rebirth Tokens Currency Display
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.0, Y := 0.0}}
                    Offsets := margin{Left := 20.0, Top := 560.0, Right := 68.0, Bottom := 608.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 0
                    Widget := texture_block{
                        DefaultImage := AmountOfRebirthTokensImage
                        DefaultDesiredSize := vector2{X := 48.0, Y := 48.0}
                    }
                }
                canvas_slot {
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                    Offsets := margin{Left := 80.0, Top := 564.0, Right := 0.0, Bottom := 616.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    ZOrder := 1
                    Widget := AmountOfRebirthTokens
                }
            }
        }
    }
}