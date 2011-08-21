// Protective Aura
// nx1_s1_protaura
//
// The protective aura which surrounds angels (solars, planetars, etc.)
//
// NLC-OEI 3/17/08
// Original Script By: Preston Watamaniuk
#include "_HkSpell"

void main()
{
    //--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DROWNED_AURA;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = -1;
		
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
    object oTarget = HkGetSpellTarget(); // Should be oCaster Really
 	
    if (!GetHasSpellEffect(iSpellId, oTarget)) 
	{
		int iSpellPower = HkGetSpellPower( oCaster );
		string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	
		effect eAOE = EffectAreaOfEffect(AOE_MOB_DROWNED_AURA, "", "", "", sAOETag);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
    	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget, 0.0f, 325);
	}
	HkPostCast(oCaster);
}