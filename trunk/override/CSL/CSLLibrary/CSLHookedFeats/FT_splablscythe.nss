// nx_s3_scythe_devour_spirit
/*
	Akachi's Scythe has a lesser Devour Spirit power on it
	
	Similar to standard devour spirit except for that it also takes players spirit energy
	
*/
// MichaelD
// ChazM 5/30/07 - Mask of Betrayer Protects against Akachi's devour.
// JSH-OEI 6/11/07 - Modified for use with Akachi's Scythe

#include "_SCInclude_SpiritEater"
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



////#include "_inc_helper_functions"
//#include "_SCUtility"
#include "_CSLCore_Math"

void main()
{
	//scSpellMetaData = SCMeta_FT_splablscythe();
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
	
	string sItemTag = "nx1_mask_of_betrayer";// mask is protective against this spell
	int bTargetHasMask = CSLGetIsItemEquipped(sItemTag, oTarget, TRUE);
	
	int iDamage;
	int nSpiritEnergy;
	int nTargetMaxHP = GetMaxHitPoints(oTarget);
	int nCurrentHP = GetCurrentHitPoints(oTarget);
	iDamage = (nTargetMaxHP * 5) / 100; // Target takes 5% of max
	nSpiritEnergy = -2; // Reduced from -15 for real Devour Spirit
	if (iDamage < 1)
			iDamage = 1;
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)
			&& (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE))
	{
		// Visual effect on caster
		// effect eVis = EffectVisualEffect(VFX_CAST_SPELL_DEVOUR_SPIRIT);
		// HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
	
		// visual effect on target
		// effect eBeam = EffectBeam(VFX_HIT_SPELL_DEVOUR_SPIRIT, oCaster, BODY_NODE_HAND);
		effect eZap = EffectVisualEffect(VFX_HIT_SPELL_DEVOUR_SPIRIT);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eZap, oTarget, VFX_SE_HIT_DURATION);

		// apply effects
		effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE);
		
		// Reduced spirit drain effect if Mask is equipped
		if (bTargetHasMask)
		{
			nSpiritEnergy = -1; // half damage, rounded up
		}
		
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		
		// Apply spirit drain ONLY if the target is also the PC
		if (oTarget == oPC)
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

