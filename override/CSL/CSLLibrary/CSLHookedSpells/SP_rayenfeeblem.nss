//::///////////////////////////////////////////////
//:: Ray of EnFeeblement
//:: [NW_S0_rayEnfeeb.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Fort save or take ability
//:: damage to Strength equaling 1d6 +1 per 2 levels,
//:: to a maximum of +5.  Duration of 1 round per
//:: caster level.
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_rayenfeeblem();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RAY_OF_ENFEEBLEMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	object oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration( oCaster );
	int iSpellPower = HkGetSpellPower( oCaster );
	float fDuration = HkApplyMetamagicDurationMods(HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iBonus = CSLGetMin(5, iSpellPower / 2);
				
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_RAY_OF_ENFEEBLEMENT));
		effect eRay = EffectBeam(VFX_BEAM_NECROMANCY, oCaster, BODY_NODE_HAND);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
		if (CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE) != TOUCH_ATTACK_RESULT_MISS)   //Make SR check
		{
			if (!HkResistSpell(oCaster, oTarget)) //Enter Metamagic conditions
			{
				CSLUnstackSpellEffects(oTarget, GetSpellId());
				int nLoss = HkApplyMetamagicVariableMods(d6(), 6) + iBonus;
				effect eLink = EffectVisualEffect(VFX_DUR_SPELL_RAY_ENFEEBLE);
				eLink = EffectLinkEffects(eLink, EffectAbilityDecrease(ABILITY_STRENGTH, nLoss));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
		}
	}
	
	HkPostCast(oCaster);
}

