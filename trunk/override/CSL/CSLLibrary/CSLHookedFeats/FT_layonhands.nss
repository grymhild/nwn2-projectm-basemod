//::///////////////////////////////////////////////
//:: Lay_On_Hands
//:: NW_S2_LayOnHand.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The Paladin is able to heal his Chr Bonus times
	his level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 15, 2001
//:: Updated On: Oct 20, 2003
//:://////////////////////////////////////////////
//:: AFW-OEI 06/13/2006:
//:: If your Cha mod is 0 or less, Lay on Hands does nothing.

#include "_HkSpell"
void main()
{
	//scSpellMetaData = SCMeta_FT_nightsongitr();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	object oTarget = HkGetSpellTarget();
	int nChr = GetAbilityModifier(ABILITY_CHARISMA);
	if (nChr <= 0)
	{
			//nChr = 0;
		return; // AFW-OEI 06/13/2006: Lay on Hands does nothing if you don't have a positive Cha mod.
	}
	int iLevel = GetLevelByClass(CLASS_TYPE_PALADIN);
	iLevel = iLevel + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION);
	iLevel = iLevel + GetLevelByClass(CLASS_HOSPITALER);	//Hospitaler
	iLevel = iLevel + GetLevelByClass(CLASS_CHAMPION_WILD);	//Hospitaler	

	//--------------------------------------------------------------------------
	// July 2003: Add Divine Champion levels to lay on hands ability
	//--------------------------------------------------------------------------
	iLevel = iLevel + GetLevelByClass(CLASS_TYPE_DIVINECHAMPION);

	//--------------------------------------------------------------------------
	// Caluclate the amount to heal, min is 1 hp
	//--------------------------------------------------------------------------
	int nHeal = iLevel * nChr;
	if(nHeal <= 0)
	{
			nHeal = 1;
	}
	effect eHeal = EffectHeal(nHeal);
	effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
	effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
	effect eDam;
	int iTouch;

	//--------------------------------------------------------------------------
	// A paladine can use his lay on hands ability to damage undead creatures
	// having undead class levels qualifies as undead as well
	//--------------------------------------------------------------------------
	if( CSLGetIsUndead( oTarget, TRUE ) )
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
			//Make a ranged touch attack
			iTouch = CSLTouchAttackMelee(oTarget,TRUE);

			//----------------------------------------------------------------------
			// GZ: The PhB classifies Lay on Hands as spell like ability, so it is
			//     subject to SR. No more cheesy demi lich kills on touch, sorry.
			//----------------------------------------------------------------------
			int nResist = HkResistSpell(OBJECT_SELF,oTarget);
			if (nResist == 0 )
			{
				int iTouch = CSLTouchAttackMelee(oTarget);
				if (iTouch != TOUCH_ATTACK_RESULT_MISS )
				{
					nHeal = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nHeal, SC_TOUCHSPELL_MELEE, oCaster );
					
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS));
					eDam = EffectDamage(nHeal, DAMAGE_TYPE_DIVINE);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
				}
			}
	}
	else
	{

			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LAY_ON_HANDS, FALSE));
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	}
	
	if (GetSpellId() == SPELL_Lay_On_Hands_Hostilev1)
	{
		DecrementRemainingFeatUses(OBJECT_SELF, 299);
	}
	
	HkPostCast(oCaster);	
}