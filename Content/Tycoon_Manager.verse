using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Fortnite.com/Devices/CreativeAnimation/InterpolationTypes }

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

        ClaimPlotButton.Show()
        CurrentNextButtonVector3Pos := ClaimPlotButton.GetTransform().Translation
        CurrentNextButtonRotation := ClaimPlotButton.GetTransform().Rotation
        NewNextButtonPos := CurrentNextButtonVector3Pos + vector3{X := 0.0, Y := 0.0, Z := 500.0}
        spawn{ClaimPlotButton.MoveTo(NewNextButtonPos, CurrentNextButtonRotation, 3.0)}
    }