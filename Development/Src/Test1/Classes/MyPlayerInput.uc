class MyPlayerInput extends UDKPlayerInput within MyPlayerController;

var float mouseX, mouseY;

function bool InputAxis(int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad)
{
	switch(Key)
	{
		case 'MouseX':
			mouseX += Delta;
			break;
		case 'MouseY':
			mouseY += Delta;
			break;
	}
	return false;
}

event PlayerInput(float DeltaTime)
{
	super.PlayerInput(DeltaTime);
}

event Tick(float DeltaTime)
{
	local float speedFactor;

	super.Tick(DeltaTime);

	changeInterface();

	if (GetIsInBuildingState())
	{
		if (CurrentCube != None && CurrentInterface >= 0)
		{
			speedFactor = cubeSpeedFactor * DeltaTime;

			adjustCubeSpeed();

			switch (CurrentInterface)
			{
				case EBuilderInterfaceType.BUILD_0:
					handleInterface0(speedFactor);
					break;
				case EBuilderInterfaceType.BUILD_1:
					handleInterface1(speedFactor);
					break;
				case EBuilderInterfaceType.BUILD_2:
					handleInterface2(speedFactor);
					break;
				case EBuilderInterfaceType.BUILD_3:
					handleInterface3(speedFactor);
					break;
				case EBuilderInterfaceType.BUILD_4:
					handleInterface4(speedFactor);
					break;
				case EBuilderInterfaceType.BUILD_5:
					handleInterface5(speedFactor);
					break;
			}
		}
	}
}

function adjustCubeSpeed()
{
	if (PressedKeys.Find('Add') >= 0)
	{
		cubeSpeedFactor += 0.5;
		Debug("cubeSpeedFactor: "$cubeSpeedFactor);
	}
	if (PressedKeys.Find('Subtract') >= 0)
	{
		cubeSpeedFactor -= 0.5;
		Debug("cubeSpeedFactor: "$cubeSpeedFactor);
	}	
}

function changeInterface()
{
	if (PressedKeys.Find('F1') >= 0)
	{
		if (CurrentInterface != EBuilderInterfaceType.BUILD_0)
		{
			CurrentInterface = EBuilderInterfaceType.BUILD_0;
			Debug("CurrentInterface: "$CurrentInterface);
		}
	}
	else if (PressedKeys.Find('F2') >= 0)
	{
		if (CurrentInterface != EBuilderInterfaceType.BUILD_1)
		{
			CurrentInterface = EBuilderInterfaceType.BUILD_1;
			Debug("CurrentInterface: "$CurrentInterface);
		}
	}
	else if (PressedKeys.Find('F3') >= 0)
	{
		if (CurrentInterface != EBuilderInterfaceType.BUILD_2)
		{
			CurrentInterface = EBuilderInterfaceType.BUILD_2;
			Debug("CurrentInterface: "$CurrentInterface);
		}
	}
	else if (PressedKeys.Find('F4') >= 0)
	{
		if (CurrentInterface != EBuilderInterfaceType.BUILD_3)
		{
			CurrentInterface = EBuilderInterfaceType.BUILD_3;
			Debug("CurrentInterface: "$CurrentInterface);
		}
	}
	else if (PressedKeys.Find('F5') >= 0)
	{
		if (CurrentInterface != EBuilderInterfaceType.BUILD_4)
		{
			CurrentInterface = EBuilderInterfaceType.BUILD_4;
			Debug("CurrentInterface: "$CurrentInterface);
		}
	}
	else if (PressedKeys.Find('F6') >= 0)
	{
		if (CurrentInterface != EBuilderInterfaceType.BUILD_5)
		{
			CurrentInterface = EBuilderInterfaceType.BUILD_5;
			Debug("CurrentInterface: "$CurrentInterface);
		}
	}
}

function handleInterface0(float speedFactor)
{
	ArrowKeysToPitchRoll(speedFactor);
	CurrentCube.cubePosModifier.x = 10;
}

function handleInterface1(float speedFactor)
{
	local vector cubePosition;

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

	CurrentCube.cubePosModifier = cubePosition;

	ArrowKeysToPitchRoll(speedFactor);
}

function handleInterface2(float speedFactor)
{
	local vector transformedMouse;
	transformedMouse.x = 0.0;
	transformedMouse.y = mouseX;
	transformedMouse.z = mouseY;

	CurrentCube.cubePosModifier = transformedMouse;

	ArrowKeysToPitchRoll(speedFactor);
}

function handleInterface3(float speedFactor)
{

}

function handleInterface4(float speedFactor)
{

}

function handleInterface5(float speedFactor)
{

}

function ArrowKeysToPitchRoll(float speedFactor)
{
	local rotator cubeRotation;

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

	CurrentCube.cubeRotModifier = cubeRotation;
}

DefaultProperties
{
	OnReceivedNativeInputAxis=InputAxis
}