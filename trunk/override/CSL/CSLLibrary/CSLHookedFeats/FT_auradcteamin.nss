//::///////////////////////////////////////////////
//:: Teamwork (Nightsong Enforcer)
//:: cmi_s2_neteamwork
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: November 8, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_auradcteamin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
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
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, -1.0f, FALSE  );
	
	if (!GetHasSpellEffect(SPELLABILITY_AURA_DC_TEAMINIT, OBJECT_SELF))
	{
		effect eAOE = EffectAreaOfEffect(VFX_PER_NE_TEAMWORK, "", "", "", sAOETag);
		//Create an instance of the AOE Object using the Apply Effect function
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_AURA_DC_TEAMINIT, FALSE));
	    DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, oTarget, 0.0f, SPELLABILITY_AURA_DC_TEAMINIT ));
		
			
		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
		eVis = SupernaturalEffect(eVis);
		eVis = SetEffectSpellId (eVis, -SPELLABILITY_AURA_DC_TEAMINIT);
		DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oTarget ));	
						
	}
	HkPostCast(oCaster);		
}