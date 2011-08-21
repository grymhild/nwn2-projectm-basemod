//::///////////////////////////////////////////////
//:: [Power Word Stun]
//:: [NW_S0_PWStun.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The creature is stunned for a certain number of
	rounds depending on its HP.  No save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 4, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.28
- =151HP stunned for 4d4 rounds
- >151HP sometimes stunned for indefinit duration
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_pwdstun();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POWER_WORD_STUN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int nHP =  GetCurrentHitPoints(oTarget);

	int iDuration;
	//Determine the number rounds the creature will be stunned
	if (nHP >= 151)
	{
		iDuration = 0;
	}
	else if (nHP >= 101 && nHP <= 150)
	{
		iDuration = HkApplyMetamagicVariableMods(d4(1), 4 * 1);
	}
	else if (nHP >= 51  && nHP <= 100)
	{
		iDuration = HkApplyMetamagicVariableMods(d4(2), 4 * 2);
		//nMeta = 8;
	}
	else
	{
		iDuration = HkApplyMetamagicVariableMods(d4(4), 4 * 4);
	}
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_STUN, TRUE ));
			//Make an SR check
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{
				if ( iDuration > 0)
				{
					effect eStun = EffectStunned();
					effect eVis = EffectVisualEffect( VFX_HIT_SPELL_ENCHANTMENT );
					effect eDur = EffectVisualEffect( VFX_DUR_STUN );
					eStun = EffectLinkEffects( eStun, eDur );
					
					//Apply linked effect and the VFX impact
					HkApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
					HkApplyEffectToObject( iDurType, eStun, oTarget, fDuration );
				}
			}
	}
	
	HkPostCast(oCaster);
}

