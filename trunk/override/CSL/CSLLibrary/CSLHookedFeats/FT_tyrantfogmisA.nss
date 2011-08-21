//::///////////////////////////////////////////////
//:: Tyrant Fog Zombie Mist Heartbeat
//:: NW_S1_TyrantFgA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creatures entering the area around the zombie
	must save or take 1 point of Constitution
	damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_tyrantfogmis(); //SPELLABILITY_TYRANT_FOG_MIST;
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
	effect eCon = EffectAbilityDecrease(ABILITY_CONSTITUTION, 1);
	effect eTest;
	eCon = ExtraordinaryEffect(eCon);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eCon, eDur);
	int bAbsent = TRUE;
	if(!GetHasSpellEffect(SPELLABILITY_TYRANT_FOG_MIST, oTarget))
	{
			if(bAbsent == TRUE)
			{
				if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
				{
					if ( !CSLGetIsImmuneToClouds(oTarget) )
					{
						//Fire cast spell at event for the specified target
						SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TYRANT_FOG_MIST));
						//Make a saving throw check
						if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, 13, SAVING_THROW_TYPE_POISON, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
						{
							//Apply the VFX impact and effects
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
						}
					}
				}
			}
	}
}
