//::///////////////////////////////////////////////
//:: Wail of the Banshee
//:: NW_S0_WailBansh
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	You emit a terrible scream that kills enemy creatures who hear it
	The spell affects up to one creature per caster level. Creatures
	closest to the point of origin are affected first.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_wailbanshee();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WAIL_OF_THE_BANSHEE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_WAIL_OF_THE_BANSHEE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC|SCMETA_DESCRIPTOR_DEATH, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nToAffect = iSpellPower;
	int nCnt = 0;
	float fTargetDistance;
	float fDelay;
	location lLocation = HkGetSpellTargetLocation();
	effect eWail = EffectVisualEffect( VFX_HIT_SPELL_WAIL_OF_THE_BANSHEE );   // makes use of NWN2 VFX
	effect eVis = EffectVisualEffect (VFX_HIT_SPELL_NECROMANCY);//looks cooler
	effect eDeath = EffectDeath();
	
	int iRandomSeparator = Random(9999999)+1;
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lLocation);
	

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lLocation);
	object oTarget = HkGetSpellTarget();
	if (!GetIsObjectValid(oTarget))
	{
		oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lLocation, nCnt);
		nCnt++;
	}
	//SendMessageToPC( oCaster, "Wail Text nCnt="+IntToString(nCnt)+" nToAffect="+IntToString(nToAffect) );
	while (nCnt < nToAffect)
	{
		fTargetDistance = GetDistanceBetweenLocations(lLocation, GetLocation(oTarget));
		//SendMessageToPC( oCaster, "Iteration Text nCnt="+IntToString(nCnt) );
		if (GetIsObjectValid(oTarget) && GetLocalInt(oTarget, "CSL_WAILSEPARATOR") != iRandomSeparator && fTargetDistance <= 10.0f ) //Check that the current target is valid and closer than 10.0m
		{
			//SendMessageToPC( oCaster, "1" );
			SetLocalInt(oTarget, "CSL_WAILSEPARATOR", iRandomSeparator); // basic hack to fix tmi @todo need to rewrite this to make it so hack is not needed to begin with, was repeating on the same target over and over
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
			{
				//SendMessageToPC( oCaster, "2" );
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WAIL_OF_THE_BANSHEE));
				if (oTarget!=oCaster && !HkResistSpell(oCaster, oTarget))
				{
					//SendMessageToPC( oCaster, "3" );
					if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DEATH))
					{
						//SendMessageToPC( oCaster, "4" );
						fDelay = CSLRandomBetweenFloat(1.0, 2.0);
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
					}
				}
			}
			else
			{
				//SendMessageToPC( oCaster, "5" );
				nCnt--; //FIX: do not count allies
			}
		}
		else
		{
			//SendMessageToPC( oCaster, "6" );
			nCnt = nToAffect; // forcing exit
		}
		nCnt++;
		//SendMessageToPC( oCaster, "7" );
		oTarget = GetNearestObjectToLocation(OBJECT_TYPE_CREATURE, lLocation, nCnt);
		//SendMessageToPC( oCaster, "8" );
	}
	HkPostCast(oCaster);
}
