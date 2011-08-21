//::///////////////////////////////////////////////
//:: Nature's Avatar
//:: nw_s0_natavatar.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	With a touch, you gift your animal ally with nature's strength, resilience
	and speed.

	The affected animal gains a +10 bonus on attack and damage rolls, and 1d8
	temporary hit points per caster level, plus the effect of the haste spell.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Transmutation"





void main()
{
	//scSpellMetaData = SCMeta_SP_natureavatar();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_NATURE_AVATAR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
//Major variables
	object oTarget  = HkGetSpellTarget();

	if (!GetIsObjectValid(oTarget)) return;
	if (!CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster)) return;
	
	if (CSLGetIsAnimal(oTarget))
	{
		if (!CSLGetHasEffectType( oTarget, EFFECT_TYPE_POLYMORPH ))
		{
			CSLUnstackSpellEffects(oTarget, GetSpellId());
			int iCasterLevel  = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
			float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( HkGetSpellDuration( oCaster ) ));
			effect eOnDispell = EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_NATURE_AVATAR));
			effect eLink = EffectVisualEffect(VFX_SPELL_DUR_NATURE_AVATAR);
			eLink = EffectLinkEffects(eLink, EffectAttackIncrease(iCasterLevel/3));
			eLink = EffectLinkEffects(eLink, EffectHaste());
			eLink = EffectLinkEffects(eLink, EffectDamageIncrease(DAMAGE_BONUS_10, DAMAGE_TYPE_SLASHING ));
			eLink = EffectLinkEffects(eLink, eOnDispell);
			int nHP  = HkApplyMetamagicVariableMods(d8(iCasterLevel), 8 * iCasterLevel);
			effect eBonusHP = EffectLinkEffects(EffectTemporaryHitpoints(nHP), eOnDispell);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonusHP, oTarget, fDuration);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELL_NATURE_AVATAR );
			return;
		}
	}
	FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
	
	HkPostCast(oCaster);
}