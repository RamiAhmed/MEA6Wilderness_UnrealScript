class MyPursuer extends MyAutonomousAgent;

var(Locomotion) Actor target;
var(Locomotion) float pursue_parameter;

function PreUpdateLocation()
{
	local float target_distance;
	local vector target_location;
	local vector target_offset;

	target_offset = target.Location - self.Location;
	target_distance = VSize(target_offset);
	target_location = target_offset * (target_distance * pursue_parameter);
	
	desired_velocity = Normal(target_location - self.Location) * max_speed;
	steering_direction = (desired_velocity - SteeringVelocity);
}

defaultproperties
{
	max_force=5000.0
	max_speed=15.0
	pursue_parameter=1000.0
}