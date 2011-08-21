//::///////////////////////////////////////////////
//:: Aura of the Unnatural On Enter
//:: NW_S1_AuraMencA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the aura all animals are struck with
	fear.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_auraunearthl(); //SPELLABILITY_AURA_UNNATURAL;
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
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_FEAR );
	effect eFear = EffectFrightened();
	effect eLink = EffectLinkEffects(eVis, eFear);
	object oTarget = GetEnteringObject();
	int iDuration = GetHitDice(GetAreaOfEffectCreator());
	int nRacial = GetRacialType(oTarget);
	int iDC = 10 + GetHitDice(GetAreaOfEffectCreator())/3;
	if(GetIsEnemy(oTarget))
	{
			iDuration = (iDuration / 3) + 1;
			//Make a saving throw check
			if(nRacial == RACIAL_TYPE_ANIMAL)
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_UNNATURAL));
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER ))
				{
					//Apply the VFX impact and effects
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				}
			}
	}
}