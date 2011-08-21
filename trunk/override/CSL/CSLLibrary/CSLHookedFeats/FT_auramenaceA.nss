//::///////////////////////////////////////////////
//:: Aura of Menace On Enter
//:: NW_S1_AuraMencA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura all those that fail
	a will save are stricken with Doom.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{
	//scSpellMetaData = SCMeta_FT_auramenace(); //SPELLABILITY_AURA_MENACE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	object oTarget = GetEnteringObject();
	int iDuration = 1 + GetHitDice(GetAreaOfEffectCreator())/3;
	effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
	int iDC = 10 + GetHitDice(GetAreaOfEffectCreator())/3;

	effect eLink = SCCreateDoomEffectsLink();

	int iLevel = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);

	if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_AURA_MENACE));
			//Spell Resistance and Saving throw
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_ALL, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
			}
	}
}