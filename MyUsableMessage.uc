class MyUsableMessage extends LocalMessage;

var(Message) string string0;
var(Message) string string1;

static function string getString(optional int Switch,
								 optional bool bPRI1HUD,
								 optional PlayerReplicationInfo RelatedPRI_1,
								 optional PlayerReplicationInfo RelatedPRI_2,
								 optional Object OptionalObject)
{
	if (Switch == 0) 
		return Default.string0;
	else 
		return Default.string1;
}

defaultproperties
{
	string0="Usable object out of range"
	string1="Usable object in range"
	Lifetime=5,
	DrawColor=(R=255, G=255, B=255)
	PosY=0.9
	FontSize=2
}