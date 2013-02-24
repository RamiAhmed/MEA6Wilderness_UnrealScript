class MyGameInfo extends SimpleGame;

var int health;
var int armor;

var int total_money;
var int dice_sides;

exec function take_damage(optional int damageAmount) {
	if (damageAmount == 0) {
		damageAmount = 10;
	}

	apply_damage(damageAmount, 2);

	if (health <= 0) {
		`Log("Player died");
	}
	else {
		print_health();
	}

}

exec function heal(optional int amount) {
	if (amount == 0) {
		amount = 10;
	}
	health += amount;
	print_health();
}

function apply_damage(int amount, int armor_penetration) {
	local int remaining_armor;
	local int true_damage;

	remaining_armor = armor - armor_penetration;
	true_damage = amount / remaining_armor;
	
	health -= true_damage;
}

function print_health() {
	`Log("Current health: "$health);
}

exec function int random_roll(optional int max) {
	local int result;
	if (max == 0) {
		max = 100;
	}
	result = Rand(max);
	`Log("Random roll: "$result);
	return result;
}

exec function hello_world() {
	`Log("hello, world");
	BroadcastLocalizedMessage(class'MyUsableMessage', 0);
}

exec function length_squared() {
	local int x_location;
	local int y_location;

	x_location = 4;
	y_location = 5;

	`Log("Result: "$Sqrt(Square(x_location) + Square(y_location)));
}


exec function roll(int bet_number, int bet_amount) {
	local int dice_roll;
	dice_roll = Rand(dice_sides)+1;

	`Log("Dice roll: "$dice_roll$" versus your guess at: "$bet_number);

	if (total_money < bet_amount) {
		`Log("You cannot afford to bet that much. You have "$total_money$" left in your account");
		return;
	}

	if (bet_number == dice_roll) {
		total_money += bet_amount * dice_sides;
		`Log("You won! Added "$(bet_amount*dice_sides)$" to your total money, now at: "$total_money);
	}
	else {
		total_money -= bet_amount;
		`Log("You lost. Removed "$bet_amount$" from your total money, now at: "$total_money);
	}
}

exec function change_dice_sides(int new_sides) {
	if (new_sides <= 1) {
		`Log("Cannot create a dice with less than 2 sides");
		return;
	}

	dice_sides = new_sides;
	`Log("Dice now has "$dice_sides$" sides");
}

defaultproperties
{
	health=100
	armor=4
	total_money=100
	dice_sides=6

	PlayerControllerClass=class'MyPlayerController'
	DefaultPawnClass=class'MyPawn'

	Name="Default__MyGameInfo"
}