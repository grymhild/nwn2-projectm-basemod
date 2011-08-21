//:://///////////////////////////////////////////////////
//:: Level 8 Arcane Spell: Mass Charm Monster
//:: nw_s0_mschmon.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 08/29/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://///////////////////////////////////////////////////
/*
	The caster attempts to charm a group of individuals
	who's HD can be no more than his level combined.
	The spell starts checking the area and those that
	fail a will save are charmed.  The affected persons
	are Charmed for 1 round per 2 caster levels.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_mscharmmonst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_MASS_CHARM_MONSTER;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELLABILITY_MASS_CHARM_MONSTER )
	{
		int iClass = CLASS_TYPE_RACIAL;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	if (GetSpellId() == SPELLABILITY_MASS_CHARM_MONSTER)
	{
		iSpellPower = GetHitDice(oCaster);
	}
	int nAmount = iSpellPower * 2;
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_CHARM_MONSTER);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( HkGetSpellDuration( oCaster ) /2));
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	while (GetIsObjectValid(oTarget) && nAmount > 0) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster)) {
			if (nAmount>=GetHitDice(oTarget)) {
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MASS_CHARM));
				if (!HkResistSpell(oCaster, oTarget)) {
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS)) {
						effect eCharm = EffectLinkEffects(eDur, HkGetScaledEffect(EffectCharmed(), oTarget));
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCharm, oTarget, fDuration);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					}
				}
				nAmount = nAmount - GetHitDice(oTarget);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	}
	
	HkPostCast(oCaster);
}

