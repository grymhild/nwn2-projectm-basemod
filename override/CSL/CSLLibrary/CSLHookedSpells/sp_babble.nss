//::///////////////////////////////////////////////
//:: Name 	Babble
//:: FileName sp_babble.nss
//:://////////////////////////////////////////////
/**@file Babble
Enchantment
Level:	Brd 2, Clr 4, Sor/Wiz 3
Components:	V, M/DF
Casting Time:	1 standard action
Range:	Touch
Target:	Creature touched
Duration:	1 min./level
Saving Throw:	Will negates (harmless)
Spell Resistance:	Yes
This spell makes the touched creature unable to be understood, and instead of
making any sense, all those who hear them can hear is babbling, reducing the
target to rely on hand gestures to communicate. The victim magically learns the
langauge but the language itself is not magical, and they also can understand
any lanuage they normally know.

This is not circumvented by comprehend languages, toungues, or other divinations
which allow understanding what other people are saying.

This does not affect spellcasting, but certain spells which require
comprehension by the target ( power word, geas and command for example ) will
not have any effect unless the speaker can make themselves understood.

The babbling however is an actual language, if multiple targets are affected by
this spell they can communicate in this babbeling language as long as they were
all cast by the same caster. However they cannot be understood by others who are
not currently affected by this spell, nor can they communicate with another
victim of this spell who was affected by a different caster.

This spell can be removed by the caster at will.

This spell acts as a counter to Tongues and Comprehend Languages, and casting
Babble on a creature who is using either Tongues or Comprehend Languages will
remove the effects of those spells. Casting Tongues on a victim of the Babble
spell will remove its effects. Whenever these spells remove their opposite
spell, no other effects are applied.

Arcane Material Component
A small clay model of a ziggurat, which shatters when the verbal component is
pronounced.
**/

//:///////////////////////////////////////////////////
//: Author: 	Pain
//: Date : 	9/8/06
//:://////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "_CSLCore_Info"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BABBLE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN | SCMETA_ATTRIBUTES_TURNABLE;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------


	object oTarget = HkGetSpellTarget();
	int bIsTargetHostile= FALSE;
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eDurVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  // Duration effect
    effect eImpVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);
	
	if( GetFactionLeader(oCaster)!=GetFactionLeader(oTarget) )
    {
        bIsTargetHostile = TRUE;
    }
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_BALEFUL_POLYMORPH, oCaster);
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_TONGUES ) )
	{
		SignalEvent(oCaster, EventSpellCastAt(oTarget, iSpellId, FALSE));
		CSLPlayerMessageSplit(  "The spell Tongues was removed from "+GetName(oTarget)+"!", oTarget, oCaster);
		return;
	}
	
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_COMPREHEND_LANGUAGES ) )
	{
		SignalEvent(oCaster, EventSpellCastAt(oTarget, iSpellId, FALSE));
		CSLPlayerMessageSplit(  "The spell Comprehend Languages was removed from "+GetName(oTarget)+"!", oTarget, oCaster);
		return;
	}
	
	if ( bIsTargetHostile )
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
			int iTouch = CSLTouchAttackMelee(oTarget, !CSLIsItemValid(GetSpellCastItem()) );
			if (iTouch != TOUCH_ATTACK_RESULT_MISS)
			{
				//SR
				if(!HkResistSpell(oCaster, oTarget ))
				{
					//First save
					if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
					{
						//Adjust
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
						HkApplyEffectToObject(iDurType, eDurVis, oCaster, fDuration, iSpellId, oCaster );
					}
				}
			}
		}
	}
	else
	{
		// friendly targets don't save or follow normal rules
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
		HkApplyEffectToObject(iDurType, eDurVis, oCaster, fDuration, iSpellId, oCaster );
	}

	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




