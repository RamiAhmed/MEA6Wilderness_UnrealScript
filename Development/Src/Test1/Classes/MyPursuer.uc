class MyPursuer extends MyAutonomousAgent;

var(Locomotion) Actor target;
var(Locomotion) float pursue_parameter;

function PreUpdateLocation()
{
	local float target_distance;
	local vector target_location;

	target_distance = VSize(target.Location - (self.Location + MyPosition));
	target_location = target.Location * (target_distance * pursue_parameter);
	
	desired_velocity = Normal(target_location - (self.Location + MyPosition)) * max_speed;
	steering_direction = (desired_velocity - MyVelocity);
}

defaultproperties
{
	pursue_parameter=0.01
}