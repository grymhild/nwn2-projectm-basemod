//::///////////////////////////////////////////////
//:: Name 	Morality Undone
//:: FileName sp_moral_undn.nss
//:://////////////////////////////////////////////
/**@file Morality Undone
Enchantment [Evil, Mind-Affecting]
Level: Brd 5, Clr 5, Corruption 4, Mortal Hunter 4
Components: V, S, M/DF
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One non-evil creature
Duration: 10 minutes/level
Saving Throw: Will negates
Spell Resistance: Yes

The caster turns one creature evil. The
chaotic/neutral/lawful component of the subject's
alignment is unchanged. The subject retains whatever
outlook, allegiances, and outlooks it had before,
so long as they do not conflict with the new
alignment. Otherwise, it acts with its new selfish,
bloodthirsty, cruel outlook on all things.

For example, a wizard might not immediately turn on
her fighter companion for no apparent reason,
particularly in the middle of a combat when they're
fighting on the same side. But she might try to steal
the fighter's bag of gems, even using applicable
spells (charm person, suggestion, and invisibility,
for instance) against her friend. She might even
eventually decide to betray or attack her friend if
there is some potential gain involved.

Using this spell in conjunction with a spell such as
dominate person or suggestion is particularly useful,
because it changes what acts are against a subject's
nature.

Arcane Material Component: A powdered holy symbol.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MORALITY_UNDONE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int nGoodEvil = GetGoodEvilValue(oTarget);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	//float fDur = (600.0f * nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_MORALITY_UNDONE, oCaster);

	//Spell Resist
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//Saving Throw
		if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			//Poor, poor paladin. It's pathetic that you didn't make your save.
			AdjustAlignment(oTarget, ALIGNMENT_EVIL, (100 + nGoodEvil));

			//Schedule restoration. This might be a problem if they were 100 before and
			//improved their alignment any while evil. They might be restored to 85 instead.
			DelayCommand(fDuration, AdjustAlignment(oTarget, ALIGNMENT_GOOD, (100 + nGoodEvil)));
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


