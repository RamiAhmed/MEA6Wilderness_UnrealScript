class MySeeker extends MyAutonomousAgent;

var(Locomotion) Actor target;

function PreUpdateLocation()
{
	desired_velocity = Normal(target.Location - self.Location) * max_speed;
	steering_direction = desired_velocity - MyVelocity;
}

defaultproperties
{

}