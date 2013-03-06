class MyPlayerInput extends PlayerInput;

function Debug(string message)
{
	local MyPlayerController pc;
	pc = MyPlayerController(Outer);

	pc.Debug(message);
}

event PlayerInput(float DeltaTime)
{
	local float speedFactor;
	local MyCube cube;
	local EBuilderInterfaceType currentInterface;
	local MyPlayerController pc;
	pc = MyPlayerController(Outer);

	changeInterface(pc);

	if (pc.IsInState('Building') || pc.GetStateName() == 'Building')
	{
		cube = pc.CurrentCube;
		currentInterface = pc.CurrentInterface;
		if (cube != None && currentInterface >= 0)
		{
			speedFactor = pc.cubeSpeedFactor * DeltaTime;

			adjustCubeSpeed(pc);

			switch (currentInterface)
			{
				case pc.EBuilderInterfaceType.BUILD_0:
					handleInterface0(pc, speedFactor);
					break;
				case pc.EBuilderInterfaceType.BUILD_1:
					handleInterface1(cube, speedFactor);
					break;
			}
		}
	}

	super.PlayerInput(DeltaTime);
}

function adjustCubeSpeed(MyPlayerController pc)
{
	if (PressedKeys.Find('Add') >= 0)
	{
		pc.cubeSpeedFactor += 0.5;
		Debug("cubeSpeedFactor: "$pc.cubeSpeedFactor);
	}
	if (PressedKeys.Find('Subtract') >= 0)
	{
		pc.cubeSpeedFactor -= 0.5;
		Debug("cubeSpeedFactor: "$pc.cubeSpeedFactor);
	}	
}

function changeInterface(MyPlayerController pc)
{
	local EBuilderInterfaceType currentInterface;
	currentInterface = pc.CurrentInterface;

	if (PressedKeys.Find('F1') >= 0)
	{
		if (currentInterface != 0)
		{
			pc.CurrentInterface = 0;
			Debug("CurrentInterface: "$pc.CurrentInterface);
		}
	}
	else if (PressedKeys.Find('F2') >= 0)
	{
		if (currentInterface != 1)
		{
			pc.CurrentInterface = 1;
			Debug("CurrentInterface: "$pc.CurrentInterface);
		}
	}
	else if (PressedKeys.Find('F3') >= 0)
	{
		if (currentInterface != 2)
		{
			pc.CurrentInterface = 2;
			Debug("CurrentInterface: "$pc.CurrentInterface);
		}
	}
}

function handleInterface0(MyPlayerController pc, float speedFactor)
{
	local rotator cubeRotation;
	local MyCube cube;
	cube = pc.CurrentCube;

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

function handleInterface1(MyCube cube, float speedFactor)
{
	local vector cubePosition;
	local rotator cubeRotation;

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

	if (IsZero(cubePosition))
	{
		cubePosition.x += 0.0001;
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