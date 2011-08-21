//::///////////////////////////////////////////////
//:: Aura of Electricity on Heartbeat
//:: NW_S1_AuraElecC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Prolonged exposure to the aura of the creature
	causes electrical damage to all within the aura.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
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
	
	//Declare major variables
	int iHD = GetHitDice(GetAreaOfEffectCreator());
	iHD = iHD/3+1;
	int iDC = 10 + iHD/3;
	int iDamage;
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
	//Get first target in spell area
	object oTarget = GetFirstInPersistentObject();
	while (GetIsObjectValid(oTarget))
	{
		if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
		{
				iDamage = d4(iHD);
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_AURA_ELECTRICITY));
				//Make a saving throw check
				//if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_ELECTRICITY))
				//{
				//	iDamage = iDamage / 2;
				//}
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ELECTRICITY, oCaster, SAVING_THROW_RESULT_ROLL );
				if ( iDamage > 0 )
				{
					eDam = EffectDamage(iDamage, DAMAGE_TYPE_ELECTRICAL);
					//Apply the VFX impact and effects
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
			//Get next target in spell area
			oTarget = GetNextInPersistentObject();
	}
}
