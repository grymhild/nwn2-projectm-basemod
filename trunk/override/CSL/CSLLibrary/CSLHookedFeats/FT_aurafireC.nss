//::///////////////////////////////////////////////
//:: Aura of Fire on Heartbeat
//:: NW_S1_AuraElecC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Prolonged exposure to the aura of the creature
	causes fire damage to all within the aura.
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
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	
	//Declare major variables
	int iHD = GetHitDice(GetAreaOfEffectCreator());
	iHD = iHD/3+1;
	int iDC = 10 + iHD/3;
	int iDamage = d4(iHD);
	int nDamSave;
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
	//Get first target in spell area
	object oTarget = GetFirstInPersistentObject();
	while(GetIsObjectValid(oTarget))
	{
		if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
		{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FIRE));
				//Roll damage
				iDamage = d4(iHD);
				//Make a saving throw check
				//if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iHD, SAVING_THROW_TYPE_FIRE))
				//{
				//	iDamage = iDamage / 2;
				//}
				iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iHD, SAVING_THROW_TYPE_FIRE, oCaster, SAVING_THROW_RESULT_ROLL );
			
				//Set the damage effect
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
			//Get next target in spell area
			oTarget = GetNextInPersistentObject();
	}
}