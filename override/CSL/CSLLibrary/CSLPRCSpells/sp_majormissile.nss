 	//::///////////////////////////////////////////////
//:: Major Magic Missile
//:: NW_S0_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 10, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: May 8, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
//#include "spinc_common"
//#include "prc_alterations"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MAJOR_MAGIC_MISSILE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables ( fDist / (3.0f * log( fDist ) + 2.0f) )
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(OBJECT_SELF);
	int nDamage = 0;
	int nMetaMagic = HkGetMetaMagicFeat();
	int nCnt;
	effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
	effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
	int nMissiles = (nCasterLvl + 1)/2;
	float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
	float fDelay = fDist/(3.0 * log(fDist) + 2.0);
	float fDelay2, fTime;
	if(!GetIsReactionTypeFriendly(oTarget))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGIC_MISSILE));
		//Limit missiles to five
		if (nMissiles > 15)
		{
			nMissiles = 15;
		}
		//Make SR Check
		if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
		{
			//Apply a single damage hit for each missile instead of as a single mass
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				//Roll damage
				int nDam = HkApplyMetamagicVariableMods( d4(1) + 1, 5 );
				
				if(nCnt == 1)
				{
					//nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
					//PRCBonusDamage(oTarget);
				}
				fTime = fDelay;
				fDelay2 += 0.1;
				fTime += fDelay2;

				//Set damage effect
				effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
				//Apply the MIRV and damage effect
				DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

				DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,0.0f,-2));
				DelayCommand(fDelay2, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
			}
		}
		else
		{
			for (nCnt = 1; nCnt <= nMissiles; nCnt++)
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
			}
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

}
