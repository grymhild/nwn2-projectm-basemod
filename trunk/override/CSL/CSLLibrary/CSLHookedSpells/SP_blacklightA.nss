//::///////////////////////////////////////////////
//:: Blacklight: On Enter
//:: SG_S0_BlklightA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a globe of darkness around those in the area
	of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 28, 2002
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_DARKNESS, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget 		= GetEnteringObject();
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	//float 	fDuration 		= HkGetSpellDuration(iCasterLevel);		

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eInvis 		= EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
	effect eAntiLight 	= EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10);
	effect eSee 		= EffectUltravision();
	effect eDark 		= EffectDarkness();
	effect eDur 		= EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink 		= EffectLinkEffects(eDark, eDur);

	effect eLink2 		= EffectLinkEffects(eInvis, eAntiLight);
	eLink2 = EffectLinkEffects(eLink2, eSee);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	// * July 2003: If has darkness then do not put it on it again
	if(CSLGetHasEffectType( oTarget, EFFECT_TYPE_DARKNESS ) == TRUE)
	{
		return;
	}

	if(GetIsObjectValid(oTarget) && oTarget!=oCaster)
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLACKLIGHT));
		}
		else
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLACKLIGHT, FALSE));
		}
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
	}
	else if (oTarget==oCaster)
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLACKLIGHT, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
	}
}
