// nx_s2_akachi_devour_spirit
/*
	Akachi's Spirit Eater Devour Spirit Feat
	
	Similar to standard devour spirit except for that it also takes players spirit energy
	
*/
// MichaelD
// ChazM 5/30/07 - Mask of Betrayer Protects against Akachi's devour.
// JSH-OEI 7/5/07 - Checks to see if PC was the target before draining any spirit energy

#include "_SCInclude_SpiritEater"
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




#include "_CSLCore_Math"

void main()
{
	//scSpellMetaData = SCMeta_FT_splablakachi();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	
	object oTarget  = HkGetSpellTarget();
	object oPC = GetSpiritEater();
	
	effect eHeal;
	
	string sItemTag = "nx1_mask_of_betrayer";// mask is protective against this spell
	int bTargetHasMask = CSLGetIsItemEquipped(sItemTag, oTarget, TRUE);
	
	int iDamage;
	int nSpiritEnergy;
	int nTargetMaxHP = GetMaxHitPoints(oTarget);
	int nCurrentHP = GetCurrentHitPoints(oTarget);
	iDamage = (nTargetMaxHP * 15) / 100; // Target takes 15% of max
	eHeal = EffectHeal(iDamage); // heal yourself for whatever damage you inflicted
	nSpiritEnergy = -25;
	if (iDamage < 1)
	{
		iDamage = 1;
	}
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)
			&& (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
			&& GetIsSoul(oTarget)
			)
	{
		// Visual effect on caster
		effect eVis = EffectVisualEffect(VFX_CAST_SPELL_DEVOUR_SPIRIT);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
	
		// visual effect on target
		effect eBeam = EffectBeam(VFX_HIT_SPELL_DEVOUR_SPIRIT, oCaster, BODY_NODE_HAND);
		DelayCommand(VFX_SE_HIT_DELAY, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, VFX_SE_HIT_DURATION));

		// apply effects
		effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE);
		effect eHit = EffectNWN2SpecialEffectFile("fx_a_akachi_eater_hit_b_bk");
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oCaster);
		
		// spirit energy loss is reduced if target has mask of the betrayer
		if (bTargetHasMask)
		{
			nSpiritEnergy = -12;
			}
		
		// Check to see if target was the PC
		if (GetOwnedCharacter(GetFactionLeader(oPC)) == oTarget)
		{
			UpdateSpiritEaterPoints(IntToFloat(nSpiritEnergy));
		}
		
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));
	}
	else
	{   // used on invalid target, so abort and give back.
			PostFeedbackStrRef(oCaster, STR_REF_INVALID_TARGET);
			return;
	}
	HkPostCast(oCaster);
}

