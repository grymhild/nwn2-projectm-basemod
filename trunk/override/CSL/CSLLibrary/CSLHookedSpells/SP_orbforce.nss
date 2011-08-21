//::///////////////////////////////////////////////
//:: Orb of Force
//:: cmi_s0_orbforce
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Jan 1, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"


void main()
{	
	//scSpellMetaData = SCMeta_SP_orbforce();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Orb_Force;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFXSC_HIT_HYPOTHERMIA;
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iSpellPower = HkGetSpellPower(OBJECT_SELF, 10);
	
	int iDamage;	
	int nSaveThrow;	
		
	effect eVis;	
	int iDamageType;

	iDamageType	= DAMAGE_TYPE_MAGICAL;
	eVis = EffectVisualEffect(VFX_HIT_SPELL_MAGIC);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{		
			int nRangedTouch = CSLTouchAttackRanged(oTarget);
			if (nRangedTouch != TOUCH_ATTACK_RESULT_MISS)
			{
				iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6*iSpellPower );
				iDamage = HkApplyTouchAttackCriticalDamage( oTarget, nRangedTouch, iDamage, SC_TOUCHSPELL_RANGED, OBJECT_SELF );
													
				effect eDamage = HkEffectDamage(iDamage,iDamageType);
				
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));				

				//Apply the effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);		
				
			}
		}	
	}
	
	HkPostCast(oCaster);
}

