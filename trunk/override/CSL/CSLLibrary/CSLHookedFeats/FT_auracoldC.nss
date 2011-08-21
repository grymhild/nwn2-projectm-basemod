//::///////////////////////////////////////////////
//:: Aura of Frost on Heartbeat
//:: NW_S1_AuraColdC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Prolonged exposure to the aura of the creature
	causes frost damage to all within the aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_auracold(); //SPELLABILITY_AURA_COLD;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iHD = GetHitDice(GetAreaOfEffectCreator());
	iHD = iHD/3+1;
	int iDamage;
	int iDC = 10 + iHD/3;

	effect eDam;
	effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
	object oTarget;
	//Get the first target in the aura of cold
	oTarget = GetFirstInPersistentObject();
	while (GetIsObjectValid(oTarget))
	{
		if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
		{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_COLD));
				//Roll damage based on the creatures HD
				iDamage = d4(iHD);
				//Make a Fortitude save for half
				//if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_COLD))
				//{
				//	iDamage = iDamage / 2;
				//}
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_COLD, oCaster, SAVING_THROW_RESULT_ROLL );
				if ( iDamage > 0 )
				{
					//Set the damage effect
					eDam = EffectDamage(iDamage, DAMAGE_TYPE_COLD);
					//Apply the VFX constant and damage effect
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
			//Get the next target in the aura of cold
			oTarget = GetNextInPersistentObject();
	}
}
