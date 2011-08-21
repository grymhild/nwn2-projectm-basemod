//::///////////////////////////////////////////////
//:: Aura of Blinding On Enter
//:: NW_S1_AuraBlndA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura of the creature the player
	must make a will save or be blinded because of the
	sheer ugliness or beauty of the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	//scSpellMetaData = SCMeta_FT_aurablinding(); //SPELLABILITY_AURA_BLINDING;
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
	effect eBlind = EffectBlindness();
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	effect eLink = EffectLinkEffects(eBlind, eDur);
	int iDC = 10 + GetHitDice(GetAreaOfEffectCreator())/3;

	object oTarget = GetEnteringObject();
	int iDuration = 1 + GetHitDice(GetAreaOfEffectCreator())/3;
	//Scale the duration according to the HD of the monster
	iDuration = (iDuration / 3) + 1;
	//Entering object must make a will save or be blinded for the duration.
	if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_AURA_BLINDING));
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
			{
				//Apply the blind effect and the VFX impact
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
			}
	}
}