//:://////////////////////////////////////////////
//:: FileName: "ss_ep_audi_stone"
/* 	Purpose: Audience of Stone - all enemies in the spell's radius makes a
		FORT save or else turn to stone.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_SCInclude_Transmutation"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_A_STONE;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_A_STONE))
	{
		float fDelay;
		effect eExplode = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
		effect eVis = EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM);
		effect eStone = EffectPetrify();
		effect eLink = EffectLinkEffects(eVis, eStone);
		location lTarget = HkGetSpellTargetLocation();

		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
			RADIUS_SIZE_LARGE, lTarget);
		while (GetIsObjectValid(oTarget))
		{
			if (oTarget != OBJECT_SELF && !GetIsDM(oTarget) && !GetFactionEqual(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
				HkGetSpellId()));
				fDelay = CSLRandomBetweenFloat(1.5, 2.5);
				if(!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
//Use bioware petrify command
				SCDoPetrification(HkGetCasterLevel(), OBJECT_SELF, oTarget, HkGetSpellId(), HkGetSpellSaveDC(OBJECT_SELF, oTarget));
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE,
				RADIUS_SIZE_LARGE, lTarget);
		}
	}
	HkPostCast(oCaster);
}
