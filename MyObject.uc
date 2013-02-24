class MyObject extends Object;

var int a_number;

function increase_number(int amount) {
	a_number += amount;
}

function int get_number() {
	return a_number;
}

defaultproperties
{
	a_number=20
}