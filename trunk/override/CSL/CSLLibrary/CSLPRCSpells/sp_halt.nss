//::///////////////////////////////////////////////
//:: Name 	Halt
//:: FileName sp_halt.nss
//:://////////////////////////////////////////////
/**@file Halt
Transmutation
Level: Bard 3, beguilder 3, duskblade 3, sorcerer/wizard 3
Components: V
Casting Time: 1 immediate action
Range: Close
Target: One creature
Duration: 1 round
Saving Throw: Will negates
Spell Resistance: Yes

The subject creature's feet (or whatever pass for
its feet) become momentarily stuck to the floor.
The creature must stop moving, and cannot move
farter in its current turn. This spell has no
effect on creatures that are not touching the
ground (such as flying creatures), and the subject
can still use a standard action to move by means of
teleporation magic.

**/
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HALT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	int nMetaMagic = HkGetMetaMagicFeat();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	//float fDur = RoundsToSeconds(1);
	
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_HALT, oCaster);


	if (!HkResistSpell(oCaster, oTarget ))
	{
		if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
		{
			effect eHalt = EffectCutsceneImmobilize();

			//if(!flying)
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHalt, oTarget, fDuration);
			}
		}
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}










