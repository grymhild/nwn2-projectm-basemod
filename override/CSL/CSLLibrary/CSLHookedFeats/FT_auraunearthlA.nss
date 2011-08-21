//::///////////////////////////////////////////////
//:: Aura Unearthly Visage On Enter
//:: NW_S1_AuraUnEaA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura of the creature the player
	must make a will save or be killed because of the
	sheer ugliness or beauty of the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_auraunearthl(); //SPELLABILITY_AURA_UNEARTHLY_VISAGE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	object oTarget = GetEnteringObject();
	effect eDeath = EffectDeath();
	effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
	if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_UNEARTHLY_VISAGE));
			//Make a saving throw check
			if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
			{
				//Apply the VFX impact and effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
	}
}