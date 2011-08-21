// nx_s2_mold_spirit
/*
	Spirit Eater Mold Spirit
	
Alignment: Neutral
The player gains the ability to use spirit-based crafting essences gained from Devour Spirit
in special new crafting recipes. This would be usable ability that counts as the “spell”
cast when crafting using one of the spirit recipes.
	
*/
// ChazM 4/2/07

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



////#include "_inc_helper_functions"
//#include "_SCUtility"
//#include "_SCInclude_SpiritEater"

void main()
{
	//scSpellMetaData = SCMeta_FT_splablmoldsp();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	object oTarget = HkGetSpellTarget();
	
	// doesn't really do anything on its own.
	
	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	
	HkPostCast(oCaster);
}