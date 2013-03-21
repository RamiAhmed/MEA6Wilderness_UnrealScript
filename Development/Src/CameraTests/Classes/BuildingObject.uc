class BuildingObject extends UsableActor placeable;

var BuildingPlayerController UsedBy;

auto state Idle
{
    function ProcessUsedBy(Pawn User)
    {
        UsedBy = BuildingPlayerController(User.Controller);
        if (UsedBy != None)
        {
            GotoState('BuilderMode');
            UsedBy.GotoState('Building');
        }
    }

Begin:
    Debug("Cube entered Idle state");
    SetPhysics(PHYS_Falling);

    UsedBy = None;
}

state BuilderMode
{
    function ProcessUsedBy(Pawn User)
    {
        if (UsedBy != None)
        {
            UsedBy.GotoState('Idle');
            UsedBy = None;
        }
        GotoState('Idle');
    }

Begin:
    Debug("Cube entered BuildingMode state");
    SetPhysics(PHYS_None);
}

function Debug(string message)
{
    WorldInfo.Game.Broadcast(self, "DEBUG: "$message);
}

event Tick(float DeltaTime)
{
    super.Tick(DeltaTime);

    if (self.IsInState('BuilderMode') || self.GetStateName() == 'BuilderMode')
    {
        if (UsedBy != None)
        {
            if (UsedBy.CurrentCube == None)
            {
                UsedBy.CurrentCube = self;
            }
            else if (UsedBy.CurrentCube == self)
            {
                //Debug("Update cube location");
                UpdateCubeLocation();
            }
        }
        else
        {
            Debug("Send Cube to Idle state");
            GotoState('Idle');
        }
    }
}

function UpdateCubeLocation()
{
    local CameraPawn pawn;
    local rotator playerRotation;
    local vector cubePosition;
    local float distance;

    UsedBy.GetPlayerViewPoint(cubePosition, playerRotation);
    pawn = CameraPawn(UsedBy.Pawn);
    distance = 200;

    cubePosition = cubePosition + vector(playerRotation) * distance;
    self.SetLocation(cubePosition);
}

defaultproperties
{

}
