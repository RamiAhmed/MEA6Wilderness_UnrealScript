class MyPlayerInput extends PlayerInput;

function Debug(string message)
{
	local MyCube cube;
	cube = MyPlayerController(Outer).CurrentCube;

	cube.Debug(message);
}

// INTERFACE 2
// MouseXY = cube XYZ
// arrowkeys = Cube Pitch/Roll
event PlayerInput(float DeltaTime)
{
	local Rotator cubeRotation;
//	local vector cubePosition;
	local float speedFactor;

	local MyCube cube;	
	if (MyPlayerController(Outer).IsInState('Building') || MyPlayerController(Outer).GetStateName() == 'Building')
	{
		cube = MyPlayerController(Outer).CurrentCube;
		if (cube != None)
		{
			speedFactor = MyPlayerController(Outer).cubeSpeedFactor * DeltaTime;

			if (PressedKeys.Find('Add') >= 0)
			{
				MyPlayerController(Outer).cubeSpeedFactor += 0.5;
				Debug("cubeSpeedFactor: "$MyPlayerController(Outer).cubeSpeedFactor);
			}
			if (PressedKeys.Find('Subtract') >= 0)
			{
				MyPlayerController(Outer).cubeSpeedFactor -= 0.5;
				Debug("cubeSpeedFactor: "$MyPlayerController(Outer).cubeSpeedFactor);
			}	

			if (PressedKeys.Find('Up') >= 0)
			{
				Debug("Up");
				cubeRotation.Pitch -= speedFactor * DegToUnrRot;
			}
			if (PressedKeys.Find('Down') >= 0)
			{
				Debug("Down");
				cubeRotation.Pitch += speedFactor * DegToUnrRot;
			}
			if (PressedKeys.Find('Right') >= 0)
			{
				Debug("Right");
				cubeRotation.Roll += speedFactor * DegToUnrRot;
			}
			if (PressedKeys.Find('Left') >= 0)
			{
				Debug("Left");
				cubeRotation.Roll -= speedFactor * DegToUnrRot;
			}

			cube.cubeRotModifier = cubeRotation;	

			cube.cubePosModifier.y = 5.0;	
		}
	}
	else
	{
		super.PlayerInput(DeltaTime);
	}
}

/*
// INTERFACE 1 
// WASD = CubeXY
// arrowkeys = cube Pitch/Roll
// No pawn movement
event PlayerInput(float DeltaTime)
{
	local Rotator cubeRotation;
	local vector cubePosition;
	local float speedFactor;

	local MyCube cube;

	if (MyPlayerController(Outer).IsInState('Building') || MyPlayerController(Outer).GetStateName() == 'Building')
	{
		cube = MyPlayerController(Outer).CurrentCube;
		if (cube != None)
		{
			speedFactor = MyPlayerController(Outer).cubeSpeedFactor * DeltaTime;

			if (PressedKeys.Find('Add') >= 0)
			{
				MyPlayerController(Outer).cubeSpeedFactor += 0.5;
				Debug("cubeSpeedFactor: "$MyPlayerController(Outer).cubeSpeedFactor);
			}
			if (PressedKeys.Find('Subtract') >= 0)
			{
				MyPlayerController(Outer).cubeSpeedFactor -= 0.5;
				Debug("cubeSpeedFactor: "$MyPlayerController(Outer).cubeSpeedFactor);
			}

			if (PressedKeys.Find('W') >= 0)
			{
				cubePosition.x += speedFactor;
				Debug("W");
			}
			if (PressedKeys.Find('S') >= 0)
			{
				cubePosition.x -= speedFactor;
				Debug("S");
			}
			if (PressedKeys.Find('A') >= 0)
			{
				cubePosition.y -= speedFactor;
				Debug("A");
			}
			if (PressedKeys.Find('D') >= 0)
			{
				cubePosition.y += speedFactor;
				Debug("D");
			}

			cube.cubePosModifier = cubePosition;

			if (PressedKeys.Find('Up') >= 0)
			{
				Debug("Up");
				cubeRotation.Pitch -= speedFactor * DegToUnrRot;
			}
			if (PressedKeys.Find('Down') >= 0)
			{
				Debug("Down");
				cubeRotation.Pitch += speedFactor * DegToUnrRot;
			}
			if (PressedKeys.Find('Right') >= 0)
			{
				Debug("Right");
				cubeRotation.Roll += speedFactor * DegToUnrRot;
			}
			if (PressedKeys.Find('Left') >= 0)
			{
				Debug("Left");
				cubeRotation.Roll -= speedFactor * DegToUnrRot;
			}

			cube.cubeRotModifier = cubeRotation;
		}		
	}
	else
	{
		super.PlayerInput(DeltaTime);
	}

}
*/


/*
event PlayerInput(float DeltaTime)
{
	local Rotator cubeRotation;
	local vector cubePosition;
	local float speedFactor;

	local float FOVScale, TimeScale;

	local MyCube cube;
	local MyPlayerController pc;

	local float mouseTurn, mouseUp;

	pc = MyPlayerController(Outer);
	speedFactor = 50.0 * DeltaTime;

	if (pc.IsInState('Building') || pc.GetStateName() == 'Building')
	{
		// PlayerInput shouldn't take timedilation into account
		DeltaTime /= WorldInfo.TimeDilation;
		if (Outer.bDemoOwner && WorldInfo.NetMode == NM_Client)
		{
			DeltaTime /= WorldInfo.DemoPlayTimeDilation;
		}	

		PreProcessInput(DeltaTime);

		// Scale to game speed
		TimeScale = 100.f * DeltaTime;
		aBaseY		*= TimeScale * MoveForwardSpeed;
		aStrafe		*= TimeScale * MoveStrafeSpeed;
		aUp			*= TimeScale * MoveStrafeSpeed;
		aTurn		*= TimeScale * LookRightScale;
		aLookUp		*= TimeScale * LookUpScale;

		PostProcessInput(DeltaTime);

		ProcessInputMatching(DeltaTime);

		// Take FOV into account (lower FOV == less sensitivity).
		if ( bEnableFOVScaling )
		{
			FOVScale = GetFOVAngle() * 0.01111; // 0.01111 = 1 / 90.0
		}
		else
		{
			FOVScale = 1.0;
		}

		// mouse smoothing
		if (bEnableMouseSmoothing)
		{
			aMouseX = SmoothMouse(aMouseX, DeltaTime,bXAxis,0);
			aMouseY = SmoothMouse(aMouseY, DeltaTime,bYAxis,1);
		}

		aLookUp			*= FOVScale;
		aTurn			*= FOVScale;

		if (bStrafe > 0)
			mouseTurn = aStrafe + aBaseX + aMouseX;
		else
			mouseTurn = aTurn + aBaseX + aMouseX;
		
		mouseUp = aLookUp + aMouseY;

		cube = MyPlayerController(pc).CurrentCube;
		if (cube != None) 
		{
			if (aBaseY > 0)
			{
				cubePosition.x += speedFactor;
				Debug("W");
			}
			else if (aBaseY < 0)
			{
				cubePosition.x -= speedFactor;
				Debug("S");
			}
			if (aStrafe > 0)
			{
				cubePosition.y += speedFactor;
				Debug("D");
			}
			else if (aStrafe < 0) 
			{
				cubePosition.y -= speedFactor;
				Debug("A");
			}

			cube.cubePosModifier += cubePosition;
	
			if (mouseUp > 0)
			{
				cubeRotation.Pitch -= speedFactor * DegToUnrRot;
				Debug("aUp (mouseUp) more than 0");
			}
			else if (mouseUp < 0) 
			{
				cubeRotation.Pitch += speedFactor * DegToUnrRot; 
				Debug("mouseUp less than 0");
			}
			
			if (mouseTurn > 0)
			{
				cubeRotation.Roll += speedFactor * DegToUnrRot;
				Debug("aTurn (mouseTurn) more than 0");
			}
			else if (mouseTurn < 0) 
			{
				cubeRotation.Roll -= speedFactor * DegToUnrRot;
				Debug("mouseTurn less than 0");
			}

			cube.cubeRotModifier = cubeRotation;

		}
	}
	else
	{
		super.PlayerInput(DeltaTime);
	}
}
*/