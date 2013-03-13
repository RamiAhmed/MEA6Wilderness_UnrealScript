class MyArriver extends MyAutonomousAgent;

var(Locomotion) Actor target;
var(Locomotion) float slow_radius;

function PreUpdateLocation()
{
	local float distance;
	local vector target_offset;
	local float clipped_speed;
	local float ramped_speed;
	//local vector temp_velocity;

	target_offset = target.Location - self.Location;
	`Log("target_offset: "$target_offset);
	distance = VSize(target_offset);
	`Log("distance: "$distance);
	ramped_speed = max_speed * (distance / slow_radius);
	`Log("ramped_speed: "$ramped_speed);
	clipped_speed = minimum(ramped_speed, max_speed);
	`Log("clipped_speed: "$clipped_speed);
	desired_velocity = (clipped_speed / distance) * target_offset;
	`Log("desired_velocity: "$desired_velocity);
	steering_direction = desired_velocity - SteeringVelocity;
	`Log("steering_direction: "$steering_direction);
	//`Log("SteeringVelocity:	"$SteeringVelocity);
	`Log("--");
	//`Log("\n");
}

function float minimum(float a, float b)
{
	if (a > b)
	{
		return b;
	}
	else
	{
		return a;
	}
}

defaultproperties
{
	max_force=20000.0
	max_speed=10.0
	slow_radius=10000.0
}