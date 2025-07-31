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
    PetShopUIClass : PetShop_UI = PetShop_UI{}
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

# Pet Shop UI System
PetShop_UI := class {
    var PetShopWidget : ?widget = false
    var UIPlayer : ?player = false
    var TycoonManager : ?Tycoon_Manager = false
    
    # Map to store player's buttons for finding clicked button
    var PlayerPetButtons : [player][]button_loud = map{}
    
    # Map to store player's cash display text blocks
    var PlayerCashDisplay : [player]text_block = map{}

    StringToMessage< localizes>(value:string) : message = "{value}"
    
    ShowPetShop(Player : player, Manager : Tycoon_Manager) : void = {
        set UIPlayer = option{Player}
        set TycoonManager = option{Manager}
        
        if (PlayerUI := GetPlayerUI[Player]) {
            # Create UI only if it doesn't exist for this player
            if (PetShopWidget = false) {
                NewUI := GeneratePetShopUI(Player, Manager)
                set PetShopWidget = option{NewUI}
            }
            
            # Update button states and cash display
            UpdatePetShopButtons(Player, Manager)
            
            # Add UI to player's screen
            NewSlot := player_ui_slot{InputMode := ui_input_mode.All}
            if (ShowWidget := PetShopWidget?) {
                PlayerUI.AddWidget(ShowWidget, NewSlot)
            }
        }
    }
    
    # Close button clicked - similar to Exit function in example
    ClosePetShop(Info : widget_message) : void = {
        if (PlayerUI := GetPlayerUI[Info.Player], Root := Info.Source.GetRootWidget[]) {
            PlayerUI.RemoveWidget(Root)
        }
    }
    
    # Update button states and cash display - similar to shop example
    UpdatePetShopButtons(Player : player, Manager : Tycoon_Manager) : void = {
        # Update cash display
        if (CashText := PlayerCashDisplay[Player], PlayerCash := Manager.GameManagerDevice.GetCurrentCash[Player]) {
            CashText.SetText(StringToMessage("Cash: " + AbbreviateNumber(PlayerCash * 1.0)))
        }
        
        # Update pet buttons based on ownership and active status
        OwnedPets := Manager.GameManagerDevice.GetOwnedPets(Player)
        ActivePet := Manager.GameManagerDevice.GetActivePet(Player)
        
        for (Index := 0..PlayerPetButtons[Player].Length) {
            if (Button := PlayerPetButtons[Player][Index], Pet := Manager.AvailablePets[Index]) {
                var IsOwned : logic = false
                for (OwnedPet : OwnedPets) {
                    if (OwnedPet = Pet.PetName) {
                        set IsOwned = true
                    }
                }
                
                if (ActivePet = Pet.PetName) {
                    Button.SetText(StringToMessage("ACTIVE"))
                    Button.SetEnabled(false)
                } else if (IsOwned = true) {
                    Button.SetText(StringToMessage("ACTIVATE"))
                    Button.SetEnabled(true)
                } else {
                    Button.SetText(StringToMessage(ToString(Pet.PetPrice) + " Cash"))
                    if (PlayerCash := Manager.GameManagerDevice.GetCurrentCash[Player]) {
                        if (PlayerCash >= Pet.PetPrice) {
                            Button.SetEnabled(true)
                        } else {
                            Button.SetEnabled(false)
                        }
                    }
                }
            }
        }
    }
    
    # Generate Pet Shop UI - following the shop example pattern
    GeneratePetShopUI(Player : player, Manager : Tycoon_Manager) : widget = {
        # Cash display text block
        CashText := text_block{
            DefaultText := StringToMessage("Cash: 0")
            DefaultTextColor := MakeColorFromHex("#FFFFFF")
        }
        
        # Store cash display for this player
        if (set PlayerCashDisplay[Player] = CashText) {}
        
        # Close button
        CloseButton := button_loud{
            DefaultText := StringToMessage("❌ CLOSE")
        }
        CloseButton.OnClick().Subscribe(ClosePetShop)
        
        # Create main vertical layout
        MainVertical := stack_box{
            Orientation := orientation.Vertical
            Slots := array{
                # Title
                stack_box_slot{
                    HorizontalAlignment := horizontal_alignment.Center
                    Padding := margin{Bottom := 20.0, Top := 20.0}
                    Widget := overlay{
                        Slots := array{
                            overlay_slot{
                                Widget := texture_block{
                                    DefaultImage := VerseUIImages.MoneyCurrencyAmount
                                    DefaultDesiredSize := vector2{X := 400.0, Y := 60.0}
                                    DefaultTint := MakeColorFromHex("#FFD700")
                                }
                            },
                            overlay_slot{
                                Widget := text_block{
                                    DefaultText := StringToMessage("🐾 PET SHOP 🐾")
                                    DefaultTextColor := MakeColorFromHex("#000000")
                                    DefaultJustification := text_justification.Center
                                }
                            }
                        }
                    }
                },
                # Cash display
                stack_box_slot{
                    HorizontalAlignment := horizontal_alignment.Center
                    Padding := margin{Bottom := 20.0}
                    Widget := overlay{
                        Slots := array{
                            overlay_slot{
                                Widget := texture_block{
                                    DefaultImage := VerseUIImages.MoneyCurrencyAmount
                                    DefaultDesiredSize := vector2{X := 300.0, Y := 40.0}
                                    DefaultTint := MakeColorFromHex("#4CAF50")
                                }
                            },
                            overlay_slot{
                                Widget := CashText
                            }
                        }
                    }
                }
            }
        }
        
        # Create pet buttons
        for (Index := 0..Manager.AvailablePets.Length) {
            if (Pet := Manager.AvailablePets[Index]) {
                PetCard := GeneratePetCard(Player, Manager, Index)
                PetCardSlot := stack_box_slot{
                    HorizontalAlignment := horizontal_alignment.Center
                    Padding := margin{Bottom := 10.0}
                    Widget := PetCard
                }
                MainVertical.AddWidget(PetCardSlot)
            }
        }
        
        # Add close button
        CloseSlot := stack_box_slot{
            HorizontalAlignment := horizontal_alignment.Center
            Padding := margin{Top := 20.0, Bottom := 20.0}
            Widget := CloseButton
        }
        MainVertical.AddWidget(CloseSlot)
        
        # Main overlay with background
        return overlay{
            Slots := array{
                overlay_slot{
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Widget := texture_block{
                        DefaultImage := VerseUIImages.MoneyCurrencyAmount
                        DefaultTint := MakeColorFromHex("#000000CC")
                        DefaultDesiredSize := vector2{X := 600.0, Y := 800.0}
                    }
                },
                overlay_slot{
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Left := 30.0, Right := 30.0, Top := 30.0, Bottom := 30.0}
                    Widget := MainVertical
                }
            }
        }
    }
    
    # Generate individual pet card - following the shop example
    GeneratePetCard(Player : player, Manager : Tycoon_Manager, Index : int) : widget = {
        if (Pet := Manager.AvailablePets[Index]) {
        
        # Create pet button
        PetButton := button_loud{
            DefaultText := StringToMessage(ToString(Pet.PetPrice) + " Cash")
        }
        
        # Subscribe to button click
        PetButton.OnClick().Subscribe(BuyOrActivatePet)
        
            # Store button for this player
            if (CurrentButtons := PlayerPetButtons[Player]) {
                if (set PlayerPetButtons[Player] = CurrentButtons + array{PetButton}) {}
            } else {
                if (set PlayerPetButtons[Player] = array{PetButton}) {}
            }
        
            # Pet card layout
            return stack_box{
                Orientation := orientation.Horizontal
                Slots := array{
                    # Pet icon/info
                    stack_box_slot{
                        Widget := overlay{
                            Slots := array{
                                overlay_slot{
                                    Widget := texture_block{
                                        DefaultImage := VerseUIImages.MoneyCurrencyAmount
                                        DefaultDesiredSize := vector2{X := 60.0, Y := 60.0}
                                        DefaultTint := MakeColorFromHex("#2196F3")
                                    }
                                },
                                overlay_slot{
                                    Widget := text_block{
                                        DefaultText := StringToMessage(Pet.PetWildlifeType)
                                        DefaultTextColor := MakeColorFromHex("#FFFFFF")
                                        DefaultJustification := text_justification.Center
                                    }
                                }
                            }
                        }
                    },
                    # Pet details
                    stack_box_slot{
                        HorizontalAlignment := horizontal_alignment.Fill
                        Padding := margin{Left := 10.0}
                        Widget := stack_box{
                            Orientation := orientation.Vertical
                            Slots := array{
                                stack_box_slot{
                                    Widget := text_block{
                                        DefaultText := StringToMessage(Pet.PetName)
                                        DefaultTextColor := MakeColorFromHex("#FFFFFF")
                                    }
                                },
                                stack_box_slot{
                                    Widget := text_block{
                                        DefaultText := StringToMessage("+" + ToString(Pet.PetBoostPercentage) + "% Income")
                                        DefaultTextColor := MakeColorFromHex("#FFD700")
                                    }
                                }
                            }
                        }
                    },
                    # Purchase/Activate button
                    stack_box_slot{
                        Padding := margin{Left := 10.0}
                        Widget := PetButton
                    }
                }
            }
        } else {
            # Return empty widget if pet not found
            return stack_box{
                Orientation := orientation.Vertical
            }
        }
    }
    
    # Handle pet button clicks - following the shop example pattern
    BuyOrActivatePet(Info : widget_message) : void = {
        if (Index := PlayerPetButtons[Info.Player].Find[Info.Source], Manager := TycoonManager?) {
            if (Pet := Manager.AvailablePets[Index]) {
                OwnedPets := Manager.GameManagerDevice.GetOwnedPets(Info.Player)
                var IsOwned : logic = false
                
                # Check if player owns this pet
                for (OwnedPet : OwnedPets) {
                    if (OwnedPet = Pet.PetName) {
                        set IsOwned = true
                    }
                }
                
                if (IsOwned = true) {
                    # Activate the pet
                    Manager.GameManagerDevice.SetActivePet(Info.Player, Pet.PetName)
                    if (Agent := agent[Info.Player]) {
                        Manager.SpawnPetForPlayer(Info.Player, Pet)
                    }
                } else {
                    # Try to purchase the pet
                    if (PlayerCash := Manager.GameManagerDevice.GetCurrentCash[Info.Player]) {
                        if (PlayerCash >= Pet.PetPrice) {
                            Manager.GameManagerDevice.RemoveFromCash(Info.Player, Pet.PetPrice)
                            Manager.GameManagerDevice.AddPet(Info.Player, Pet.PetName)
                            Manager.GameManagerDevice.SetActivePet(Info.Player, Pet.PetName)
                            if (Agent := agent[Info.Player]) {
                                Manager.SpawnPetForPlayer(Info.Player, Pet)
                            }
                        }
                    }
                }
                
                # Update button states
                UpdatePetShopButtons(Info.Player, Manager)
            }
        }
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
}