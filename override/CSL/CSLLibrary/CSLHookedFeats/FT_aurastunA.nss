//::///////////////////////////////////////////////
//:: Aura Stunning On Enter
//:: NW_S1_AuraStunA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura of the creature the player
	must make a will save or be stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_aurastun(); //SPELLABILITY_AURA_STUN;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	object oTarget = GetEnteringObject();
	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_ENCHANTMENT );
	effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
	effect eDeath = EffectStunned();
	effect eLink = EffectLinkEffects(eVis2, eDeath);
	int iDuration = GetHitDice(GetAreaOfEffectCreator());
	iDuration = (iDuration / 3) + 1;
	int iDC = 10 + GetHitDice(GetAreaOfEffectCreator())/3;
	iDuration = HkGetScaledDuration(iDuration, oTarget);
	if(!GetIsFriend(oTarget))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_STUN));
			//Make a saving throw check
			if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
			{
				//Apply the VFX impact and effects
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
	}
}