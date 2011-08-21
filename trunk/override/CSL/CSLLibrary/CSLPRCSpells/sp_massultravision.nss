/*
	nw_s0_abilbuff.nss

	Ability buffs, ultravision and
		mass versions thereof

	By: Flaming_Sword
	Created: Jul 1, 2006
	Modified: Jul 2, 2006
*/
//#include "prc_sp_func"
#include "_HkSpell"

void StripBuff(object oTarget, int nBuffSpellID, int nMassBuffSpellID)
{
	effect eEffect = GetFirstEffect(oTarget);
	while (GetIsEffectValid(eEffect))
	{
		int iSpellId = GetEffectSpellId(eEffect);
		if (nBuffSpellID == iSpellId || nMassBuffSpellID == iSpellId)
		{
			RemoveEffect(oTarget, eEffect);
		}
		eEffect = GetNextEffect(oTarget);
	}
}

/*
//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	

	return TRUE; 	//return TRUE if spell charges should be decremented
}
*/



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_ULTRAVISION; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	//int bVision = (iSpellId == SPELL_DARKVISION) || (iSpellId == SPELL_MASS_ULTRAVISION);
	//int bMass = (iSpellId >= SPELL_MASS_BULLS_STRENGTH) && (iSpellId <= SPELL_MASS_ULTRAVISION);
	effect eVis, eDur;
	int nAbility, nAltSpellID;
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	
	eDur = EffectVisualEffect(VFX_DUR_ULTRAVISION);
	eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
	
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_DAYS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	location lTarget;
	//if(bMass)
	//{
	lTarget = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	//}
	while(GetIsObjectValid(oTarget))
	{
		if( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE);
			//if(bMass) fDelay = CSLGetSpellEffectDelay(lTarget, oTarget);
			int nStatMod = HkApplyMetamagicVariableMods( d4() + 1, 5 );
			
			effect eBuff;
			
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectLinkEffects(EffectUltravision(), eDur), oTarget, fDuration );
			
		}
		//if(!bMass) break;
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}