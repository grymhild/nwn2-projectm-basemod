
#include "_HkSpell"

void main()
{	
	
object oPC = OBJECT_SELF;
location lTarget = GetSpellTargetLocation();
object oWall = CreateObject(OBJECT_TYPE_PLACEABLE,"sh_plc_illusion_wall",lTarget);
int nSaveDC = 14;



if (GetLevelByClass(CLASS_TYPE_WIZARD,oPC) > GetLevelByClass(CLASS_TYPE_SORCERER,oPC))
{nSaveDC 		= 14 + GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);}
else
{nSaveDC 		= 14 + GetAbilityModifier(ABILITY_CHARISMA, oPC);}

if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION,oPC,TRUE))
{
nSaveDC = nSaveDC +6;
}
if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION,oPC,TRUE))
{
nSaveDC = nSaveDC +2;
}
if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION,oPC,TRUE))
{
nSaveDC = nSaveDC +1;
}




DelayCommand(0.5,SetLocalObject(oWall,"caster",oPC));
DelayCommand(0.5,SetLocalInt(oWall,"SaveDC",nSaveDC));

}