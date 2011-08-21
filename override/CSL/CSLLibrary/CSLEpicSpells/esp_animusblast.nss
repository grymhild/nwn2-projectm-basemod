//:://////////////////////////////////////////////
//:: FileName: "ss_ep_animusblas"
/* 	Purpose: Animus Blast
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_epicspells"
//#include "nw_i0_generic"

void DoAnimationBit(location lTarget, object oCaster, int nCasterLvl);


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_SCInclude_Summon"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_ANBLAST;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ANBLAST))
	{
		int nCasterLvl = HkGetCasterLevel();
		float fDelay;
		int nDam;
		effect eExplode = EffectVisualEffect(VFX_IMP_PULSE_COLD);
		effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
		effect eDam, eLink;
		location lTarget = HkGetSpellTargetLocation();

		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
		DelayCommand(0.3,
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
		DelayCommand(0.6,
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
		DelayCommand(0.9,
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
		DelayCommand(1.2,
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget));
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
			RADIUS_SIZE_HUGE, lTarget);
		while (GetIsObjectValid(oTarget))
		{
			if (oTarget != OBJECT_SELF && !GetIsDM(oTarget) && !GetFactionEqual(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
				HkGetSpellId()));
				fDelay = CSLRandomBetweenFloat();
				if(!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
					nDam = d6(10);
					// Reflex save for half damage.
					if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget), SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
					{
						nDam /= 2;
					}
					eDam = HkEffectDamage(nDam, DAMAGE_TYPE_COLD);
					eLink = EffectLinkEffects(eDam, eVis);
					eLink = EffectLinkEffects(eExplode, eLink);
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
					// Do the animation bit if the target dies from blast.
					if ( CSLGetIsLiving(oTarget) )
					{
						SetLocalInt(oTarget, "nAnBlasCheckMe", TRUE);
					}
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE,
				RADIUS_SIZE_HUGE, lTarget);
		}
		DelayCommand(3.0, DoAnimationBit(lTarget, OBJECT_SELF, nCasterLvl));
	}
	HkPostCast(oCaster);
}

void DoSpawnBit(object oCaster, object oTarget, string sSkel, int nCasterLvl)
{
	if(CSLGetPreferenceInteger("MaxNormalSummons"))
	{
		//only create a new one if less than maximum count		
		int nMaxHDControlled = nCasterLvl * 4;
		int nTotalControlled = CSLGetControlledUndeadTotalHD(oCaster);
		if(nTotalControlled < nMaxHDControlled)
		{
			CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
			AssignCommand(oCaster, HkApplyEffectAtLocation(DURATION_TYPE_PERMANENT,
				EffectSummonCreature(sSkel, VFX_FNF_SUMMON_UNDEAD), GetLocation(oTarget)));
		}
	}
	else
	{
		SetMaxHenchmen(999);
		object oSkel = CreateObject(OBJECT_TYPE_CREATURE, sSkel,
			GetLocation(oTarget));
		AddHenchman(oCaster, oSkel);
		SetAssociateListenPatterns(oSkel);
		CSLDetermineCombatRound( oSkel );
		//DetermineCombatRound(oSkel);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD), GetLocation(oTarget));
	}
}

void DoAnimationBit(location lTarget, object oCaster, int nCasterLvl)
{
	int nX = 0;
	int nM = GetMaxHenchmen();
	int nH = nM;
	string sSkel = "csl_sum_undead_skeleton7";
	object oSkel;
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
		RADIUS_SIZE_HUGE, lTarget);
	while (GetIsObjectValid(oTarget))
	{
		if (nX < 12)
		{
			if (GetIsDead(oTarget) &&
				GetLocalInt(oTarget, "nAnBlasCheckMe") == TRUE)
			{
				float fDelay = IntToFloat(Random(60))/10.0;
				DelayCommand(fDelay, DoSpawnBit(oCaster, oTarget, sSkel, nCasterLvl));
				nX++;
			}
		}
		DeleteLocalInt(oTarget, "nAnBlasCheckMe");
		oTarget = GetNextObjectInShape(SHAPE_SPHERE,
			RADIUS_SIZE_HUGE, lTarget);
	}
	DelayCommand(10.0, SetMaxHenchmen(nM));
}
