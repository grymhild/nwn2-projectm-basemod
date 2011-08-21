

void main(int objectID, float locationX, float locationY, float locationZ)
{
	object oCaster = GetControlledCharacter(OBJECT_SELF);
	object oTarget = IntToObject(objectID);
	ChangeToStandardFaction(oTarget, STANDARD_FACTION_HOSTILE);
	AssignCommand(oCaster, ActionCastSpellAtObject(SPELL_MAGIC_MISSILE,oTarget));	
}