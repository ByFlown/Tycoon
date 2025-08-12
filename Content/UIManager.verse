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
    LuckyWheelUIClass : LuckyWheel_UI = LuckyWheel_UI{}
}


Player_Tycoon_Main_UI := class {
    var AmountOfCashImage : texture = VerseUIImages.MoneyCurrencyAmount
    var AmountOfGemsImage : texture = VerseUIImages.MoneyCurrencyAmount
    var AmountOfRebirthTokensImage : texture = VerseUIImages.MoneyCurrencyAmount
    
    var UIInitialized : logic = false

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
        if (UIInitialized = false) {
            if (PlayerUI := GetPlayerUI[Player]) {
                PlayerUI.AddWidget(AddAllCurrencyUI())
                set UIInitialized = true
                # Initialize text will be done by the first UpdateAllCurrencies call with real values
            }
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

LuckyWheel_UI := class {
    var WheelMaterial : UI_Wheel.M_Fortune_Wheel_material = UI_Wheel.M_Fortune_Wheel_material{}
    var WheelCanvas : ?widget = false
    var IsWheelActive : logic = false
    var CurrentPlayer : ?player = false
    var CurrentLuckyWheel : ?LuckyWheelClass = false
    var TycoonManager : ?Tycoon_Manager = false
    
    StringToMessage< localizes>(value:string) : message = "{value}"
    
    CreateRewardSectorsDisplay() : widget = {
        if (LuckyWheel := CurrentLuckyWheel?) {
            # Build the slots array statically
            var RewardSlots : []stack_box_slot = array{}
            
            # Add title
            TitleText := text_block{
                DefaultText := StringToMessage("🎰 Lucky Wheel Rewards 🎰")
                DefaultTextColor := MakeColorFromHex("#FFD700")
            }
            
            TitleSlot := stack_box_slot{
                Widget := TitleText
                HorizontalAlignment := horizontal_alignment.Center
                Padding := margin{Bottom := 10.0}
            }
            set RewardSlots = RewardSlots + array{TitleSlot}
            
            # Add each reward
            for (Index := 0..LuckyWheel.WheelRewards.Length) {
                if (Reward := LuckyWheel.WheelRewards[Index], ModIndex := Mod[Index, 6]) {
                    # Use different colors for each sector
                    SectorColor := case (ModIndex) {
                        0 => "#FF6B6B" # Red
                        1 => "#4ECDC4" # Teal
                        2 => "#45B7D1" # Blue  
                        3 => "#F9CA24" # Yellow
                        4 => "#6C5CE7" # Purple
                        5 => "#A0E7E5" # Light Blue
                        _ => "#FFFFFF" # White fallback
                    }
                    
                    RewardText := text_block{
                        DefaultText := StringToMessage("🎯 Sector {Index + 1}: {Reward.RewardDescription}")
                        DefaultTextColor := MakeColorFromHex(SectorColor)
                    }
                    
                    RewardSlot := stack_box_slot{
                        Widget := RewardText
                        HorizontalAlignment := horizontal_alignment.Center
                        Padding := margin{Top := 3.0, Bottom := 3.0}
                    }
                    set RewardSlots = RewardSlots + array{RewardSlot}
                }
            }
            
            # Add spin cost info
            SpinCostText := text_block{
                DefaultText := StringToMessage("💰 Spin Cost: {LuckyWheel.SpinCost} Cash")
                DefaultTextColor := MakeColorFromHex("#FFA500")
            }
            
            SpinCostSlot := stack_box_slot{
                Widget := SpinCostText
                HorizontalAlignment := horizontal_alignment.Center
                Padding := margin{Top := 10.0}
            }
            set RewardSlots = RewardSlots + array{SpinCostSlot}
            
            # Create the final stack box
            RewardsList := stack_box{
                Orientation := orientation.Vertical
                Slots := RewardSlots
            }
            
            return RewardsList
        }
        
        # Fallback if no wheel configured
        return text_block{
            DefaultText := StringToMessage("❌ Wheel Not Configured")
            DefaultTextColor := MakeColorFromHex("#FF0000")
        }
    }
    
    CreateWheelDisplay() : widget = {
        # Create a simple circular wheel representation
        WheelCircle := color_block{
            DefaultColor := MakeColorFromHex("#1a1a1a"),
            DefaultDesiredSize := vector2{X := 200.0, Y := 200.0}
        }
        
        # Create pointer/arrow
        PointerText := text_block{
            DefaultText := StringToMessage("🔻")
            DefaultTextColor := MakeColorFromHex("#FF0000")
        }
        
        # Stack them
        WheelStack := stack_box{
            Orientation := orientation.Vertical
            Slots := array{
                stack_box_slot{
                    Widget := PointerText
                    HorizontalAlignment := horizontal_alignment.Center
                },
                stack_box_slot{
                    Widget := WheelCircle
                    HorizontalAlignment := horizontal_alignment.Center
                }
            }
        }
        
        return WheelStack
    }
    
    # Removed reward display functions - wheel image shows the rewards visually
    
    ShowLuckyWheel(Player : player) : void = {
        # Prevent multiple wheel instances
        if (IsWheelActive = true) { 
            Print("Lucky wheel already active for player - skipping")
            return 
        }
        
        Print("ShowLuckyWheel called - creating new wheel UI")
        set CurrentPlayer = option{Player}
        
        if (PlayerUI := GetPlayerUI[Player]) {
            set IsWheelActive = true
            
            # Always create fresh UI to prevent spawning issues
            NewUI := GenerateLuckyWheelUI(Player)
            set WheelCanvas = option{NewUI}
            
            # Add UI to player's screen with proper input mode (like PetShop)
            UISlot := player_ui_slot{InputMode := ui_input_mode.All}
            if (ShowWidget := WheelCanvas?) {
                PlayerUI.AddWidget(ShowWidget, UISlot)
                Print("Lucky wheel UI successfully added to player screen")
            }
        }
    }
    
    SetupWheel(Player : player, LuckyWheel : LuckyWheelClass, Manager : Tycoon_Manager) : void = {
        Print("SetupWheel called - configuring wheel data")
        set CurrentLuckyWheel = option{LuckyWheel}
        set TycoonManager = option{Manager}
    }
    
    GenerateLuckyWheelUI(Player : player) : widget = {
        # Use the original wheel material for visual spinning
        FortuneWheelWidget : material_block = material_block{
            DefaultImage := WheelMaterial,
            DefaultDesiredSize := vector2{X := 300.0, Y := 300.0}
        }
        
        # Spin button
        SpinButton : button_loud = button_loud{
            DefaultText := StringToMessage("🎰 SPIN WHEEL!")
        }
        SpinButton.OnClick().Subscribe(SpinWheel)
        
        # Close button
        CloseButton : button_loud = button_loud{
            DefaultText := StringToMessage("❌ CLOSE")
        }
        CloseButton.OnClick().Subscribe(CloseLuckyWheel)
        
        # Create main layout using stack_box like PetShop
        MainVertical := stack_box{
            Orientation := orientation.Vertical
            Slots := array{
                # Just the spinning wheel
                stack_box_slot{
                    Widget := FortuneWheelWidget
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                },
                # Spin button
                stack_box_slot{
                    Widget := SpinButton
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Top := 20.0}
                },
                # Close button
                stack_box_slot{
                    Widget := CloseButton
                    HorizontalAlignment := horizontal_alignment.Center
                    VerticalAlignment := vertical_alignment.Center
                    Padding := margin{Top := 10.0}
                }
            }
        }
        
        # Wrap in canvas for proper positioning and centering
        UICanvas := canvas{}
        UICanvas.AddWidget(canvas_slot:
            Widget := MainVertical
            Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
            Offsets := margin{Left := -250.0, Top := -200.0, Right := 250.0, Bottom := 200.0}
            Alignment := vector2{X := 0.5, Y := 0.5}
            SizeToContent := false
            ZOrder := 100
        )
        
        return UICanvas
    }
    
    CloseLuckyWheel(Info : widget_message) : void = {
        # Use PetShop pattern for proper widget removal
        if (PlayerUI := GetPlayerUI[Info.Player], Root := Info.Source.GetRootWidget[]) {
            Print("Closing lucky wheel UI - cleaning up")
            PlayerUI.RemoveWidget(Root)
            
            # Reset all state variables
            set WheelCanvas = false
            set IsWheelActive = false
            set CurrentPlayer = false
            set CurrentLuckyWheel = false
            set TycoonManager = false
            
            Print("Lucky wheel UI cleanup completed")
        }
    }
    
    SpinWheel(Info : widget_message) : void = {
        # Check if player can afford the spin and deduct cost
        if (Player := Info.Player, LuckyWheel := CurrentLuckyWheel?, Manager := TycoonManager?) {
            if (PlayerCash := Manager.GameManagerDevice.GetCurrentCash[Player]) {
                if (PlayerCash >= LuckyWheel.SpinCost) {
                    # Deduct spin cost
                    Manager.GameManagerDevice.RemoveFromCash(Player, LuckyWheel.SpinCost)
                    Print("Deducted {LuckyWheel.SpinCost} cash for lucky wheel spin")
                    
                    # Update UI after spin cost deduction
                    if (Agent := agent[Player]) {
                        PTC := Manager.GameManagerDevice.GetPlayerTycoonClass(Agent)
                        if (Cash := Manager.GameManagerDevice.GetCurrentCash[Player], Gems := Manager.GameManagerDevice.GetCurrentGems[Player], RebirthTokens := Manager.GameManagerDevice.GetCurrentRebirthTokens[Player]) {
                            PTC.MainPlayerUIClass.UpdateAllCurrencies(Player, Cash, Gems, RebirthTokens)
                        }
                    }
                    
                    # Start spinning animation
                    spawn{StartWheelAnimation()}
                } else {
                    Print("Not enough cash to spin the lucky wheel! Need {LuckyWheel.SpinCost} cash.")
                }
            }
        }
    }
    
    StartWheelAnimation() < suspends> : void = {
        # Wheel spin animation parameters
        var SpinDuration : float = 5.0
        var SpinSpeed : float = 0.033
        var SpinTimeToStop : float = 1.5
        initialSpinDuration := SpinDuration
        initialSpinTimeToStop := SpinTimeToStop
        
        # Animation loop
        loop:
            if (IsWheelActive = false) { break }
            
            set SpinDuration -= 0.033
            
            if (SpinDuration <= 0.0) {
                set SpinTimeToStop -= 0.033
                set WheelMaterial.Rotation_Angle += (SpinSpeed * (SpinTimeToStop/initialSpinTimeToStop))
                if (SpinTimeToStop <= 0.0) {
                    # Wheel finished spinning - handle reward directly
                    ResultIndex := GetWheelResultIndex()
                    if (Player := CurrentPlayer?, LuckyWheel := CurrentLuckyWheel?) {
                        # Show winning sector with reward info
                        if (ResultIndex >= 0, ResultIndex < LuckyWheel.WheelRewards.Length) {
                            if (WinningReward := LuckyWheel.WheelRewards[ResultIndex]) {
                                Print("🎉 Lucky Wheel landed on Sector {ResultIndex + 1}: {WinningReward.RewardDescription}! 🎉")
                            }
                        }
                        spawn{HandleWheelResult(Player, LuckyWheel, ResultIndex)}
                    }
                    
                    # Auto-close after showing result
                    Sleep(2.0)
                    if (IsWheelActive = true) {
                        if (Player := CurrentPlayer?, PlayerUI := GetPlayerUI[Player], Widget := WheelCanvas?) {
                            Print("Auto-closing lucky wheel UI after spin")
                            # Use the same removal pattern as manual close
                            PlayerUI.RemoveWidget(Widget)
                            set WheelCanvas = false
                            set IsWheelActive = false
                            set CurrentPlayer = false
                        }
                    }
                    break
                }
            } else {
                set WheelMaterial.Rotation_Angle += SpinSpeed
            }
            Sleep(0.033)
    }
    
    GetWheelResultIndex() : int = {
        if (FlooredAngle := Floor[WheelMaterial.Rotation_Angle]) {
            FractNumber := (WheelMaterial.Rotation_Angle - (FlooredAngle * 1.0))
            if (Result := Floor[FractNumber * 6.0]) {
                Print("Wheel result calculation: Angle={WheelMaterial.Rotation_Angle}, Fract={FractNumber}, Result={Result}")
                return Result
            }
        }
        Print("Wheel result calculation failed, returning 0")
        return 0
    }
    
    HandleWheelResult(Player : player, LuckyWheel : LuckyWheelClass, ResultIndex : int) < suspends> : void = {
        Print("HandleWheelResult called with index: {ResultIndex}")
        if (Manager := TycoonManager?) {
            Print("Found tycoon manager, processing reward")
            if (ResultIndex >= 0, ResultIndex < LuckyWheel.WheelRewards.Length) {
                if (WinningReward := LuckyWheel.WheelRewards[ResultIndex]) {
                    Print("Giving reward: {WinningReward.RewardDescription}")
                    Manager.GiveLuckyWheelReward(Player, WinningReward)
                } else {
                    Print("Could not find winning reward at index {ResultIndex}")
                }
            } else {
                Print("ResultIndex {ResultIndex} is out of range (0-{LuckyWheel.WheelRewards.Length})")
            }
        } else {
            Print("Could not find tycoon manager for reward processing")
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
                                        DefaultText := if (RoundedValue := Round[Pet.PetBoostPercentage * 10.0]):
                                            if (WholePart := Floor(RoundedValue / 10), DecimalPart := Mod[RoundedValue, 10]):
                                                StringToMessage("+" + ToString(WholePart) + "." + ToString(DecimalPart) + "% Income")
                                            else:
                                                StringToMessage("+" + ToString(Pet.PetBoostPercentage) + "% Income")
                                        else:
                                            StringToMessage("+" + ToString(Pet.PetBoostPercentage) + "% Income")
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