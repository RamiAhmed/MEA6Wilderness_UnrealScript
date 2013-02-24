class MyUsableActor extends Trigger Placeable;

var() const string Prompt;
var bool IsInInteractionRange;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if (Pawn(Other) != none) 
	{
		// Ideally, we should also check that the touching pawn is a player-controlled one
		PlayerController(Pawn(Other).Controller).myHUD.AddPostRenderedActor(self);
		IsInInteractionRange = true;
	}
}

event UnTouch(Actor Other)
{
	super.UnTouch(Other);

	if (Pawn(Other) != none) 
	{
		PlayerController(Pawn(Other).Controller).myHUD.RemovePostRenderedActor(self);
		IsInInteractionRange = false;
	}
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
	local Font previous_font;
	super.PostRenderFor(PC, Canvas, CameraPosition, CameraDir);
	previous_font = Canvas.Font;

	Canvas.Font = class'Engine'.Static.GetMediumFont();
	Canvas.SetPos(400, 300);
	Canvas.SetDrawColor(0, 255, 0, 255);
	Canvas.DrawText(Prompt); // Prompt is a string variable defined in our new actor's class.
	Canvas.Font = previous_font;
}

function bool UsedBy(Pawn User) 
{
	local bool used;

	used = super.UsedBy(User);

	if (IsInInteractionRange) 
	{
		// If it matters, you might want to double check here that the user is a player-controlled pawn.
		//PlaySound(SoundCue'ImportTest.A_Use_Cue'); // Put your own sound cue here. And ideally, don't directly reference assets in code.
		`Log("UsedBy called and IsInInteractionRange returned true. This is where we would've played a sound!");
		WorldInfo.Game.Broadcast(self, "UsedBy called and IsInInteractionRange is true.");
		
		ProcessUsedBy(User);

		return true;
	}
	return used;
}

function ProcessUsedBy(Pawn User)
{

}

DefaultProperties
{
	Begin Object Name=Sprite
		HiddenGame=true HiddenEditor=true
	End Object

	Begin Object Class=StaticMeshComponent Name=MyMesh
		StaticMesh=StaticMesh'NodeBuddies.3D_Icons.NodeBuddy__BASE_SHORT'
	End Object

	CollisionComponent=MyMesh

	Components.Add(Sprite)
	Components.Add(myMesh)
	BlockRigidBody=true
	bBlockActors=true
	bCollideWorld=true
	bHidden=false
}