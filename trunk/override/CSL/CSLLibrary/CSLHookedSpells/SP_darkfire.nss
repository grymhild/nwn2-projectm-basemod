//::///////////////////////////////////////////////
//:: Darkfire
//:: SOZ UPDATE BTM
//:: X2_S0_Darkfire
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Gives a melee weapon 1d6 fire damage +1 per two caster
  levels to a maximum of +10.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller
#include "_HkSpell"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"

void AddFlamingEffectToWeapon(object oTarget, float fDuration, int iCasterLevel)
{
   // If the spell is cast again, any previous itemproperties matching are removed.
   CSLSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(127,iCasterLevel), fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING);
   CSLSafeAddItemProperty(oTarget, ItemPropertyVisualEffect(ITEM_VISUAL_FIRE), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
   return;
}


void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DARKFIRE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
	eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FLAME_M),eVis);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	int iDuration = 2 * HkGetSpellDuration( oCaster );
	int iSpellPower = 2 * HkGetSpellPower( oCaster, 10 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();
	
	
	if(GetIsObjectValid(oMyWeapon) )
	{
		SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));
		
		if (iDuration>0)
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
			HkApplyEffectToObject(iDurType, eDur, GetItemPossessor(oMyWeapon), fDuration );
			AddFlamingEffectToWeapon(oMyWeapon, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES), iSpellPower);
		
		 }
		return;
	}
	else
	{
	   FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
	   return;
	}
	
	HkPostCast(oCaster);
}