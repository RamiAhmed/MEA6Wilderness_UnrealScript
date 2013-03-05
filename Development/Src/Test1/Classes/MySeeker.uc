class MySeeker extends MyAutonomousAgent;

var(Locomotion) Actor target;

function PreUpdateLocation()
{
	desired_velocity = Normal(target.Location - self.Location) * max_speed;
	steering_direction = desired_velocity - SteeringVelocity;
}

defaultproperties
{
	max_force=5000.0
	max_speed=0.50
}