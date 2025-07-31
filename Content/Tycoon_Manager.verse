using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Fortnite.com/Devices/CreativeAnimation/InterpolationTypes }
<<<<<<< HEAD
=======
using { /Fortnite.com/Characters }
using { /Verse.org/Random }
using { /Fortnite.com/AI }
using { /Fortnite.com/Game }
>>>>>>> 1166221 (Petshop prototyp)

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

    @editable DropperDropPart : creative_prop = creative_prop{}

    @editable StartPoint : vector3 = vector3{X := 0.0, Y := 0.0, Z := 0.0}

    @editable EndPoint : vector3 = vector3{X := 0.0, Y := 0.0, Z := 0.0}

    var Animateable : logic = true

    @editable DropperCashIncrease : int = 1

    @editable DropperGemsIncrease : int = 0

    @editable DropperCloneTime : float = 1.0

    @editable DropperSameAsProp : logic = false
}

<<<<<<< HEAD
=======
MultiplierButtonClass := class < concrete>{
    @editable MultiplierButtonName : string = "MultiplierButton"
    @editable MultiplierButtonProp : creative_prop = creative_prop{}
    @editable MultiplierButtonVolume : volume_device = volume_device{}
    @editable MultiplierButtonPrice : int = 1000
    @editable MultiplierValue : float = 2.0
    var MultiplierPurchased : logic = false
    var MultiplierActivated : logic = false
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
    @editable PetSpawner : wildlife_spawner_device = wildlife_spawner_device{}
    @editable PetFollowDistance : float = 3.0
    @editable PetWildlifeType : string = "Chicken"  # Options: Chicken, Wolf, Boar, Frog, Raptor
}

>>>>>>> 1166221 (Petshop prototyp)
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

<<<<<<< HEAD
=======
    # New Interactive Systems
    @editable MultiplierButtons : []MultiplierButtonClass = array{}
    @editable DanceFloors : []DanceFloorClass = array{}
    @editable JumpAndRuns : []JumpAndRunClass = array{}
    @editable LuckyWheels : []LuckyWheelClass = array{}
    @editable PetShops : []PetShopClass = array{}
    @editable AvailablePets : []PetClass = array{
        PetClass{PetName := "SpeedDog", PetPrice := 1000, PetBoostPercentage := 5.0, PetWildlifeType := "Wolf", PetFollowDistance := 2.5},
        PetClass{PetName := "LuckyBird", PetPrice := 2500, PetBoostPercentage := 10.0, PetWildlifeType := "Chicken", PetFollowDistance := 2.0},
        PetClass{PetName := "GoldCat", PetPrice := 5000, PetBoostPercentage := 15.0, PetWildlifeType := "Boar", PetFollowDistance := 3.0},
        PetClass{PetName := "DiamondDragon", PetPrice := 15000, PetBoostPercentage := 25.0, PetWildlifeType := "Raptor", PetFollowDistance := 4.0}
    }
    
    # Map to track active pets for each player  
    var ActivePets : [player]agent = map{}
    # Track the player who is currently requesting a pet spawn
    var PendingSpawnPlayer : ?player = false

>>>>>>> 1166221 (Petshop prototyp)
    OnBegin< override>()< suspends>:void=

        #Check When Player Is Leaving
        GetPlayspace().PlayerRemovedEvent().Subscribe(PlayerLeftFunction)

        #Check Event For Prop Manipulator
        CratePropMani.DamagedEvent.Subscribe(PropManiDamagedFunction)

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

            DropperPart := Item.DropperOptional.DropperDropPart
            DropperPart.Hide()

            if (Dropper := Item.DropperOptional.DropperProp?) {
                Dropper.Hide()
                CurrentVector3Pos := Dropper.GetTransform().Translation
                CurrentRotation := Dropper.GetTransform().Rotation
                NewPos := CurrentVector3Pos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                if (Dropper.TeleportTo[NewPos, CurrentRotation]) {}                
            }
        }

    
    PlayerTriesToBuyButton(Agent : agent, NameOfButton : string) : void = {
        if (Player := player[Agent]) {
            Print("Player?")
            if (NameOfButton = "Claim", OwnerOfTycoon = false) {
                ClaimPlotFunction(Agent)
            }

            if (OwnerAgent := OwnerOfTycoon?) {
                if (OwnerAgent = Agent) {
                    for (Item : ButtonStruct) {
                        if (Item.ButtonName = NameOfButton) {
                            if (Item.Purchased = false) {
                                PlayerBuysButton(Agent, NameOfButton, Player)
                            }
                        }
                    }
                }
            }
        }
    }


    PlayerBuysButton(Agent : agent, NameOfButton : string, Player : player) : void = {
        GameManager : game_manager = game_manager{}

        for (Key -> Item : ButtonStruct) {
            if (Item.ButtonName = NameOfButton) {
                ButtonClicked := Item.ButtonProp
                ButtonVolume := Item.ButtonVolume
                Price := Item.ButtonPrice
                Props := Item.PropsToUnlock
                Buttons := Item.ButtonsToUnlock

                if (PlayerCash := GameManager.GetCurrentCash[Player]) {
                    Print("We good with data")
                    if (PlayerCash >= Price, Item.Purchased = false) {
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

                        if (PTC := GameManager.GetPlayerTycoonClass[Agent], Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
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
        loop:
            Sleep(0.0)
            if (not OwnerOfTycoon = false) {
                for (Item : ButtonStruct) {
                    if (Item.Purchased = true and Item.DropperOptional.Animateable = true) {
                        if (Dropper := Item.DropperOptional.DropperProp?, Player := player[Agent]) {
                            DropperPart := Item.DropperOptional.DropperDropPart

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
                        }
                    }
                }
            } else {
                break
            }
    }

    SpawnAndGrantMoney(Agent : agent, KeyFrame1 : keyframe_delta, KeyFrame2 : keyframe_delta, DropperProp : creative_prop, StartPoint : vector3, Item : AllButtons, Player : player) < suspends> : void = {
        if (AnimController := DropperProp.GetAnimationController[], Item.DropperOptional.Animateable = true) {
            KeyFramesArray : []keyframe_delta = array{KeyFrame1, KeyFrame2}

            Print("{DropperProp.GetTransform().Translation}")
            
            AnimController.SetAnimation(KeyFramesArray, ?Mode := animation_mode.OneShot)

            AnimController.Play()

            set Item.DropperOptional.Animateable = false

            AnimController.MovementCompleteEvent.Await()
            
            Print("{DropperProp.GetTransform().Translation}")

            GameManager : game_manager = game_manager{}

            GameManager.AddToCash(Player, Item.DropperOptional.DropperCashIncrease)

            if (Item.DropperOptional.DropperGemsIncrease > 0) {
                GameManager.AddToGems(Player, Item.DropperOptional.DropperGemsIncrease)
            }
    
            if (PlayerCash := GameManager.GetCurrentCash[Player]) {Print("{PlayerCash}")}

            if (PTC := GameManager.GetPlayerTycoonClass[Agent], Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
                PTC.MainPlayerUIClass.UpdateAllCurrencies(Player, Cash, Gems, RebirthTokens)
            }

            Sleep(Item.DropperOptional.DropperCloneTime + (Item.DropperOptional.DropperCloneTime + 2.0))

            set Item.DropperOptional.Animateable = true

            if (DropperProp.TeleportTo[StartPoint, rotation{}]) {}
        }
    }
    
    PropManiDamagedFunction(Agent : agent) : void = {
        if (OwnerAgent := OwnerOfTycoon?) {
            Print("Agent Good")
            if (Agent = OwnerAgent, Player := player[Agent]) {
                spawn{AnimateCrate()}

                GameManager : game_manager = game_manager{}
    
                GameManager.AddToCash(Player, CrateAddMoneyAmount)

                if (CrateAddGemsAmount > 0) {
                    GameManager.AddToGems(Player, CrateAddGemsAmount)
                }

                if (CrateAddRebirthTokensAmount > 0) {
                    GameManager.AddToRebirthTokens(Player, CrateAddRebirthTokensAmount)
                }
    
                if (PlayerCash := GameManager.GetCurrentCash[Player]) {Print("{PlayerCash}")}

                if (PTC := GameManager.GetPlayerTycoonClass[Agent], Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
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
        if (OwnerOfTycoon = false) {
            GameManager : game_manager = game_manager{}

            if (PTC := GameManager.GetPlayerTycoonClass[Agent]) {
                if (PTC.IsAlreadyOwnerOfTycoon = false) {
                    set PTC.IsAlreadyOwnerOfTycoon = true

                    set OwnerOfTycoon = option{Agent}
                    ClaimPlotButton.Hide()
                    spawn{DropperSubscribeFunction(Agent)}
        
                    if (GameManager.TycoonSaves = true, Player := player[Agent]) {
                        BringAllSavedItems(GameManager, Player)
                    }
                }
<<<<<<< HEAD
=======
                
                # Spawn pet if player has an active pet
                if (Player := player[Agent]) {
                    SpawnActivePetForPlayer(Player)
                }

                Print("Plot successfully claimed! OwnerOfTycoon set to Agent")
            } else {
                Print("Player is already owner of another tycoon")
>>>>>>> 1166221 (Petshop prototyp)
            }
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

                            if (PTC := GameManager.GetPlayerTycoonClass[Agent], Cash := GameManager.GetCurrentCash[Player], Gems := GameManager.GetCurrentGems[Player], RebirthTokens := GameManager.GetCurrentRebirthTokens[Player]) {
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
        # Clean up player's pet first
        DespawnPetForPlayer(Player)
        
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
    
                DropperPart := Item.DropperOptional.DropperDropPart
                DropperPart.Hide()
                if (DropperPart.TeleportTo[Item.DropperOptional.StartPoint, DropperPart.GetTransform().Rotation]) {}
    
                if (Dropper := Item.DropperOptional.DropperProp?) {
                    Dropper.Hide()
                    CurrentVector3Pos := Dropper.GetTransform().Translation
                    CurrentRotation := Dropper.GetTransform().Rotation
                    NewPos := CurrentVector3Pos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                    if (Dropper.TeleportTo[NewPos, CurrentRotation]) {}                
                }   
            }
        }

<<<<<<< HEAD
        ClaimPlotButton.Show()
        CurrentNextButtonVector3Pos := ClaimPlotButton.GetTransform().Translation
        CurrentNextButtonRotation := ClaimPlotButton.GetTransform().Rotation
        NewNextButtonPos := CurrentNextButtonVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
        spawn{ClaimPlotButton.MoveTo(NewNextButtonPos, CurrentNextButtonRotation, 3.0)}
=======
        # Move entire ClaimPlotButton hierarchy back up (includes all children like volume)
        CurrentButtonPos := ClaimPlotButton.GetTransform().Translation
        CurrentButtonRotation := ClaimPlotButton.GetTransform().Rotation
        NewButtonPos := CurrentButtonPos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
        spawn{ClaimPlotButton.MoveTo(NewButtonPos, CurrentButtonRotation, 3.0)}
    }

    # Initialize all interactive systems
    InitializeInteractiveSystems() : void = {
        # Initialize Multiplier Buttons
        for (MultiplierButton : MultiplierButtons) {
            MultiplierButton.MultiplierButtonVolume.AgentEntersEvent.Subscribe(Handler1{Device:=Self, Parameter1:=MultiplierButton.MultiplierButtonName}.HandlerFunction)
            # MultiplierButton props start visible as purchase buttons
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
        
        # Initialize Pet Spawner Events  
        for (Pet : AvailablePets) {
            Pet.PetSpawner.SpawnedEvent.Subscribe(OnPetSpawned)
        }
    }

    # Handle purchases for interactive systems
    HandleInteractiveSystemPurchase(Agent : agent, ButtonName : string, Player : player) : void = {

        # Handle Multiplier Button purchases
        for (MultiplierButton : MultiplierButtons) {
            if (MultiplierButton.MultiplierButtonName = ButtonName, MultiplierButton.MultiplierPurchased = false, PlayerCash := GameManagerDevice.GetCurrentCash[Player]) {
                if (PlayerCash >= MultiplierButton.MultiplierButtonPrice) {
                    set MultiplierButton.MultiplierPurchased = true
                    set MultiplierButton.MultiplierActivated = true
                    GameManagerDevice.RemoveFromCash(Player, MultiplierButton.MultiplierButtonPrice)
                    GameManagerDevice.SetPermanentMultiplier(Player, MultiplierButton.MultiplierValue)
                    
                    # Move entire MultiplierButton hierarchy underground (includes all children like volume)
                    CurrentButtonPos := MultiplierButton.MultiplierButtonProp.GetTransform().Translation
                    CurrentButtonRotation := MultiplierButton.MultiplierButtonProp.GetTransform().Rotation
                    NewButtonPos := CurrentButtonPos - vector3{X := 0.0, Y := 0.0, Z := 500.0}
                    spawn{MultiplierButton.MultiplierButtonProp.MoveTo(NewButtonPos, CurrentButtonRotation, 0.5)}
                    
                    Print("Multiplier button purchased and permanent multiplier activated: {MultiplierButton.MultiplierValue}x!")
                    return
                }
            }
        }

        # Handle Dance Floor purchases
        for (DanceFloor : DanceFloors) {
            if (DanceFloor.DanceFloorName = ButtonName, DanceFloor.DanceFloorPurchased = false, PlayerCash := GameManagerDevice.GetCurrentCash[Player]) {
                if (PlayerCash >= DanceFloor.DanceFloorPrice) {
                    set DanceFloor.DanceFloorPurchased = true
                    GameManagerDevice.RemoveFromCash(Player, DanceFloor.DanceFloorPrice)
                    DanceFloor.DanceFloorProp.Show()
                    Print("Dance floor purchased!")
                    return
                }
            }
        }

        # Handle Jump and Run purchases
        for (JumpAndRun : JumpAndRuns) {
            if (JumpAndRun.JumpAndRunName = ButtonName, JumpAndRun.JumpAndRunPurchased = false, PlayerCash := GameManagerDevice.GetCurrentCash[Player]) {
                if (PlayerCash >= JumpAndRun.JumpAndRunPrice) {
                    set JumpAndRun.JumpAndRunPurchased = true
                    GameManagerDevice.RemoveFromCash(Player, JumpAndRun.JumpAndRunPrice)
                    JumpAndRun.StartButtonProp.Show()
                    JumpAndRun.EndButtonProp.Show()
                    Print("Jump and run course purchased!")
                    return
                }
            }
        }

        # Handle Lucky Wheel purchases
        for (LuckyWheel : LuckyWheels) {
            if (LuckyWheel.LuckyWheelName = ButtonName, LuckyWheel.LuckyWheelPurchased = false, PlayerCash := GameManagerDevice.GetCurrentCash[Player]) {
                if (PlayerCash >= LuckyWheel.LuckyWheelPrice) {
                    set LuckyWheel.LuckyWheelPurchased = true
                    GameManagerDevice.RemoveFromCash(Player, LuckyWheel.LuckyWheelPrice)
                    LuckyWheel.LuckyWheelProp.Show()
                    Print("Lucky wheel purchased!")
                    return
                }
            }
        }

        # Handle Pet Shop purchases
        for (PetShop : PetShops) {
            if (PetShop.PetShopName = ButtonName, PetShop.PetShopPurchased = false, PlayerCash := GameManagerDevice.GetCurrentCash[Player]) {
                if (PlayerCash >= PetShop.PetShopPrice) {
                    set PetShop.PetShopPurchased = true
                    GameManagerDevice.RemoveFromCash(Player, PetShop.PetShopPrice)
                    PetShop.PetShopProp.Show()
                    Print("Pet shop purchased!")
                    return
                }
            }
        }


        # Handle Lucky Wheel spins
        for (LuckyWheel : LuckyWheels) {
            if (LuckyWheel.LuckyWheelName = ButtonName, LuckyWheel.LuckyWheelPurchased = true, PlayerCash := GameManagerDevice.GetCurrentCash[Player]) {
                if (PlayerCash >= LuckyWheel.SpinCost) {
                    GameManagerDevice.RemoveFromCash(Player, LuckyWheel.SpinCost)
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
                GameManagerDevice.SetDanceFloorActive(Player, false)
            Print("Player left dance floor - dance bonus deactivated")
        }
    }

    OnDanceFloorEnter(Agent : agent, DanceFloor : DanceFloorClass) : void = {
        if (Player := player[Agent], DanceFloor.DanceFloorPurchased = true) {
                GameManagerDevice.SetDanceFloorActive(Player, true)
            
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
        RewardType := GetRandomInt(1, 3)

        if (RewardType = 1) {
            # Multiplier reward
            GameManagerDevice.SetMoneyMultiplier(Player, 1.5, 30.0)
            Print("Jump and run reward: 1.5x money multiplier for 30 seconds!")
        } else if (RewardType = 2) {
            # Weapon reward (placeholder - would need weapon spawner device)
            Print("Jump and run reward: Weapon! (Feature needs weapon spawner device)")
        } else {
            # Double income for 1 minute
            GameManagerDevice.SetMoneyMultiplier(Player, 2.0, 60.0)
            Print("Jump and run reward: 2x money multiplier for 60 seconds!")
        }
    }

    # Lucky Wheel functionality
    SpinLuckyWheel(Agent : agent, Player : player, LuckyWheel : LuckyWheelClass) : void = {
        RewardType := GetRandomInt(1, 3)

        # Animate wheel spin
        spawn{AnimateLuckyWheelSpin(LuckyWheel.LuckyWheelProp)}

        if (RewardType = 1) {
            # Rebirth token reward
            GameManagerDevice.AddToRebirthTokens(Player, 1)
            Print("Lucky wheel reward: 1 Rebirth Token!")
        } else if (RewardType = 2) {
            # Double income for 1 minute
            GameManagerDevice.SetMoneyMultiplier(Player, 2.0, 60.0)
            Print("Lucky wheel reward: 2x income for 60 seconds!")
        } else {
            # Pet reward (random pet)
            PetIndex := GetRandomInt(0, AvailablePets.Length - 1)
            if (PetToGive := AvailablePets[PetIndex]) {
                GameManagerDevice.AddPet(Player, PetToGive.PetName)
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
        # Get the player's tycoon class to access the PetShop UI
        PTC := GameManagerDevice.GetPlayerTycoonClass(Agent)
        PTC.PetShopUIClass.ShowPetShop(Player, Self)
        Print("Pet Shop UI opened for player")
    }

    PurchasePet(Agent : agent, Player : player, PetName : string) : void = {
        
        for (Pet : AvailablePets) {
            if (Pet.PetName = PetName, PlayerCash := GameManagerDevice.GetCurrentCash[Player]) {
                if (PlayerCash >= Pet.PetPrice) {
                    # Check if already owned
                    OwnedPets := GameManagerDevice.GetOwnedPets(Player)
                    var AlreadyOwned : logic = false
                    for (OwnedPet : OwnedPets) {
                        if (OwnedPet = Pet.PetName) {
                            set AlreadyOwned = true
                        }
                    }
                    
                    if (AlreadyOwned = false) {
                        GameManagerDevice.RemoveFromCash(Player, Pet.PetPrice)
                        GameManagerDevice.AddPet(Player, Pet.PetName)
                        GameManagerDevice.SetActivePet(Player, Pet.PetName)
                        SpawnPetForPlayer(Player, Pet)
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

    # Pet Spawning and Following System
    SpawnPetForPlayer(Player : player, Pet : PetClass) : void = {
        # Despawn any existing pet first
        DespawnPetForPlayer(Player)
        
        if (Agent := agent[Player], PlayerCharacter := Agent.GetFortCharacter[]) {
            # Get player's current position and spawn pet nearby
            PlayerTransform := PlayerCharacter.GetTransform()
            SpawnLocation := PlayerTransform.Translation + vector3{X := 2.0, Y := 2.0, Z := 0.0}
            
            # Set the pending spawn player
            set PendingSpawnPlayer = option{Player}
            
            # Spawn the wildlife creature using the associated spawner
            Pet.PetSpawner.Spawn()
            Print("Requested spawn of {Pet.PetName} for player")
        }
    }

    DespawnPetForPlayer(Player : player) : void = {
        if (ActivePets[Player]) {
            if (ExistingPet := ActivePets[Player]) {
            # Remove the pet creature by dealing lethal damage
            if (PetCharacter := ExistingPet.GetFortCharacter[]) {
                # Deal massive damage to eliminate the pet instantly
                PetCharacter.Damage(9999.0)
                Print("Despawned existing pet for player")
            }
            
                # Remove from active pets map - reconstruct map without this entry
                var NewActivePets : [player]agent = map{}
                for (OtherPlayer -> PetAgent : ActivePets) {
                    if (OtherPlayer <> Player) {
                        if (set NewActivePets[OtherPlayer] = PetAgent) {}
                    }
                }
                set ActivePets = NewActivePets
            }
        }
    }

    # Pet following behavior system - runs continuously for each active pet
    PetFollowBehavior(Owner : player, PetAgent : agent, FollowDistance : float) < suspends> : void = {
        if (OwnerAgent := agent[Owner], PetNavigatable := navigatable[PetAgent]) {
            loop:
                # Check if pet should still be following (player still has this pet active)
                if (ActivePets[Owner]) {
                    if (CurrentPet := ActivePets[Owner]) {
                        if (CurrentPet <> PetAgent) {
                            break
                        }
                    }
                } else {
                    # Player no longer has an active pet
                    break
                }
                
                if (OwnerCharacter := OwnerAgent.GetFortCharacter[]) {
                    OwnerTransform := OwnerCharacter.GetTransform()
                    
                    if (PetCharacter := PetAgent.GetFortCharacter[]) {
                        PetTransform := PetCharacter.GetTransform()
                        PetCurrentPos := PetTransform.Translation
                        OwnerPos := OwnerTransform.Translation
                        
                        # Calculate distance between pet and owner
                        DistanceToOwner := Distance(PetCurrentPos, OwnerPos)
                        
                        # If pet is too far away, make it follow
                        if (DistanceToOwner > FollowDistance) {
                            # Create a target position slightly behind the owner
                            TargetLocation := OwnerPos + vector3{X := -1.0, Y := 0.0, Z := 0.0}
                            NavTarget := MakeNavigationTarget(TargetLocation)
                            PetNavigatable.NavigateTo(NavTarget)
                        } else if (DistanceToOwner < (FollowDistance * 0.5)) {
                            # If pet is too close, make it stop to avoid crowding
                            PetNavigatable.StopNavigation()
                        }
                    }
                }
                
                # Update every 0.5 seconds to avoid performance issues
                Sleep(0.5)
        }
    }

    # Function to handle switching active pets
    SwitchActivePet(Player : player, NewPetName : string) : void = {
        # Find the new pet configuration
        for (Pet : AvailablePets) {
            if (Pet.PetName = NewPetName) {
                # Check if player owns this pet
                OwnedPets := GameManagerDevice.GetOwnedPets(Player)
                var HasPet : logic = false
                for (OwnedPet : OwnedPets) {
                    if (OwnedPet = NewPetName) {
                        set HasPet = true
                    }
                }
                
                if (HasPet = true) {
                    GameManagerDevice.SetActivePet(Player, NewPetName)
                    SpawnPetForPlayer(Player, Pet)
                    Print("Switched active pet to: {NewPetName}")
                } else {
                    Print("You do not own this pet!")
                }
                return
            }
        }
    }

    # Helper function to spawn the currently active pet for a player
    SpawnActivePetForPlayer(Player : player) : void = {
        ActivePetName := GameManagerDevice.GetActivePet(Player)
        if (ActivePetName <> "") {
            # Find the pet configuration
            for (Pet : AvailablePets) {
                if (Pet.PetName = ActivePetName) {
                    SpawnPetForPlayer(Player, Pet)
                    Print("Spawned active pet {ActivePetName} for returning player")
                    return
                }
            }
        }
    }

    # Event handler for when pets are spawned
    OnPetSpawned(SpawnedAgent : agent) : void = {
        # Check if we have a pending spawn request
        if (Player := PendingSpawnPlayer?) {
            # Assign the spawned agent to the requesting player
            if (set ActivePets[Player] = SpawnedAgent) {}
            
            # Clear the pending spawn
            set PendingSpawnPlayer = false
            
            # Find the pet config to get follow distance
            ActivePetName := GameManagerDevice.GetActivePet(Player)
            for (Pet : AvailablePets) {
                if (Pet.PetName = ActivePetName) {
                    # Start the pet following behavior
                    spawn{PetFollowBehavior(Player, SpawnedAgent, Pet.PetFollowDistance)}
                    Print("Pet {Pet.PetName} successfully spawned for player")
                    return
                }
            }
        }
>>>>>>> 1166221 (Petshop prototyp)
    }