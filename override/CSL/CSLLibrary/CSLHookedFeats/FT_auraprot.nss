// Protective Aura
// nx1_s1_protaura
//
// The protective aura which surrounds angels (solars, planetars, etc.)
//
// JSH-OEI 6/6/07
// Original Script By: Preston Watamaniuk

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"


void main()
{
	//scSpellMetaData = SCMeta_FT_auraprot();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	int iSpellPower = HkGetSpellPower( oCaster );
	string sAOETag =  HkAOETag( oCaster, SPELLABILITY_PROTECTIVE_AURA, iSpellPower, -1.0f, FALSE  );
	
	CSLRemoveAuraById( oTarget, SPELLABILITY_PROTECTIVE_AURA );
	
	//if (!GetHasSpellEffect(201, OBJECT_SELF)) // 201 = Protective Aura
	//{
		effect eAOE = EffectAreaOfEffect(AOE_MOB_PROTECTION, "", "", "", sAOETag);
		eAOE = SupernaturalEffect( eAOE );
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PROTECTIVE_AURA, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget, 0.0f, SPELLABILITY_PROTECTIVE_AURA );
	//}
	
	HkPostCast(oCaster);
}