class MyFleer extends MyAutonomousAgent;

var(Locomotion) Actor target;

function PreUpdateLocation()
{
	desired_velocity = Normal(self.Location - target.Location) * max_speed;
	steering_direction = desired_velocity - MyVelocity;
}

defaultproperties
{

}