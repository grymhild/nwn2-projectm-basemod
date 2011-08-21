//::///////////////////////////////////////////////
//:: Lesser Energized Shield - Electrical
//:: cmi_s0_lsrenrgshld_e
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 3, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{	
	//scSpellMetaData = SCMeta_SP_enershld_e();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_Lesser_Energized_Shield_E;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ELECTRICAL, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

    	
	effect eDamShld = EffectDamageShield(0, DAMAGE_BONUS_1d4, DAMAGE_TYPE_ELECTRICAL);
	effect eDamRes = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 5, 0);	
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
		
	effect eLink = EffectLinkEffects(eDamRes, eDamShld);
	eLink = EffectLinkEffects(eLink, eVis);	
	
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF );
	float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
	fDuration = HkApplyMetamagicDurationMods(fDuration);
		
	object oTarget = HkGetSpellTarget();
	
    CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId() );	
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
	
	HkPostCast(oCaster);
}

