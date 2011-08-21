//::///////////////////////////////////////////////
//:: Song of Fury
//:: cmi_s2_sngfury
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Jan 19, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = BLADESINGER_SONG_FURY;
	/*
	object oCaster = OBJECT_SELF;
	
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	*/

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	



	object oPC = OBJECT_SELF;
		
	
	int bHasSongFury = GetHasSpellEffect(-iSpellId,oPC);
	if (bHasSongFury)
	{
		SendMessageToPC(oPC, "Song of Fury disabled.");	
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, -iSpellId );
	}
	else
	{
	
		int bSongFuryValid = IsBladesingerValid();	
		if (bSongFuryValid)
		{
			//RemoveSpellEffects(iSpellId, oPC, oPC);
					
			effect eBonusAttack = EffectModifyAttacks(1);
			effect eAB = EffectAttackDecrease(2);
			effect eLink = EffectLinkEffects(eAB, eBonusAttack);
			eLink =  SupernaturalEffect(eLink);		
			eLink = SetEffectSpellId(eLink,-iSpellId);
			
			if (!bHasSongFury)
			{
				SendMessageToPC(oPC,"Song of Fury enabled.");			
			}
			HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC, 0.0f, -iSpellId );			
		}
		else
		{
		    //RemoveSpellEffects(iSpellId, oPC, oPC);
			if (bHasSongFury)
			{
				SendMessageToPC(oPC,"Song of Fury disabled, it is only valid when wielding a longsword or rapier in one hand (and nothing in the other) and wearing light or no armor.");			
			}
		}
	}
	
	
		
}