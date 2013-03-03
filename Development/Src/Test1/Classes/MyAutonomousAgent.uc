class MyAutonomousAgent extends Actor placeable;

var(Locomotion) float mass;
var(Locomotion) float max_force;
var(Locomotion) float max_speed;

var vector MyPosition;
var vector MyVelocity;
//var rotator orientation;
var vector steering_direction;
var vector steering_force;
var vector MyAcceleration;
var vector desired_velocity;

event Tick(float DeltaTime)
{
	super.Tick(DeltaTime);

	UpdateLocation(DeltaTime);
}

function UpdateLocation(float DeltaTime)
{
	PreUpdateLocation();

	steering_force = truncate(steering_direction, max_force);
	MyAcceleration = steering_force / mass;
	MyVelocity = truncate((MyVelocity + MyAcceleration), max_speed);
	MyPosition += MyVelocity;
	self.MoveSmooth(MyPosition * DeltaTime);	
}

function PreUpdateLocation()
{

}

function vector truncate(vector v, float s)
{
	local float i;

	if (IsZero(v))
		return v;

	i = s / VSize(v);
	i = i < 1.0 ? i : 1.0;
	v *= i;
	return v;
}

defaultproperties
{
	mass=100.0
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