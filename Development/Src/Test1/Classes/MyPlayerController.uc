class MyPlayerController extends SimplePC;

var MyCube CurrentCube;
var float cubeSpeedFactor;

enum EBuilderInterfaceType
{
	BUILD_0,
	BUILD_1,
	BUILD_2,
	BUILD_3
};

var EBuilderInterfaceType CurrentInterface;

function Debug(string message)
{
	WorldInfo.Game.Broadcast(self, "DEBUG: "$message);
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	cubeSpeedFactor = 50.0;
	CurrentInterface = BUILD_0;
}

state Idle extends PlayerWalking
{
Begin:
	Debug("PC entered Idle state");
	//Pawn.ZeroMovementVariables();
	Pawn.MovementSpeedModifier += 0.5;
}

state Building
{
	exec function Use()
	{
		CurrentCube.GotoState('Idle');
		GotoState('Idle');
		CurrentCube = None;
	}

Begin:
	Debug("PC entered Building state");
	//Pawn.ZeroMovementVariables();
	Pawn.MovementSpeedModifier -= 0.5;
}

function GetTriggerUseList(float interactDistanceToCheck, float crosshairDist, float minDot, bool bUsuableOnly, out array<Trigger> out_useList)
{
	local int Idx;
	local vector CameraLoc;
	local rotator CameraRot;
	local Trigger checkTrigger;
	local SeqEvent_Used UseSeq;

	if (Pawn != None) {
		// Grab camera location/rotation for checking crosshairDist
		GetPlayerViewPoint(cameraLoc, cameraRot);

		// Search of nearby actors that have use events
		foreach Pawn.CollidingActors(class'Trigger', checkTrigger, interactDistanceToCheck)
		{
			for (Idx = 0; Idx < checkTrigger.GeneratedEvents.Length; Idx++)
			{
				UseSeq = SeqEvent_Used(checkTrigger.GeneratedEvents[Idx]);

				if( ( UseSeq != None )
					// if bUsuableOnly is true then we must get true back from CheckActivate (which tests various validity checks on the player and on the trigger's trigger count and retrigger conditions etc)
					&& ( !bUsuableOnly || ( checkTrigger.GeneratedEvents[Idx].CheckActivate(checkTrigger,Pawn,true)) )
					// check to see if we are looking at the object
					&& ( Normal(checkTrigger.Location-cameraLoc) dot vector(cameraRot) >= minDot )

					// if this is an aimToInteract then check to see if we are aiming at the object and we are inside the InteractDistance (NOTE: we need to do use a number close to 1.0 as the dot will give a number that is very close to 1.0 for aiming at the target)
					&& ( ( ( UseSeq.bAimToInteract && IsAimingAt( checkTrigger, 0.98f ) && ( VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance ) ) )
					      // if we should NOT aim to interact then we need to be close to the trigger
			  || ( !UseSeq.bAimToInteract && ( VSize(Pawn.Location - checkTrigger.Location) <= UseSeq.InteractDistance ) )  // this should be UseSeq.InteractDistance
						  )
				   )
				{
					out_useList[out_useList.Length] = checkTrigger;

					// don't bother searching for more events
					Idx = checkTrigger.GeneratedEvents.Length;
				}
			}

			//If it's a usable actor and it hasn't already been added to the list, let's add it. 
            if (MyUsableActor(checkTrigger) != None && (out_useList.Length == 0 || out_useList[out_useList.Length-1] != checkTrigger))
            {
                out_useList[out_useList.Length] = checkTrigger;
            }
		}
	}	
}

defaultproperties
{
	InputClass=class'MyPlayerInput'

	Name="Default__MyPlayerController"
}