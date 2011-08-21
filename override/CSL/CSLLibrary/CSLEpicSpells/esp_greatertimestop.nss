//::///////////////////////////////////////////////
//:: Time Stop
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: FileName: "ss_ep_grtimestop"
/* 	Purpose: Greater Timestop - in all ways this spell is the same as
		Timestop except for the duration, which is doubled.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "inc_timestop"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_GR_TIME;
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
	int nDuration = d4(2)+2;

	if (GetCanCastSpell(oCaster, SPELL_EPIC_GR_TIME))
	{
		location lTarget = HkGetSpellTargetLocation();
		effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
		effect eTime = EffectTimeStop();
		float fDuration = RoundsToSeconds(nDuration);

		if(CSLGetPreferenceSwitch("PNPTimestopDuraton"))
		{
			fDuration = 18.0;
		}
		
		if(CSLGetPreferenceSwitch("PNPTimestopLocal"))
		{
			eTime = EffectAreaOfEffect(VFX_PER_NEW_TIMESTOP);
			eTime = EffectLinkEffects(eTime, EffectEthereal());
			if(CSLGetPreferenceSwitch("PNPTimestopNoHostile"))
			{
				CSLStopItemDamage( GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster),fDuration);
				CSLStopItemDamage( GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster),fDuration);
				CSLStopItemDamage( GetItemInSlot(INVENTORY_SLOT_BULLETS, oCaster),fDuration);
				CSLStopItemDamage( GetItemInSlot(INVENTORY_SLOT_ARROWS, oCaster),fDuration);
				CSLStopItemDamage( GetItemInSlot(INVENTORY_SLOT_BOLTS, oCaster),fDuration);
				CSLStopItemDamage( GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCaster),fDuration);
				CSLStopItemDamage( GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCaster),fDuration);
				CSLStopItemDamage( GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCaster),fDuration);
			}
		}

		SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));
		DelayCommand(0.75, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, oCaster, fDuration ));
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
	}
	HkPostCast(oCaster);
}

