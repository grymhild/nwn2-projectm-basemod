//::///////////////////////////////////////////////
//:: Mind Fog: On Exit
//:: NW_S0_MindFogB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a bank of fog that lowers the Will save
	of all creatures within who fail a Will Save by
	-10.  Effect lasts for 2d6 rounds after leaving
	the fog
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_mindfog(); //SPELL_MIND_FOG;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_MIND_FOG;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId,  SCMETA_DESCRIPTOR_MIND|SCMETA_DESCRIPTOR_GAS, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	// cannot use standardized handler since this put an effect on exiting creature once it leaves AOE, need to make a with type variant
	// CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, GetAreaOfEffectCreator(), GetExitingObject(), SPELL_MIND_FOG );
	
	
	//Declare major variables
	effect eSave = EffectSavingThrowDecrease(SAVING_THROW_WILL, 10);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_MIND_FOG_VIC );
	//effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
	effect eLink = EffectLinkEffects(eSave, eDur);
	//eLink = EffectLinkEffects(eLink, eVis);

	
	int bValid = FALSE;
	//Get the object that is exiting the AOE
	
	object oTarget = GetExitingObject();
	//Search through the valid effects on the target.
	effect eAOE = GetFirstEffect(oTarget);
	if(GetHasSpellEffect(SPELL_MIND_FOG, oTarget))
	{
		while (GetIsEffectValid(eAOE))
		{
			//If the effect was created by the Mind_Fog then remove it
			if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator() && GetEffectSpellId(eAOE) == SPELL_MIND_FOG)
			{
				if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
				{
						RemoveEffect(oTarget, eAOE);
						bValid = TRUE;
				}
			}
			//Get the next effect on the creation
			eAOE = GetNextEffect(oTarget);
		}
	}
	if(bValid == TRUE)
	{
		int iDuration = HkApplyMetamagicVariableMods(d6(2), 6 * 2);
		float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
		//Apply the new temporary version of the effect
		HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
	}
}