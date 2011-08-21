//::///////////////////////////////////////////////
//:: Name 	Dragon Cloud
//:: FileName sp_drgn_cloud.nss
//:://////////////////////////////////////////////
/**@file Dragon Cloud
Conjuration (Calling) [Air]
Level: Sanctified 8
Components: V, S, Sacrifice
Casting Time: 1 round
Range: Special (see text)
Effect: One conjured dragon cloud (see text)
Duration: 1 min. + 1 minute/level
Saving Throw: None
Spell Resistance: No

You must cast this spell outdoors, in a place where
clouds are visible. It calls forth a spirit of
elemental air, binds it to a nearby cloud (either a
normal cloud or storm cloud), and gives it a
dragon-like form. Upon forming, the dragon-shaped
cloud swoops toward you, arriving in 1 minute
regardless of the actual distance from you.
(The time it takes to reach you counts toward the
spell's duration.) Once it arrives, you can command
the dragon cloud like a summoned creature. The dragon
cloud speaks Auran.

At the end of the spell's duration, the dragon cloud
evaporates into nothingness as the bound elemental
spirit returns to its home plane. The dragon cloud
cannot pass through liquids or solid objects.

Sacrifice: 1d3 points of Constitution damage.

Author: 	Tenjac
Created: 	6/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
#include "_HkSpell"
#include "_SCInclude_Summon"
#include "_SCInclude_Necromancy"

void SummonDragonCloud(location lLoc, float fDur)
{
	CSLMultiSummonStacking( OBJECT_SELF, CSLGetPreferenceInteger("MaxNormalSummons") );
	effect sSummon = EffectSummonCreature("prc_drag_cld");
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, sSummon, lLoc, fDur);
}




void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DRAGON_CLOUD; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	object oArea = GetArea(oCaster);
	location lLoc = HkGetSpellTargetLocation();
	int nAbove = GetIsAreaAboveGround(oArea);
	int nInside = GetIsAreaInterior(oArea);
	int nNatural = GetIsAreaNatural(oArea);
	//float fDuration = RoundsToSeconds(nCasterLevel);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if(nAbove == AREA_ABOVEGROUND
		&& nInside == FALSE
		//&& nNatural == TRUE //might be in a town, able to see clouds but its not natural
		)
	{
		effect eVis = EffectVisualEffect(VFX_FNF_SUMMONDRAGON);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLoc);
		DelayCommand(60.0f, SummonDragonCloud(lLoc, fDuration));
		//only pay the cost if cast sucessfully
		SCApplyCorruptionCost(oCaster, ABILITY_CONSTITUTION, d3(), 0);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


