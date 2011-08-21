//::///////////////////////////////////////////////
//:: Hold Person
//:: NW_S0_HoldPers
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
//:: He is aware and breathes normally but cannot take any physical
//:: actions, even speech. He can, however, execute purely mental actions.
//:: winged creature that is held cannot flap its wings and falls.
//:: A swimmer can't swim and may drown.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
 


void main()
{
	//scSpellMetaData = SCMeta_SP_holdperson();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HOLD_PERSON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration( OBJECT_SELF );
	float fDuration;
	int iDurType;
	
	iDuration = HkGetScaledDuration(iDuration, oTarget);
	int iSaveDC = HkGetSpellSaveDC();
	effect eParal = EffectParalyze(iSaveDC, SAVING_THROW_WILL);
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_HOLD_PERSON );
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	//effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
	//effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	
	effect eLink = EffectLinkEffects(eParal, eVis);
	//eLink = EffectLinkEffects(eLink, eParal);
	//eLink = EffectLinkEffects(eLink, eVis);
	//eLink = EffectLinkEffects(eLink, eDur3);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_PERSON));
		//Make sure the target is a humanoid
		if ( CSLGetIsHumanoid(oTarget) )
		{
			//Make SR Check
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Make Will save
				if ( !HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC) )
				{
					//Make metamagic extend check
					fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
					iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

					//Apply paralyze effect and VFX impact
					//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
					HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

