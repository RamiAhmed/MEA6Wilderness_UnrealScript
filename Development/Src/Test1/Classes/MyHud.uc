class MyHud extends UDKHUD;

var float BuilderModeTextScale;

function DrawHUD()
{
	local MyPlayerController player;
	local Vector2D textPosition;

	super.DrawHUD();

	textPosition.x = 500;
	textPosition.y = 50;
	player = MyPlayerController(PlayerOwner);
	if (player.GetIsInBuildingState())
	{
		DrawTextAt("BuilderMode Interface: "$player.CurrentInterface, textPosition);
	}
	else
	{
		DrawTextAt("Not in BuilderMode", textPosition);
	}

	textPosition.x = 700;
	textPosition.y = 50;
	DrawTextAt("MousePosition: "$player.mouseX$","$player.mouseY, textPosition);
}


function DrawTextAt(string text, Vector2D position)
{
	local Vector2D TextSize;

	Canvas.SetPos(position.X, position.Y);
	Canvas.TextSize(text, TextSize.X, TextSize.Y);
	Canvas.SetPos(position.X - ((TextSize.X * BuilderModeTextScale / RatioX) / 2), position.Y - ((TextSize.Y * BuilderModeTextScale / RatioY) / 2));
	Canvas.DrawText(text, false, BuilderModeTextScale/RatioX, BuilderModeTextScale/RatioY);
}



defaultproperties
{
	BuilderModeTextScale=1.0
}