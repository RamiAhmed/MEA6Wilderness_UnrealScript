class MyCube extends MyUsableActor placeable;

var vector cubePosModifier;
var Rotator cubeRotModifier;

function Debug(string message)
{
	WorldInfo.Game.Broadcast(self, "DEBUG: "$message);
}

event Tick(float DeltaTime)
{
	local MyPlayerController pc;
	pc = MyPlayerController(GetALocalPlayerController());

	if (!(self.IsInState('BuilderMode') || self.GetStateName() == 'BuilderMode'))
	{
		super.Tick(DeltaTime);
	}
	else 
	{
//		pc = GetALocalPlayerController();

		if ((pc.IsInState('Building') || pc.GetStateName() == 'Building') ||
			(IsInState('BuilderMode') || GetStateName() == 'BuilderMode'))
		{
			if (pc.CurrentCube == None) 
			{
				pc.CurrentCube = self;
			}
			
			UpdateCubeLocation();
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
		GotoState('BuilderMode');
	}

Begin:
	Debug("Cube entered Idle state");
	GetALocalPlayerController().GotoState('Idle');
	SetPhysics(PHYS_Falling);
	cubePosModifier = vect(0,0,0);
	cubeRotModifier = rotator(vect(0,0,0));
}

state BuilderMode
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

	distance = 100.0;

	player = GetALocalPlayerController();
	playerRotation = player.PlayerCamera.ViewTarget.POV.Rotation;
	pawn = player.Pawn;

	newLoc = pawn.Location + (normal(Vector(playerRotation)) * distance);

	self.setLocation(newLoc);
}

function UpdateCubeLocation()
{
	local MyPlayerController pc;
	local rotator playerRotation;
	local vector newLoc;

	pc = MyPlayerController(GetALocalPlayerController());
	playerRotation = pc.PlayerCamera.ViewTarget.POV.Rotation;

	if (IsZero(cubePosModifier)) {
		newLoc = pc.Pawn.Location + Vector(playerRotation) * 100.0;
		self.SetLocation(newLoc);
	}
	else {
		cubePosModifier = TransformVectorByRotation(playerRotation, cubePosModifier);
		self.MoveSmooth(cubePosModifier);
	}

	self.SetRotation(self.Rotation + cubeRotModifier);
}

defaultproperties
{
	Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironmentComp
	    bEnabled=true
	End Object    
	Components.add(LightEnvironmentComp)

	bStatic=false
}