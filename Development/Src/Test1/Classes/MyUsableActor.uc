class MyUsableActor extends Trigger Placeable;

//var() const string Prompt;
//var() StaticMeshComponent MyMesh;
var bool IsInInteractionRange;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if (Pawn(Other) != none) 
	{
		// Ideally, we should also check that the touching pawn is a player-controlled one
//		PlayerController(Pawn(Other).Controller).myHUD.AddPostRenderedActor(self);
		IsInInteractionRange = true;
	}
}

event UnTouch(Actor Other)
{
	super.UnTouch(Other);

	if (Pawn(Other) != none) 
	{
//		PlayerController(Pawn(Other).Controller).myHUD.RemovePostRenderedActor(self);
		IsInInteractionRange = false;
	}
}

function bool UsedBy(Pawn User) 
{
	local bool used;

	used = super.UsedBy(User);

	if (IsInInteractionRange) 
	{
		// If it matters, you might want to double check here that the user is a player-controlled pawn.
		//PlaySound(SoundCue'ImportTest.A_Use_Cue'); // Put your own sound cue here. And ideally, don't directly reference assets in code.
		//`Log("UsedBy called and IsInInteractionRange returned true. This is where we would've played a sound!");
		//WorldInfo.Game.Broadcast(self, "UsedBy called and IsInInteractionRange is true.");
		
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
		HiddenGame=true 
		HiddenEditor=true
	End Object

	Begin Object Class=StaticMeshComponent Name=MyMesh
		CastShadow=true
		bUsePrecomputedShadows=true
		StaticMesh=StaticMesh'cubePackage.96x96boxWithX3ZeroCenter'
	End Object

	Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironmentComp
	    bEnabled=true
	    bDynamic=true
	End Object    

	Begin Object Name=CollisionCylinder
	    CollisionRadius=80.0
	    CollisionHeight=60.000000
	    CollideActors=true
	End Object
	
	CollisionComponent=CollisionCylinder

	Components.Add(CollisionCylinder)
	Components.Add(LightEnvironmentComp)
	Components.Add(Sprite)
	Components.Add(myMesh)

	BlockRigidBody=true
	bCollideActors=true
	bBlockActors=true
	bCollideWorld=true
	bHidden=false
}