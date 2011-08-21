//::///////////////////////////////////////////////
//:: Stinking Cloud
//:: NW_S0_StinkCldC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Those within the area of effect must make a
	fortitude save or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_stinkingclou(); //SPELL_STINKING_CLOUD;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_STINKING_CLOUD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_POISON, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	effect eStink = EffectDazed();
	effect eMind = EffectVisualEffect( VFX_DUR_SPELL_DAZE );
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink = EffectLinkEffects(eMind, eStink);
	//eLink = EffectLinkEffects(eLink, eDur);

	//effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
	effect eFind;
	object oTarget;
	object oCreator;
	float fDelay;
	//Get the first object in the persistant area
	oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
			{
				if ( !CSLGetIsImmuneToClouds(oTarget) )
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_STINKING_CLOUD, TRUE ));
					//Make a SR check
					//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget))
					//{
					//Make a Fort Save
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_POISON))
					{
						fDelay = CSLRandomBetweenFloat(0.75, 1.75);
						//Apply the VFX impact and linked effects
						if (GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) == FALSE)
						{
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2)));
						}
					}
					else
					{
						//If the Fort save was successful remove the Dazed effect
						eFind = GetFirstEffect(oTarget);
						while (GetIsEffectValid(eFind))
						{
							if(eFind == EffectDazed())
							{
								oCreator = GetEffectCreator(eFind);
								if(oCreator == GetAreaOfEffectCreator())
								{
										RemoveEffect(oTarget, eFind);
								}
							}
							eFind = GetNextEffect(oTarget);
						}
					}
					//}
				}
			}
			//Get next target in spell area
			oTarget = GetNextInPersistentObject();
	}
}