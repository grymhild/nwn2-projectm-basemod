//::///////////////////////////////////////////////
//:: Fog Cloud
//:: sg_s0_fogcloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a cloud of fog that is indistinguishable from
	cloudkill, but is harmless.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*10, SC_DURCATEGORY_MINUTES) );
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImpairSight = EffectDarkness();
	effect eHideMelee = EffectConcealment(50, MISS_CHANCE_TYPE_VS_MELEE); // is hidden by cloud
	effect eHideRanged = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
	effect eHide = EffectLinkEffects(eHideMelee, eHideRanged);
	effect eLink = EffectLinkEffects(eImpairSight,eHide);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,SPELL_FOG_CLOUD,FALSE));
	if(CSLGetHasEffectType( oTarget, EFFECT_TYPE_DARKNESS ) && !CSLGetHasEffectType( oTarget, EFFECT_TYPE_CONCEALMENT ))
	{
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eHide, oTarget);
	}
	else if(!CSLGetHasEffectType( oTarget, EFFECT_TYPE_DARKNESS ))
	{
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
}
