//:://////////////////////////////////////////////////////////////////////////
//:: Bard Song: Song of Freedom
//:: nw_s2_sngfreedm.nss
//:: Created By: Brock Heinz - OEI
//:: Created On: 09/06/05
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////////////////////////////////
/*
	Song of Freedom (Req: 12th level, Perform 15):
	At 12th level a bard gains this ability which allows them to do the
	equivalent of a Break Enchantment spell, with the caster level being
	equal to the bard's spell level.


		Break Enchantment
		Abjuration
		Level:   Brd 4, Clr 5, Luck 5, Pal 4, Sor/Wiz 5
		Components:     V, S
		Casting Time:      1 minute
		Range:            Close (25 ft. + 5 ft./2 levels)
		Targets:        Up to one creature per level, all within 30 ft. of each other
		Duration:         Instantaneous
		Saving Throw:      See text
		Spell Resistance:  No

		This spell frees victims from enchantments, transmutations, and curses.
		Break enchantment can reverse even an instantaneous effect. For each
		such effect, you make a caster level check (1d20 + caster level,
		maximum +15) against a DC of 11 + caster level of the effect. Success
		means that the creature is free of the spell, curse, or effect. For a
		cursed magic item, the DC is 25.

		If the spell is one that cannot be dispelled by dispel magic, break
		enchantment works only if that spell is 5th level or lower.

		If the effect comes from some permanent magic item break enchantment
		does not remove the curse from the item, but it does frees the victim
		from the items effects.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_mordsdisjunc();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BREAK_ENCHANTMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iImpactSEF = VFX_HIT_AOE_ABJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iSpellPower = HkGetSpellPower(oCaster);
	
	object oTarget = HkGetSpellTarget();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	effect eImpact;
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (  GetIsObjectValid(oTarget)  )
	{
		DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, SCGetDispellCount(SPELL_BREAK_ENCHANTMENT, TRUE), SPELL_BREAK_ENCHANTMENT ) );
	}
	else
	{
		location lLocal = HkGetSpellTargetLocation();
		float fDelay;
		int nStripCnt = iSpellPower; //;
		
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE );
		while (GetIsObjectValid(oTarget) && nStripCnt > 0)
		{
			
			fDelay = 0.15 * GetDistanceBetween(oCaster, oTarget);
			DelayCommand( fDelay, SCDispelTarget(oTarget, oCaster, SCGetDispellCount(iSpellId, FALSE), SPELL_BREAK_ENCHANTMENT) );
			nStripCnt--;
			
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE );
		}
	}
	
	HkPostCast(oCaster);
}