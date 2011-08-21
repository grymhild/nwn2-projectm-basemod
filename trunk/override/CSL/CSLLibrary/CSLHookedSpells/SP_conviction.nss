//::///////////////////////////////////////////////
//:: Conviction
//:: nx2_s0_conviction.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*

	Conviction
	Abjuration
	Level: Cleric 1
	Components: V, S
	Range: Touch
	Target: Creature touched
	Duration: 10 minutes/level
	Saving Throw: Will negates (harmless)
	Spell Resistance: Yes (harmless)
	
	This spell bolsters the mental, physical, and spiritual strength of the creature touched.
	The spell grants the subject a +2 bonus on saving throws, with an additional +1 to the bonus for
	every six caster levels you have (maximum +5 bonus at 18th level).

	
*/
//:://////////////////////////////////////////////
//:: Created By: Michael Diekmann
//:: Created On: 09/04/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CONVICTION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	// Get necessary objects
	object oTarget = HkGetSpellTarget();
	
	// Caster level
	int iSpellPower = HkGetSpellPower( oCaster );
	// Spell Duration
	float fDuration = 10 * TurnsToSeconds(HkGetSpellDuration( oCaster ));
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	// Cap caster level
	//if(iSpellPower > 18)
	// iSpellPower = 18;
	// Amount of increase
	
	// make this so it scales up to max save given by module, defaults work same as vanilla OEI maxed at 5
	int nIncrease = HkCapSaves( iSpellPower/6, -2 );

	// Effects
	effect eSTIncrease = EffectSavingThrowIncrease(SAVING_THROW_ALL, (2 + nIncrease));
	effect eVisual = EffectVisualEffect(VFX_HIT_SPELL_CONVICTION);

	// Make sure spell target is valid
	if (GetIsObjectValid(oTarget))
	{
		// remove previous usages of this spell
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_NIGHTSHIELD);
		if (GetHasSpellEffect(SPELL_SUPERIOR_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_GREATER_RESISTANCE, oTarget) || GetHasSpellEffect(SPELL_CONVICTION, oTarget) )
		{
			FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
			return;
		}
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
		// check to see if ally
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			// apply linked effect to target
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSTIncrease, oTarget, fDuration);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget);
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
		
	}
	
	HkPostCast(oCaster);
}

