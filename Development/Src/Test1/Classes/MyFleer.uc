class MyFleer extends MyAutonomousAgent;

var(Locomotion) Actor target;

function PreUpdateLocation()
{
	desired_velocity = Normal(self.Location - target.Location) * max_speed;
	steering_direction = desired_velocity - SteeringVelocity;
}

defaultproperties
{
	max_force=1000.0
	max_speed=0.55
}