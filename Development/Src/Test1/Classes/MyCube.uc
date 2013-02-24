class MyCube extends MyUsableActor placeable;

var vector cubePosModifier;
var Rotator cubeRotModifier;

function Debug(string message)
{
	WorldInfo.Game.Broadcast(self, "DEBUG: "$message);
}

event Tick(float DeltaTime)
{
	local PlayerController pc;
	pc = GetALocalPlayerController();

	if ((pc.IsInState('Building') || pc.GetStateName() == 'Building') ||
		(IsInState('BuilderMode') || GetStateName() == 'BuilderMode'))
	{
		if (MyPlayerController(pc).CurrentCube == None) 
		{
			MyPlayerController(pc).CurrentCube = self;
		}
		UpdateCubeLocation();
	}
	else 
	{
		Debug("Send Cube to Idle state");
		GotoState('Idle');
	}
}

auto state Idle
{
	ignores Tick;

	function ProcessUsedBy(Pawn User)
	{
		GotoState('BuilderMode');
	}

Begin:
	Debug("Cube entered Idle state");
	SetPhysics(PHYS_Falling);
	cubePosModifier = vect(0,0,0);
	cubeRotModifier = rotator(vect(0,0,0));
}

state() BuilderMode
{
	function ProcessUsedBy(Pawn User)
	{
		GotoState('Idle');
	}

Begin:
	Debug("Cube entered BuildingMode state");
	GetALocalPlayerController().GotoState('Building');
	SetPhysics(PHYS_None);
	initCubeLocation();
}

function initCubeLocation()
{
	local PlayerController player;
	local Pawn pawn;
	local rotator playerRotation;

	local float distance;	
	local vector newLoc;

	distance = 150.0;

	player = GetALocalPlayerController();
	playerRotation = player.PlayerCamera.ViewTarget.POV.Rotation;
	pawn = player.Pawn;

	//newLoc = pawn.Location + (normal(Vector(pawn.Rotation)) * distance);
	newLoc = pawn.Location + (normal(Vector(playerRotation)) * distance);

	self.setLocation(newLoc);
}

function UpdateCubeLocation()
{/*
	local PlayerController player;
	//local Pawn pawn;
	local rotator playerRotation;
	local vector newLoc;
	//local float distance;

	//distance = 150.0;

	player = GetALocalPlayerController();
	//pawn = player.Pawn;

	//newLoc = pawn.Location + (normal(Vector(pawn.Rotation)) * distance);
	//newLoc = (normal(Vector(pawn.Rotation)) * distance);

	playerRotation = player.PlayerCamera.ViewTarget.POV.Rotation;
	newLoc = self.Location + TransformVectorByRotation(playerRotation, cubePosModifier);

	//self.SetLocation(newLoc);
	//self.Move(newLoc);
	self.MoveSmooth(newLoc);*/
	//self.MoveSmooth(self.Location + (vect(newLoc.x, newLoc.y, newLoc.z) >> Rotation) );

	local PlayerController player;
	local rotator playerRotation;

	player = GetALocalPlayerController();
	playerRotation = player.PlayerCamera.ViewTarget.POV.Rotation;

	cubePosModifier = TransformVectorByRotation(playerRotation, cubePosModifier);

	self.MoveSmooth(cubePosModifier);

	self.SetRotation(self.Rotation + cubeRotModifier);
}

defaultproperties
{
	Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironmentComp
	    bEnabled = true
	End Object    
	Components.add(LightEnvironmentComp)

	//cubePosModifier=vect(0,0,0)
	//cubeRotModifier=vect(0,0,0)

	bStatic=false
}