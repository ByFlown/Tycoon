using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Fortnite.com/Devices/CreativeAnimation/InterpolationTypes }
using { /Fortnite.com/Characters }
using { /Verse.org/Random }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
Handler1 := class() {
    Device : Tycoon_Manager   <#YOU MUST CHANGE "main" TO YOUR VERSE DEVICE NAME#>
    Parameter1 : string  <#Change "int" to your parameter type, ex: float, string#>

    HandlerFunction(Agent : agent) : void = {
        Device.PlayerTriesToBuyButton(Agent, Parameter1)
    }
}

DropperPropClass := class < concrete> {
    @editable DropperProp : ?creative_prop = false

    @editable DropperDropPart : ?creative_prop = false

    @editable StartPoint : vector3 = vector3{X := 0.0, Y := 0.0, Z := 0.0}

    @editable EndPoint : vector3 = vector3{X := 0.0, Y := 0.0, Z := 0.0}

    var Animateable : logic = true

    @editable DropperCashIncrease : int = 1

    @editable DropperGemsIncrease : int = 0

    @editable DropperCloneTime : float = 1.0

    @editable DropperSameAsProp : logic = false
}

MultiplierButtonClass := class < concrete>{
    @editable MultiplierButtonName : string = "MultiplierButton"
    @editable MultiplierButtonProp : creative_prop = creative_prop{}
    @editable MultiplierButtonVolume : volume_device = volume_device{}
    @editable MultiplierButtonPrice : int = 1000
    @editable MultiplierValue : float = 2.0
    @editable MultiplierDuration : float = 60.0
    var MultiplierPurchased : logic = false
}

DanceFloorClass := class < concrete>{
    @editable DanceFloorName : string = "DanceFloor"
    @editable DanceFloorProp : creative_prop = creative_prop{}
    @editable DanceFloorVolume : volume_device = volume_device{}
    @editable DanceFloorPrice : int = 5000
    @editable DanceEmoteDevice : accolades_device = accolades_device{}
    var DanceFloorPurchased : logic = false
}

JumpAndRunClass := class < concrete>{
    @editable JumpAndRunName : string = "JumpAndRun"
    @editable StartButtonProp : creative_prop = creative_prop{}
    @editable StartButtonVolume : volume_device = volume_device{}
    @editable EndButtonProp : creative_prop = creative_prop{}
    @editable EndButtonVolume : volume_device = volume_device{}
    @editable JumpAndRunPrice : int = 3000
    var JumpAndRunPurchased : logic = false
    var PlayersInCourse : [agent]logic = map{}
}

LuckyWheelClass := class < concrete>{
    @editable LuckyWheelName : string = "LuckyWheel"
    @editable LuckyWheelProp : creative_prop = creative_prop{}
    @editable LuckyWheelVolume : volume_device = volume_device{}
    @editable LuckyWheelPrice : int = 2000
    @editable SpinCost : int = 100
    var LuckyWheelPurchased : logic = false
}

PetShopClass := class < concrete>{
    @editable PetShopName : string = "PetShop"
    @editable PetShopProp : creative_prop = creative_prop{}
    @editable PetShopVolume : volume_device = volume_device{}
    @editable PetShopPrice : int = 10000
    var PetShopPurchased : logic = false
}

PetClass := class < concrete>{
    @editable PetName : string = "Pet"
    @editable PetPrice : int = 1000
    @editable PetBoostPercentage : float = 5.0
}

AllButtons := class < concrete>{
    @editable ButtonName : string = "Button"

    @editable ButtonProp : creative_prop = creative_prop{}
    
    @editable ButtonVolume : volume_device = volume_device{}
    
    @editable ButtonPrice : int = 0

    @editable ButtonGemsReward : int = 0

    @editable ButtonRebirthTokensReward : int = 0
    
    @editable ButtonsToUnlock : []creative_prop = array{}

    @editable PropsToUnlock : []creative_prop = array{}

    var Purchased : logic = false

    @editable DropperOptional : DropperPropClass = DropperPropClass{}
}

Tycoon_Manager := class(creative_device):

    var OwnerOfTycoon : ?agent = false

    #ClaimPlot
    @editable ClaimPlotVolume : volume_device = volume_device{}

    @editable ClaimPlotButton : creative_prop = creative_prop{}

    #Crate Model And Prop Manipulator
    @editable CrateModel : creative_prop = creative_prop{}

    @editable CratePropMani : prop_manipulator_device = prop_manipulator_device{}

    @editable ButtonStruct : []AllButtons = array{}

    @editable CrateAddMoneyAmount : int = 100

    @editable CrateAddGemsAmount : int = 1

    @editable CrateAddRebirthTokensAmount : int = 0

    var AllBoughtItems : []creative_prop = array{}

    var CrateAnimationDebounce : logic = true

    # New Interactive Systems
    @editable MultiplierButtons : []MultiplierButtonClass = array{}
    @editable DanceFloors : []DanceFloorClass = array{}
    @editable JumpAndRuns : []JumpAndRunClass = array{}
    @editable LuckyWheels : []LuckyWheelClass = array{}
    @editable PetShops : []PetShopClass = array{}
    @editable AvailablePets : []PetClass = array{
        PetClass{PetName := "SpeedDog", PetPrice := 1000, PetBoostPercentage := 5.0},
        PetClass{PetName := "LuckyBird", PetPrice := 2500, PetBoostPercentage := 10.0},
        PetClass{PetName := "GoldCat", PetPrice := 5000, PetBoostPercentage := 15.0},
        PetClass{PetName := "DiamondDragon", PetPrice := 15000, PetBoostPercentage := 25.0}
    }

    OnBegin< override>()< suspends>:void=

        #Check When Player Is Leaving
        GetPlayspace().PlayerRemovedEvent().Subscribe(PlayerLeftFunction)

        #Check Event For Prop Manipulator
        CratePropMani.DamagedEvent.Subscribe(PropManiDamagedFunction)

        #Initialize New Interactive Systems
        InitializeInteractiveSystems()

        #Add enter event to all volumes/buttons

        for (Item : ButtonStruct) {
            NameOfButton := Item.ButtonName
            
            #Subscribe All Buttons To Buy
            Volume := Item.ButtonVolume
            Volume.AgentEntersEvent.Subscribe(Handler1{Device:=Self, Parameter1:=NameOfButton}.HandlerFunction)

            #Make All Props Hidden
            UnlockPropsArray := Item.PropsToUnlock

            for (Prop : UnlockPropsArray) {
                Prop.Hide()
                CurrentVector3Pos := Prop.GetTransform().Translation
                CurrentRotation := Prop.GetTransform().Rotation
                NewPos := CurrentVector3Pos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                if (Prop.TeleportTo[NewPos, CurrentRotation]) {}
            }

            #Make All Buttons Hidden

            ButtonsArray := Item.ButtonsToUnlock

            for (Button : ButtonsArray) {
                Button.Hide()
                CurrentVector3Pos := Button.GetTransform().Translation
                CurrentRotation := Button.GetTransform().Rotation
                NewPos := CurrentVector3Pos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                if (Button.TeleportTo[NewPos, CurrentRotation]) {}
            }

            if (DropperPart := Item.DropperOptional.DropperDropPart?) {
                DropperPart.Hide()
            }

            if (Dropper := Item.DropperOptional.DropperProp?) {
                Dropper.Hide()
                CurrentVector3Pos := Dropper.GetTransform().Translation
                CurrentRotation := Dropper.GetTransform().Rotation
                NewPos := CurrentVector3Pos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                if (Dropper.TeleportTo[NewPos, CurrentRotation]) {}                
            }
        }

    
    PlayerTriesToBuyButton(Agent : agent, NameOfButton : string) : void = {
        Print("PlayerTriesToBuyButton called with button: {NameOfButton}")
        if (Player := player[Agent]) {
            Print("Player found for agent")
            if (NameOfButton = "Claim", OwnerOfTycoon = false) {
                Print("Claim Plot Button Clicked!")
                ClaimPlotFunction(Agent)
                return
            }

            if (OwnerOfTycoon = false) {
                Print("No Owner Of Tycoon yet")
                return
            }

            if (OwnerAgent := OwnerOfTycoon?) {
                Print("Tycoon has owner")
                if (OwnerAgent = Agent) {
                    Print("Owner matches current agent - processing button: {NameOfButton}")

                    for (Item : ButtonStruct) {
                        if (Item.ButtonName = NameOfButton) {
                            if (Item.Purchased = false) {
                                PlayerBuysButton(Agent, NameOfButton, Player)
                            }
                        }
                    }
                    
                    # Check interactive system buttons
                    HandleInteractiveSystemPurchase(Agent, NameOfButton, Player)
                } else {
                    Print("Agent is not the owner of this tycoon")
                }
            }
        } else {
            Print("Failed to get player from agent")
        }
    }


    PlayerBuysButton(Agent : agent, NameOfButton : string, Player : player) : void = {
        GameManager : game_manager = game_manager{}

        Print("PlayerBuysButton called with: {NameOfButton}")
        Print("ButtonStruct array has {ButtonStruct.Length} items")
        for (Key -> Item : ButtonStruct) {
            Print("Checking button: '{Item.ButtonName}' against '{NameOfButton}'")
            if (Item.ButtonName = NameOfButton) {
                Print("Found matching button: {NameOfButton}")
                ButtonClicked := Item.ButtonProp
                ButtonVolume := Item.ButtonVolume
                Price := Item.ButtonPrice
                Props := Item.PropsToUnlock
                Buttons := Item.ButtonsToUnlock

                if (PlayerCash := GameManager.GetCurrentCash[Player]) {
                    Print("Player has {PlayerCash} cash, button costs {Price}")
                    if (Item.Purchased = true) {
                        Print("Item.Purchased status: true")
                    } else {
                        Print("Item.Purchased status: false")
                    }
                    if (PlayerCash >= Price) {
                        Print("Player has enough cash")
                        if (Item.Purchased = false) {
                            Print("Item not purchased yet - proceeding with purchase")
                        } else {
                            Print("Item already purchased - skipping")
                        }
                    } else {
                        Print("Player doesn't have enough cash - need {Price}, have {PlayerCash}")
                    }
                    if (PlayerCash >= Price, Item.Purchased = false) {
                        Print("Purchase conditions met - buying {NameOfButton}")
                        set Item.Purchased = true

                        ButtonClicked.Hide()
                        GameManager.AddToTycoonArray(Player, Key)

                        GameManager.RemoveFromCash(Player, Price)

                        if (Item.ButtonGemsReward > 0) {
                            GameManager.AddToGems(Player, Item.ButtonGemsReward)
                        }

                        if (Item.ButtonRebirthTokensReward > 0) {
                            GameManager.AddToRebirthTokens(Player, Item.ButtonRebirthTokensReward)
                        }

                        # Separate the calls to avoid effect system conflicts
                        PTC := GameManager.GetPlayerTycoonClass(Agent)
                        if (Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
                            Print("Update Text")
                            PTC.MainPlayerUIClass.UpdateAllCurrencies(Player, Cash, Gems, RebirthTokens)
                        }

                        Print("{NameOfButton}, button should go underground")
                        CurrentVector3ButtonPos := ButtonClicked.GetTransform().Translation
                        CurrentButtonRotation := ButtonClicked.GetTransform().Rotation
                        NewButtonPos := CurrentVector3ButtonPos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                        spawn{ButtonClicked.MoveTo(NewButtonPos, CurrentButtonRotation, 0.5)}

                        for (Prop : Props) {
                            Prop.Show()
                            CurrentVector3Pos := Prop.GetTransform().Translation
                            CurrentRotation := Prop.GetTransform().Rotation
                            NewPos := CurrentVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
                            spawn{MoveToForOther(NewPos, CurrentRotation, Prop, 3.0)}
                        }

                        for (NextButton : Buttons) {
                            NextButton.Show()
                            CurrentNextButtonVector3Pos := NextButton.GetTransform().Translation
                            CurrentNextButtonRotation := NextButton.GetTransform().Rotation
                            NewNextButtonPos := CurrentNextButtonVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
                            spawn{MoveToForOther(NewNextButtonPos, CurrentNextButtonRotation, NextButton, 3.0)}
                        }

                        Print("Checking dropper setup for {NameOfButton}")
                        if (Dropper := Item.DropperOptional.DropperProp?) {
                            Print("Dropper prop found - setting up animated dropper")
                            Dropper.Show()
                            CurrentVector3Pos := Dropper.GetTransform().Translation
                            CurrentRotation := Dropper.GetTransform().Rotation
                            NewPos := CurrentVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
                            set Item.DropperOptional.Animateable = false
                            spawn{MoveDropperAndWait(NewPos, CurrentRotation, Dropper, Item)}
                        } else {
                            Print("No dropper prop - setting up simple dropper for {NameOfButton}")
                            Print("Dropper cash increase: {Item.DropperOptional.DropperCashIncrease}")
                        }
                    } else {
                        Print("Failed to get current cash for player")
                    }
                } else {
                    Print("Button name '{Item.ButtonName}' does not match '{NameOfButton}'")
                }
            }
        }
        Print("PlayerBuysButton finished - no matching button found or purchase failed")
    }

    MoveToForOther(NewPos : vector3, CurrentRotation : rotation, Prop : creative_prop, Time : float) <suspends> : void = {
        GM : game_manager = game_manager{}

        CurrentVector3Pos := Prop.GetTransform().Translation

        if (GM.PropAnimationInsteadOfTeleport_PossiblyGlitch_ = true) {
            CalcPos := NewPos - Prop.GetTransform().Translation

            PosMovementKeyFrame : keyframe_delta = keyframe_delta {
                DeltaLocation := CalcPos
                DeltaRotation := CurrentRotation
                Time := Time
                Interpolation := Linear
            }
    
            if (AnimController := Prop.GetAnimationController[]) {
                KeyFramesArray : []keyframe_delta = array{PosMovementKeyFrame}
    
                AnimController.SetAnimation(KeyFramesArray, ?Mode := animation_mode.OneShot)
    
                AnimationState := AnimController.GetState()
    
                if (AnimationState = animation_controller_state.Playing) {
    
                } else {
                    if (CurrentVector3Pos.X = CrateModel.GetTransform().Translation.X, CurrentVector3Pos.Y = CrateModel.GetTransform().Translation.Y, CurrentVector3Pos.Z = CrateModel.GetTransform().Translation.Z) { 
                        AnimController.Play()

                        AnimController.MovementCompleteEvent.Await()

                        set CrateAnimationDebounce = false
                    } else {
                        AnimController.Play()
                    }                    
                }
            }
        } else {
            if (CurrentVector3Pos.X = CrateModel.GetTransform().Translation.X, CurrentVector3Pos.Y = CrateModel.GetTransform().Translation.Y, CurrentVector3Pos.Z = CrateModel.GetTransform().Translation.Z) { 
                set CrateAnimationDebounce = false
            }
            if (Prop.TeleportTo[NewPos, CurrentRotation]) {}
        }
    }

    CratePropMoveTo(NewPos : vector3, CurrentRotation : rotation, Prop : creative_prop) < suspends> : void = {
        Results := Prop.MoveTo(NewPos, CurrentRotation, 3.0)

        if (Results = move_to_result.DestinationReached) {
            
        }
    }

    MoveDropperAndWait(NewPos : vector3, CurrentRotation : rotation, Dropper : creative_prop, Item : AllButtons) < suspends> : void = {
        CalcPos := NewPos - Dropper.GetTransform().Translation

        PosMovementKeyFrame : keyframe_delta = keyframe_delta {
            DeltaLocation := CalcPos
            DeltaRotation := CurrentRotation
            Time := 3.0
            Interpolation := Linear
        }

        if (AnimController := Dropper.GetAnimationController[]) {
            KeyFramesArray : []keyframe_delta = array{PosMovementKeyFrame}

            AnimController.SetAnimation(KeyFramesArray, ?Mode := animation_mode.OneShot)

            AnimationState := AnimController.GetState()

            if (AnimationState = animation_controller_state.Playing) {

            } else {
                AnimController.Play()

                AnimController.MovementCompleteEvent.Await()
            
                set Item.DropperOptional.Animateable = true
            }
        }
    }

    DropperSubscribeFunction(Agent : agent) < suspends> : void = {
        Print("DropperSubscribeFunction started for agent")
        loop:
            Sleep(0.0)
            if (not OwnerOfTycoon = false) {
                for (Item : ButtonStruct) {
                    if (Item.Purchased = true and Item.DropperOptional.Animateable = true) {
                        Print("Found purchased dropper: {Item.ButtonName} - ready to generate money")
                        if (Player := player[Agent]) {
                            # Check if dropper has animation components
                            if (DropperPart := Item.DropperOptional.DropperDropPart?) {
                                DropperPart.Show()

                                StartPoint := Item.DropperOptional.StartPoint
                                EndPoint := Item.DropperOptional.EndPoint

                                CurrentPos := DropperPart.GetTransform().Translation

                                ZMovement := vector3{X := 0.0, Y := 0.0, Z := EndPoint.Z - StartPoint.Z}
                                XYMovement := vector3{X := EndPoint.X - StartPoint.X, Y := EndPoint.Y - StartPoint.Y, Z := 0.0}
                        
                                ZMovementKeyFrame : keyframe_delta = keyframe_delta {
                                    DeltaLocation := ZMovement
                                    DeltaRotation := rotation{}
                                    Time := Item.DropperOptional.DropperCloneTime  
                                    Interpolation := EaseInOut
                                }
                        
                                XYMovementKeyFrame : keyframe_delta = keyframe_delta {
                                    DeltaLocation := XYMovement
                                    DeltaRotation := rotation{}
                                    Time := Item.DropperOptional.DropperCloneTime + 2.0
                                    Interpolation := Linear
                                }     
                                
                                spawn{SpawnAndGrantMoney(Agent, ZMovementKeyFrame, XYMovementKeyFrame, DropperPart, StartPoint, Item, Player)}
                            } else {
                                # Simple dropper without animation - just generate money
                                spawn{GenerateDropperMoney(Agent, Item, Player)}
                            }
                        }
                    }
                }
            } else {
                break
            }
    }

    GenerateDropperMoney(Agent : agent, Item : AllButtons, Player : player) < suspends> : void = {
        set Item.DropperOptional.Animateable = false

        GameManager : game_manager = game_manager{}

        Print("Dropper '{Item.ButtonName}' generating money for player")
        
        GameManager.AddToCashWithMultipliers(Player, Item.DropperOptional.DropperCashIncrease)
        Print("Added {Item.DropperOptional.DropperCashIncrease} cash to player from dropper '{Item.ButtonName}'")

        if (Item.DropperOptional.DropperGemsIncrease > 0) {
            GameManager.AddToGems(Player, Item.DropperOptional.DropperGemsIncrease)
            Print("Added {Item.DropperOptional.DropperGemsIncrease} gems to player from dropper '{Item.ButtonName}'")
        }

        if (PlayerCash := GameManager.GetCurrentCash[Player]) {
            Print("Player total cash after dropper '{Item.ButtonName}': {PlayerCash}")
        }

        # Update UI
        PTC := GameManager.GetPlayerTycoonClass(Agent)
        if (Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
            PTC.MainPlayerUIClass.UpdateAllCurrencies(Player, Cash, Gems, RebirthTokens)
        }

        # Wait for the cycle time
        Sleep(Item.DropperOptional.DropperCloneTime + 2.0)

        set Item.DropperOptional.Animateable = true
        Print("Dropper '{Item.ButtonName}' ready for next cycle")
    }

    SpawnAndGrantMoney(Agent : agent, KeyFrame1 : keyframe_delta, KeyFrame2 : keyframe_delta, DropperProp : creative_prop, StartPoint : vector3, Item : AllButtons, Player : player) < suspends> : void = {
        if (AnimController := DropperProp.GetAnimationController[], Item.DropperOptional.Animateable = true) {
            KeyFramesArray : []keyframe_delta = array{KeyFrame1, KeyFrame2}

            Print("{DropperProp.GetTransform().Translation}")
            
            AnimController.SetAnimation(KeyFramesArray, ?Mode := animation_mode.OneShot)

            AnimController.Play()

            set Item.DropperOptional.Animateable = false

            AnimController.MovementCompleteEvent.Await()
            
            Print("Animation completed for dropper '{Item.ButtonName}' at position: {DropperProp.GetTransform().Translation}")

            GameManager : game_manager = game_manager{}

            Print("Animated dropper '{Item.ButtonName}' generating money for player")
            
            GameManager.AddToCashWithMultipliers(Player, Item.DropperOptional.DropperCashIncrease)
            Print("Added {Item.DropperOptional.DropperCashIncrease} cash to player from animated dropper '{Item.ButtonName}'")

            if (Item.DropperOptional.DropperGemsIncrease > 0) {
                GameManager.AddToGems(Player, Item.DropperOptional.DropperGemsIncrease)
                Print("Added {Item.DropperOptional.DropperGemsIncrease} gems to player from animated dropper '{Item.ButtonName}'")
            }
    
            if (PlayerCash := GameManager.GetCurrentCash[Player]) {
                Print("Player total cash after animated dropper '{Item.ButtonName}': {PlayerCash}")
            }

            # Separate the calls to avoid effect system conflicts
            PTC := GameManager.GetPlayerTycoonClass(Agent)
            if (Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
                PTC.MainPlayerUIClass.UpdateAllCurrencies(Player, Cash, Gems, RebirthTokens)
            }

            Sleep(Item.DropperOptional.DropperCloneTime + (Item.DropperOptional.DropperCloneTime + 2.0))

            set Item.DropperOptional.Animateable = true
            Print("Animated dropper '{Item.ButtonName}' ready for next cycle")

            if (DropperProp.TeleportTo[StartPoint, rotation{}]) {
                Print("Animated dropper '{Item.ButtonName}' part reset to start position")
            }
        }
    }
    
    PropManiDamagedFunction(Agent : agent) : void = {
        if (OwnerAgent := OwnerOfTycoon?) {
            Print("Agent Good")
            if (Agent = OwnerAgent, Player := player[Agent]) {
                spawn{AnimateCrate()}

                GameManager : game_manager = game_manager{}
    
                GameManager.AddToCashWithMultipliers(Player, CrateAddMoneyAmount)

                if (CrateAddGemsAmount > 0) {
                    GameManager.AddToGems(Player, CrateAddGemsAmount)
                }

                if (CrateAddRebirthTokensAmount > 0) {
                    GameManager.AddToRebirthTokens(Player, CrateAddRebirthTokensAmount)
                }
    
                if (PlayerCash := GameManager.GetCurrentCash[Player]) {Print("{PlayerCash}")}

                # Separate the calls to avoid effect system conflicts
                PTC := GameManager.GetPlayerTycoonClass(Agent)
                if (Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
                    Print("Update Text")
                    PTC.MainPlayerUIClass.UpdateAllCurrencies(Player, Cash, Gems, RebirthTokens)
                }
            }
        }
    }
    
    AnimateCrate()< suspends> : void = {

        Factor : float = 0.8

        PropScalingDownKeyFrame : keyframe_delta = keyframe_delta {
            DeltaLocation := vector3{}
            DeltaRotation := rotation{}
            DeltaScale := vector3{X:= Factor, Y:= Factor, Z:= Factor}
            Time := 0.2
            Interpolation := EaseOut
        }
        
        PropScalingUpKeyFrame : keyframe_delta = keyframe_delta {
            DeltaLocation := vector3{}
            DeltaRotation := rotation{}
            DeltaScale := vector3{X:= 1.0 / Factor, Y:= 1.0 / Factor, Z:= 1.0 / Factor}
            Time := 0.2
            Interpolation := EaseOut
        }

        if (AnimController := CrateModel.GetAnimationController[], CrateAnimationDebounce = false) {
            KeyFramesArray : []keyframe_delta = array{PropScalingDownKeyFrame, PropScalingUpKeyFrame}

            AnimController.SetAnimation(KeyFramesArray, ?Mode := animation_mode.OneShot)

            AnimController.Play()

            set CrateAnimationDebounce = true

            AnimController.MovementCompleteEvent.Await()

            set CrateAnimationDebounce = false
        }
    }

    #Claim Plot Functionality
    ClaimPlotFunction(Agent : agent) : void = {
        Print("ClaimPlotFunction called")
        if (OwnerOfTycoon = false) {
            Print("No current owner - proceeding with claim")
            GameManager : game_manager = game_manager{}

            PTC := GameManager.GetPlayerTycoonClass(Agent)
            Print("Got player tycoon class")
            if (PTC.IsAlreadyOwnerOfTycoon = false) {
                Print("Player not already owner - claiming now")
                set PTC.IsAlreadyOwnerOfTycoon = true

                set OwnerOfTycoon = option{Agent}
                ClaimPlotButton.Hide()
                spawn{DropperSubscribeFunction(Agent)}
    
                if (GameManager.TycoonSaves = true, Player := player[Agent]) {
                    BringAllSavedItems(GameManager, Player)
                }

                Print("Plot successfully claimed! OwnerOfTycoon set to Agent")
            } else {
                Print("Player is already owner of another tycoon")
            }
        } else {
            Print("Tycoon already has an owner")
        }
    }
        
    BringAllSavedItems(GameManager : game_manager, Player : player) : void = {
        for (Key -> Item : ButtonStruct) {
            for (SavedItemKeys : GameManager.GetCurrentTycoonArray[Player]) {
                if (Key = SavedItemKeys) {
                    ButtonClicked := Item.ButtonProp
                    ButtonVolume := Item.ButtonVolume
                    Price := Item.ButtonPrice
                    Props := Item.PropsToUnlock
                    Buttons := Item.ButtonsToUnlock
    
                    if (PlayerCash := GameManager.GetCurrentCash[Player], Agent := agent[Player]) {
                        if (Item.Purchased = false) {
                            set Item.Purchased = true
    
                            ButtonClicked.Hide()

                            # Separate the calls to avoid effect system conflicts
                            PTC := GameManager.GetPlayerTycoonClass(Agent)
                            if (Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
                                PTC.MainPlayerUIClass.UpdateAllCurrencies(Player, Cash, Gems, RebirthTokens)
                            }
    
                            CurrentVector3ButtonPos := ButtonClicked.GetTransform().Translation
                            CurrentButtonRotation := ButtonClicked.GetTransform().Rotation
                            NewButtonPos := CurrentVector3ButtonPos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                            spawn{ButtonClicked.MoveTo(NewButtonPos, CurrentButtonRotation, 0.5)}
    
                            for (Prop : Props) {
                                Prop.Show()
                                CurrentVector3Pos := Prop.GetTransform().Translation
                                CurrentRotation := Prop.GetTransform().Rotation
                                NewPos := CurrentVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
                                if (CurrentVector3Pos.X = CrateModel.GetTransform().Translation.X, CurrentVector3Pos.Y = CrateModel.GetTransform().Translation.Y, CurrentVector3Pos.Z = CrateModel.GetTransform().Translation.Z) {
                                    spawn{CratePropMoveTo(NewPos, CurrentRotation, Prop)}
                                } else {
                                    spawn{Prop.MoveTo(NewPos, CurrentRotation, 3.0)}
                                }
                            }
    
                            for (NextButton : Buttons) {
                                NextButton.Show()
                                CurrentNextButtonVector3Pos := NextButton.GetTransform().Translation
                                CurrentNextButtonRotation := NextButton.GetTransform().Rotation
                                NewNextButtonPos := CurrentNextButtonVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
                                spawn{NextButton.MoveTo(NewNextButtonPos, CurrentNextButtonRotation, 3.0)}
                            }
    
                            if (Dropper := Item.DropperOptional.DropperProp?) {
                                Dropper.Show()
                                CurrentVector3Pos := Dropper.GetTransform().Translation
                                CurrentRotation := Dropper.GetTransform().Rotation
                                NewPos := CurrentVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
                                set Item.DropperOptional.Animateable = false
                                spawn{MoveDropperAndWait(NewPos, CurrentRotation, Dropper, Item)}
                            }
                        }
                    }
                }
            }
        }
    }

    #Player Left Functionality
    PlayerLeftFunction(Player : player) : void = {
        if (AgentWhoLeft := agent[Player]) {
            if (not OwnerOfTycoon = false) {
                if (PossibleAgent :=  OwnerOfTycoon?) {
                    if (AgentWhoLeft = PossibleAgent) {
                        set OwnerOfTycoon = false
                        ClaimPlotButton.Show()

                        Tycoon_Reset(Player)
                    }
                }
            }
        }
    }


    Tycoon_Reset(Player : player) : void = {
        for (Key -> Item : ButtonStruct) {

            NameOfButton := Item.ButtonName

            if (Item.Purchased = true) {
                set Item.Purchased = false
                #Make All Props Hidden
                UnlockPropsArray := Item.PropsToUnlock
    
                for (Prop : UnlockPropsArray) {
                    Prop.Hide()
                    CurrentVector3Pos := Prop.GetTransform().Translation
                    CurrentRotation := Prop.GetTransform().Rotation
                    NewPos := CurrentVector3Pos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                    if (Prop.TeleportTo[NewPos, CurrentRotation]) {}
                }
    
                #Make All Buttons Hidden
    
                ButtonsArray := Item.ButtonsToUnlock
    
                for (Button : ButtonsArray) {
                    Button.Hide()                                                                        
                    CurrentVector3Pos := Button.GetTransform().Translation
                    CurrentRotation := Button.GetTransform().Rotation

                    if (CurrentVector3Pos.Z > -100.0) {
                        NewPos := CurrentVector3Pos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                        if (Button.TeleportTo[NewPos, CurrentRotation]) {}
                    }

                }
    
                if (DropperPart := Item.DropperOptional.DropperDropPart?) {
                    DropperPart.Hide()
                    if (DropperPart.TeleportTo[Item.DropperOptional.StartPoint, DropperPart.GetTransform().Rotation]) {}
                }
    
                if (Dropper := Item.DropperOptional.DropperProp?) {
                    Dropper.Hide()
                    CurrentVector3Pos := Dropper.GetTransform().Translation
                    CurrentRotation := Dropper.GetTransform().Rotation
                    NewPos := CurrentVector3Pos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                    if (Dropper.TeleportTo[NewPos, CurrentRotation]) {}                
                }   
            }
        }

        ClaimPlotButton.Show()
        CurrentNextButtonVector3Pos := ClaimPlotButton.GetTransform().Translation
        CurrentNextButtonRotation := ClaimPlotButton.GetTransform().Rotation
        NewNextButtonPos := CurrentNextButtonVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
        spawn{ClaimPlotButton.MoveTo(NewNextButtonPos, CurrentNextButtonRotation, 3.0)}
    }

    # Initialize all interactive systems
    InitializeInteractiveSystems() : void = {
        # Initialize Multiplier Buttons
        for (MultiplierButton : MultiplierButtons) {
            MultiplierButton.MultiplierButtonVolume.AgentEntersEvent.Subscribe(Handler1{Device:=Self, Parameter1:=MultiplierButton.MultiplierButtonName}.HandlerFunction)
            MultiplierButton.MultiplierButtonProp.Hide()
        }

        # Initialize Dance Floors
        for (DanceFloor : DanceFloors) {
            DanceFloor.DanceFloorVolume.AgentEntersEvent.Subscribe(OnDanceFloorEnterWrapper)
            DanceFloor.DanceFloorVolume.AgentExitsEvent.Subscribe(OnDanceFloorExit)
            DanceFloor.DanceFloorProp.Hide()
        }

        # Initialize Jump and Run Courses
        for (JumpAndRun : JumpAndRuns) {
            JumpAndRun.StartButtonVolume.AgentEntersEvent.Subscribe(OnJumpAndRunStart)
            JumpAndRun.EndButtonVolume.AgentEntersEvent.Subscribe(OnJumpAndRunEnd)
            JumpAndRun.StartButtonProp.Hide()
            JumpAndRun.EndButtonProp.Hide()
        }

        # Initialize Lucky Wheels
        for (LuckyWheel : LuckyWheels) {
            LuckyWheel.LuckyWheelVolume.AgentEntersEvent.Subscribe(Handler1{Device:=Self, Parameter1:=LuckyWheel.LuckyWheelName}.HandlerFunction)
            LuckyWheel.LuckyWheelProp.Hide()
        }

        # Initialize Pet Shops
        for (PetShop : PetShops) {
            PetShop.PetShopVolume.AgentEntersEvent.Subscribe(Handler1{Device:=Self, Parameter1:=PetShop.PetShopName}.HandlerFunction)
            PetShop.PetShopProp.Hide()
        }
    }

    # Handle purchases for interactive systems
    HandleInteractiveSystemPurchase(Agent : agent, ButtonName : string, Player : player) : void = {
        GameManager : game_manager = game_manager{}

        # Handle Multiplier Button purchases
        for (MultiplierButton : MultiplierButtons) {
            if (MultiplierButton.MultiplierButtonName = ButtonName, MultiplierButton.MultiplierPurchased = false, PlayerCash := GameManager.GetCurrentCash[Player]) {
                if (PlayerCash >= MultiplierButton.MultiplierButtonPrice) {
                    set MultiplierButton.MultiplierPurchased = true
                    GameManager.RemoveFromCash(Player, MultiplierButton.MultiplierButtonPrice)
                    MultiplierButton.MultiplierButtonProp.Show()
                    Print("Multiplier button purchased!")
                    return
                }
            }
        }

        # Handle Dance Floor purchases
        for (DanceFloor : DanceFloors) {
            if (DanceFloor.DanceFloorName = ButtonName, DanceFloor.DanceFloorPurchased = false, PlayerCash := GameManager.GetCurrentCash[Player]) {
                if (PlayerCash >= DanceFloor.DanceFloorPrice) {
                    set DanceFloor.DanceFloorPurchased = true
                    GameManager.RemoveFromCash(Player, DanceFloor.DanceFloorPrice)
                    DanceFloor.DanceFloorProp.Show()
                    Print("Dance floor purchased!")
                    return
                }
            }
        }

        # Handle Jump and Run purchases
        for (JumpAndRun : JumpAndRuns) {
            if (JumpAndRun.JumpAndRunName = ButtonName, JumpAndRun.JumpAndRunPurchased = false, PlayerCash := GameManager.GetCurrentCash[Player]) {
                if (PlayerCash >= JumpAndRun.JumpAndRunPrice) {
                    set JumpAndRun.JumpAndRunPurchased = true
                    GameManager.RemoveFromCash(Player, JumpAndRun.JumpAndRunPrice)
                    JumpAndRun.StartButtonProp.Show()
                    JumpAndRun.EndButtonProp.Show()
                    Print("Jump and run course purchased!")
                    return
                }
            }
        }

        # Handle Lucky Wheel purchases
        for (LuckyWheel : LuckyWheels) {
            if (LuckyWheel.LuckyWheelName = ButtonName, LuckyWheel.LuckyWheelPurchased = false, PlayerCash := GameManager.GetCurrentCash[Player]) {
                if (PlayerCash >= LuckyWheel.LuckyWheelPrice) {
                    set LuckyWheel.LuckyWheelPurchased = true
                    GameManager.RemoveFromCash(Player, LuckyWheel.LuckyWheelPrice)
                    LuckyWheel.LuckyWheelProp.Show()
                    Print("Lucky wheel purchased!")
                    return
                }
            }
        }

        # Handle Pet Shop purchases
        for (PetShop : PetShops) {
            if (PetShop.PetShopName = ButtonName, PetShop.PetShopPurchased = false, PlayerCash := GameManager.GetCurrentCash[Player]) {
                if (PlayerCash >= PetShop.PetShopPrice) {
                    set PetShop.PetShopPurchased = true
                    GameManager.RemoveFromCash(Player, PetShop.PetShopPrice)
                    PetShop.PetShopProp.Show()
                    Print("Pet shop purchased!")
                    return
                }
            }
        }

        # Handle Multiplier Button activation
        for (MultiplierButton : MultiplierButtons) {
            if (MultiplierButton.MultiplierButtonName = ButtonName, MultiplierButton.MultiplierPurchased = true) {
                GameManager.SetMoneyMultiplier(Player, MultiplierButton.MultiplierValue, MultiplierButton.MultiplierDuration)
                Print("Money multiplier activated: {MultiplierButton.MultiplierValue}x for {MultiplierButton.MultiplierDuration} seconds!")
                return
            }
        }

        # Handle Lucky Wheel spins
        for (LuckyWheel : LuckyWheels) {
            if (LuckyWheel.LuckyWheelName = ButtonName, LuckyWheel.LuckyWheelPurchased = true, PlayerCash := GameManager.GetCurrentCash[Player]) {
                if (PlayerCash >= LuckyWheel.SpinCost) {
                    GameManager.RemoveFromCash(Player, LuckyWheel.SpinCost)
                    SpinLuckyWheel(Agent, Player, LuckyWheel)
                    return
                }
            }
        }

        # Handle Pet purchases
        for (PetShop : PetShops) {
            if (PetShop.PetShopName = ButtonName, PetShop.PetShopPurchased = true) {
                ShowPetShopMenu(Agent, Player)
                return
            }
        }
    }

    # Dance Floor functionality
    OnDanceFloorEnterWrapper(Agent : agent) : void = {
        for (DanceFloor : DanceFloors) {
            if (DanceFloor.DanceFloorPurchased = true) {
                OnDanceFloorEnter(Agent, DanceFloor)
                return
            }
        }
    }

    OnDanceFloorExit(Agent : agent) : void = {
        if (Player := player[Agent]) {
            GameManager : game_manager = game_manager{}
            GameManager.SetDanceFloorActive(Player, false)
            Print("Player left dance floor - dance bonus deactivated")
        }
    }

    OnDanceFloorEnter(Agent : agent, DanceFloor : DanceFloorClass) : void = {
        if (Player := player[Agent], DanceFloor.DanceFloorPurchased = true) {
            GameManager : game_manager = game_manager{}
            GameManager.SetDanceFloorActive(Player, true)
            
            # Trigger Fortnite emote
            if (FortCharacter := Agent.GetFortCharacter[]) {
                DanceFloor.DanceEmoteDevice.Award(Agent)
            }
            Print("Player entered dance floor - dance bonus activated!")
        }
    }

    # Jump and Run functionality
    OnJumpAndRunStart(Agent : agent) : void = {
        for (JumpAndRun : JumpAndRuns) {
            if (JumpAndRun.JumpAndRunPurchased = true) {
                Print("Player started jump and run course!")
            }
        }
    }

    OnJumpAndRunEnd(Agent : agent) : void = {
        if (Player := player[Agent]) {
            for (JumpAndRun : JumpAndRuns) {
                if (JumpAndRun.JumpAndRunPurchased = true) {
                    GiveJumpAndRunReward(Agent, Player)
                    Print("Player completed jump and run course!")
                }
            }
        }
    }

    GiveJumpAndRunReward(Agent : agent, Player : player) : void = {
        GameManager : game_manager = game_manager{}
        RewardType := GetRandomInt(1, 3)

        if (RewardType = 1) {
            # Multiplier reward
            GameManager.SetMoneyMultiplier(Player, 1.5, 30.0)
            Print("Jump and run reward: 1.5x money multiplier for 30 seconds!")
        } else if (RewardType = 2) {
            # Weapon reward (placeholder - would need weapon spawner device)
            Print("Jump and run reward: Weapon! (Feature needs weapon spawner device)")
        } else {
            # Double income for 1 minute
            GameManager.SetMoneyMultiplier(Player, 2.0, 60.0)
            Print("Jump and run reward: 2x money multiplier for 60 seconds!")
        }
    }

    # Lucky Wheel functionality
    SpinLuckyWheel(Agent : agent, Player : player, LuckyWheel : LuckyWheelClass) : void = {
        GameManager : game_manager = game_manager{}
        RewardType := GetRandomInt(1, 3)

        # Animate wheel spin
        spawn{AnimateLuckyWheelSpin(LuckyWheel.LuckyWheelProp)}

        if (RewardType = 1) {
            # Rebirth token reward
            GameManager.AddToRebirthTokens(Player, 1)
            Print("Lucky wheel reward: 1 Rebirth Token!")
        } else if (RewardType = 2) {
            # Double income for 1 minute
            GameManager.SetMoneyMultiplier(Player, 2.0, 60.0)
            Print("Lucky wheel reward: 2x income for 60 seconds!")
        } else {
            # Pet reward (random pet)
            PetIndex := GetRandomInt(0, AvailablePets.Length - 1)
            if (PetToGive := AvailablePets[PetIndex]) {
                GameManager.AddPet(Player, PetToGive.PetName)
                Print("Lucky wheel reward: {PetToGive.PetName} pet!")
            }
        }
    }

    AnimateLuckyWheelSpin(WheelProp : creative_prop) < suspends> : void = {
        # Spin animation
        SpinKeyFrame : keyframe_delta = keyframe_delta {
            DeltaLocation := vector3{}
            DeltaRotation := rotation{} # Simple rotation placeholder  
            Time := 2.0
            Interpolation := EaseOut
        }

        if (AnimController := WheelProp.GetAnimationController[]) {
            KeyFramesArray : []keyframe_delta = array{SpinKeyFrame}
            AnimController.SetAnimation(KeyFramesArray, ?Mode := animation_mode.OneShot)
            AnimController.Play()
            AnimController.MovementCompleteEvent.Await()
        }
    }

    # Pet Shop functionality
    ShowPetShopMenu(Agent : agent, Player : player) : void = {
        GameManager : game_manager = game_manager{}
        OwnedPets := GameManager.GetOwnedPets(Player)
        
        Print("=== PET SHOP ===")
        for (Pet : AvailablePets) {
            var AlreadyOwned : logic = false
            for (OwnedPet : OwnedPets) {
                if (OwnedPet = Pet.PetName) {
                    set AlreadyOwned = true
                }
            }
            
            if (AlreadyOwned = false) {
                Print("{Pet.PetName} - Price: {Pet.PetPrice} - Boost: {Pet.PetBoostPercentage}%")
                # In a real implementation, you'd create UI buttons for each pet
                # For now, players would need separate interaction volumes for each pet
            } else {
                Print("{Pet.PetName} - OWNED")
            }
        }
    }

    PurchasePet(Agent : agent, Player : player, PetName : string) : void = {
        GameManager : game_manager = game_manager{}
        
        for (Pet : AvailablePets) {
            if (Pet.PetName = PetName, PlayerCash := GameManager.GetCurrentCash[Player]) {
                if (PlayerCash >= Pet.PetPrice) {
                    # Check if already owned
                    OwnedPets := GameManager.GetOwnedPets(Player)
                    var AlreadyOwned : logic = false
                    for (OwnedPet : OwnedPets) {
                        if (OwnedPet = Pet.PetName) {
                            set AlreadyOwned = true
                        }
                    }
                    
                    if (AlreadyOwned = false) {
                        GameManager.RemoveFromCash(Player, Pet.PetPrice)
                        GameManager.AddPet(Player, Pet.PetName)
                        GameManager.SetActivePet(Player, Pet.PetName)
                        Print("Purchased and activated pet: {Pet.PetName}!")
                    } else {
                        Print("You already own this pet!")
                    }
                } else {
                    Print("Not enough cash to buy {Pet.PetName}!")
                }
            }
        }
    }