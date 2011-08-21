//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloudC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Objects within the AoE take 4d6 fire damage
	per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Updated By: GeorgZ 2003-08-21: Now affects doors and placeables as well


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_INCENDIARY_CLOUD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION|SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDamage;
	effect eDam;
	object oTarget;
	//Declare and assign personal impact visual effect.
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	float fDelay;

	//Capture the first target object in the shapee
	oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	//Declare the spell shape, size and the location.
	while(GetIsObjectValid(oTarget))
	{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
			{
				fDelay = CSLRandomBetweenFloat(0.5, 2.0);
				//Make SR check, and appropriate saving throw(s).
				//if(!HkResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
				//{
					SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_INCENDIARY_CLOUD));
					//Roll damage.
					iDamage = HkApplyMetamagicVariableMods(d6(4), 6 * 4);
					
					//Adjust damage for Reflex Save, Evasion and Improved Evasion
					iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(),SAVING_THROW_TYPE_FIRE, GetAreaOfEffectCreator());
					// Apply effects to the currently selected target.
					eDam = EffectDamage(iDamage, DAMAGE_TYPE_FIRE);
					if(iDamage > 0)
					{
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				// }
			}
			//Select the next target within the spell shape.
			oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}