class MyPlane extends Actor;
/*
defaultproperties
{
	Begin Object Name=Sprite
		HiddenGame=true HiddenEditor=true
	End Object

	Begin Object Class=StaticMeshComponent Name=MyMesh
		StaticMesh=StaticMesh'NodeBuddies.3D_Icons.NodeBuddy__BASE_SHORT'
	End Object

	CollisionComponent=MyMesh

	Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironmentComp
	    bEnabled=true
	End Object    

	Components.add(LightEnvironmentComp)
	Components.Add(Sprite)
	Components.Add(myMesh)

	bStatic=false

	BlockRigidBody=true
	bBlockActors=true
	bCollideWorld=true
	bHidden=false
	UseSimpleRigidBodyCollision=true
}*/