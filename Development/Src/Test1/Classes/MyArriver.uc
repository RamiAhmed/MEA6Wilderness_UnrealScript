class MyArriver extends MyAutonomousAgent;

var(Locomotion) Actor target;
var(Locomotion) float slow_radius;

function PreUpdateLocation()
{
	local float distance;
	local float ramped_speed;
	local vector target_offset;
	local float clipped_speed;

	target_offset = target.Location - self.Location;
	distance = VSize(target_offset);
	ramped_speed = max_speed * (distance / slow_radius);
	clipped_speed = ramped_speed;
	if (clipped_speed > max_speed)
	 	clipped_speed = max_speed;

	desired_velocity = (clipped_speed / distance) * target_offset;
	steering_direction = desired_velocity - MyVelocity;
}

defaultproperties
{
	slow_radius=2000.0
}