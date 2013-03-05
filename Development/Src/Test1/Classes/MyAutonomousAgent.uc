class MyAutonomousAgent extends Actor placeable;

var(Locomotion) bool Active;
var(Locomotion) float mass;
var(Locomotion) float max_force;
var(Locomotion) float max_speed;

var vector MyPosition;
var vector SteeringVelocity;
//var rotator orientation;
var vector steering_direction;
var vector steering_force;
var vector MyAcceleration;
var vector desired_velocity;

//var vector start_position;

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	if (Active) {
		UpdateLocation(DeltaTime);
	}
}


event PostBeginPlay()
{
	//start_position = self.Location;
	/*if (Active)
	{
		SetTimer(0.5, True, 'UpdateLocation', self);
	}*/
}

function UpdateLocation(float DeltaTime)
{
	PreUpdateLocation();

	steering_force = truncate(steering_direction, max_force);
	`Log("steering_force :"$steering_force);
	MyAcceleration = steering_force / mass;
	`Log("MyAcceleration :"$MyAcceleration);
	SteeringVelocity = truncate((SteeringVelocity + MyAcceleration), max_speed);
	`Log("SteeringVelocity :"$SteeringVelocity);
	MyPosition = MyPosition + SteeringVelocity;
	`Log("MyPosition: "$MyPosition);
	//self.setLocation((start_position + MyPosition) * DeltaTime);
	self.MoveSmooth(MyPosition * DeltaTime);
	`Log("\n");	
}

function PreUpdateLocation()
{

}

function vector truncate(vector v, float max)
{
	local float i;

	if (IsZero(v))
		return v;

	i = max / VSize(v);
	i = i < 1.0 ? i : 1.0;
	v *= i;
	return v;
}

defaultproperties
{
	mass=1.0
	max_force=1.0
	max_speed=0.5

	Begin Object Class=StaticMeshComponent Name=MyMesh
		StaticMesh=StaticMesh'NodeBuddies.3D_Icons.NodeBuddy__BASE_SHORT'
	End Object

	Begin Object Class=DynamicLightEnvironmentComponent Name=LightEnvironmentComp
	    bEnabled=true
	End Object    

	CollisionComponent=MyMesh
	Components.Add(LightEnvironmentComp)
	Components.Add(myMesh)

	BlockRigidBody=true
	bBlockActors=true
	bCollideWorld=true
	bHidden=false
}