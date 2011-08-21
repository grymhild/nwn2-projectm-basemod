//:://////////////////////////////////////////////
//:: FileName: "ss_ep_allhoplost"
/* 	Purpose: All Hope Lost - causes all enemies within the area to make a will
		save or resist the spell to avoid losing all courage and drop their items.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "prc_add_spell_dc"
//#include "x2_inc_spellhook"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_ALLHOPE;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ALLHOPE))
	{
		int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);
		float fDuration = RoundsToSeconds(20);
		effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
		effect eFear = EffectFrightened();
		effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
		effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
		float fDelay;
		effect eLink = EffectLinkEffects(eFear, eMind);
		eLink = EffectLinkEffects(eLink, eDur);
		object oTarget, oWeap, oOffhand, oNewR, oNewL;
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT,
			eImpact, GetLocation(OBJECT_SELF));
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
			RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
		while(GetIsObjectValid(oTarget))
		{
			if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
			{
				fDelay = CSLRandomBetweenFloat();
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEAR));
				if(!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
				int nSaveDC = HkGetSpellSaveDC(OBJECT_SELF, oTarget, SPELL_EPIC_ALLHOPE) + 10;
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC,
					SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay))
				{
					if (GetIsCreatureDisarmable(oTarget))
					{
						oWeap = GetItemInSlot
							(INVENTORY_SLOT_RIGHTHAND, oTarget);
						oOffhand = GetItemInSlot
							(INVENTORY_SLOT_LEFTHAND, oTarget);
						if (oWeap != OBJECT_INVALID &&
							GetDroppableFlag(oWeap))
						{
							CopyObject(oWeap, GetLocation(oTarget));
							DelayCommand(2.0, DestroyObject(oWeap));
						}
						if (oOffhand != OBJECT_INVALID &&
							GetDroppableFlag(oOffhand))
						{
							CopyObject(oOffhand, GetLocation(oTarget));
							DelayCommand(2.0, DestroyObject(oOffhand));
						}
					}
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				}
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE,
				RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
		}
	}
	HkPostCast(oCaster);
}