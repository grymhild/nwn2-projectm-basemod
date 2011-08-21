//:://////////////////////////////////////////////
//:: FileName: "ss_ep_orderresto"
/* 	Purpose: Order Restored - all unlawful targets are stunned, and all
		lawful targets get 5 attacks per round and +10 saves vs. chaos.
	Unlawful casters have alignment shift to law by d10, and spell fails.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_ORDER_R;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ORDER_R))
	{
		int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);

		float fDuration = RoundsToSeconds(20);
		effect eVis = EffectVisualEffect(VFX_FNF_HOWL_ODD);
		effect eStun = EffectStunned();
		effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
		effect eAtt = EffectModifyAttacks(5);
		effect eST = EffectSavingThrowIncrease(SAVING_THROW_ALL, 10, SAVING_THROW_TYPE_CHAOS);
		effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
		effect eLink = EffectLinkEffects(eVis, eStun);
		eLink = EffectLinkEffects(eLink, eDur);
		effect eLink2 = EffectLinkEffects(eAtt, eVis);
		eLink2 = EffectLinkEffects(eLink2, eDur2);
		eLink2 = EffectLinkEffects(eLink2, eST);
		float fDelay;
		// Lawful casters cast normally. All others go to ELSE.
		if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_LAWFUL)
		{
			object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
			while(GetIsObjectValid(oTarget))
			{
				fDelay = CSLRandomBetweenFloat();
				if (GetAlignmentLawChaos(oTarget) != ALIGNMENT_LAWFUL)
				{
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONFUSION));
					if(!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
					{
						if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
						{
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,fDuration));
						}
					}
				}
				else
				{
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration));
				}
				oTarget = GetNextObjectInShape(SHAPE_SPHERE,
				RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
			}
		}
		else // An unlawful caster will sway towards law on a casting.
		{
			FloatingTextStringOnCreature("*Spell fails. You are not lawful*",
				OBJECT_SELF, FALSE);
			AdjustAlignment(OBJECT_SELF, ALIGNMENT_LAWFUL, d10());
		}
	}
	HkPostCast(oCaster);
}

