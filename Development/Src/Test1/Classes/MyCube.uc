class MyCube extends MyUsableActor placeable;

var MyPlayerController UsedBy;

var vector cubePosModifier;
var Rotator cubeRotModifier;

function Debug(string message)
{
	WorldInfo.Game.Broadcast(self, "DEBUG: "$message);
}

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if (self.IsInState('BuilderMode') || self.GetStateName() == 'BuilderMode')
	{
		if (UsedBy != None)//((pc.IsInState('Building') || pc.GetStateName() == 'Building'))
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

auto state Idle
{
	function ProcessUsedBy(Pawn User)
	{
		UsedBy = MyPlayerController(User.Controller);
		GotoState('BuilderMode');
	}

Begin:
	Debug("Cube entered Idle state");
	//UsedBy.GotoState('Idle');
	SetPhysics(PHYS_Falling);

	UsedBy = None;
}

state BuilderMode
{
	function ProcessUsedBy(Pawn User)
	{
		//UsedBy = None;
		GotoState('Idle');
	}

Begin:
	Debug("Cube entered BuildingMode state");
	UsedBy.GotoState('Building');
	SetPhysics(PHYS_None);
}

function UpdateCubeLocation()
{
	//local MyPlayerController pc;
	//local rotator playerRotation;
	//local vector newLoc;

	//pc = UsedBy;//MyPlayerController(GetALocalPlayerController());
	//playerRotation = UsedBy.Pawn.Rotation;//UsedBy.PlayerCamera.ViewTarget.POV.Rotation;

	if (!IsZero(cubePosModifier))
	{
		self.SetLocation(UsedBy.Pawn.Location + (cubePosModifier >> self.Rotation));
		//Debug("Moving to "$self.Location >> self.Rotation);

		cubePosModifier = vect(0,0,0);
	}



	/*if (IsZero(cubePosModifier)) {
		cubePosModifier.x = 10;
		newLoc = UsedBy.Pawn.Location + cubePosModifier >> playerRotation;//Vector(playerRotation) * 150.0;
		self.SetLocation(newLoc);
	}
	else {
		cubePosModifier = //TransformVectorByRotation(playerRotation, cubePosModifier);
		self.MoveSmooth(cubePosModifier);
	}*/

	self.SetRotation(self.Rotation + cubeRotModifier);
}

defaultproperties
{
	bStatic=false
//	bAimToInteract=false
}
