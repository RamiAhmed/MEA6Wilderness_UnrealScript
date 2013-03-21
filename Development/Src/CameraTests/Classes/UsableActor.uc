class UsableActor extends Trigger Placeable;

var bool IsInInteractionRange;

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
	super.Touch(Other, OtherComp, HitLocation, HitNormal);

	if (Pawn(Other) != none)
	{
		// Ideally, we should also check that the touching pawn is a player-controlled one
		IsInInteractionRange = true;
	}
}

event UnTouch(Actor Other)
{
	super.UnTouch(Other);

	if (Pawn(Other) != none)
	{
		IsInInteractionRange = false;
	}
}

function bool UsedBy(Pawn User)
{
	local bool used;

	used = super.UsedBy(User);

	if (IsInInteractionRange)
	{
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
	bStatic=false
}
