//::///////////////////////////////////////////////
//:: Created By: jallaix
//:: Created On: Mar 7, 2007
//:: Updated On: Mar 13, 2007
//:://////////////////////////////////////////////
/*
	Spells & Spell-like effects targeted on the Spell
	Turning protected creature are turned back upon
	the original caster (except area spells & touch
	ranged spells).
	1d4 + 6 spell levels are affected by Spell Turning,
	then the protection disapears.
*/
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_splturning();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPELL_TURNING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	// Remove the current Spell Turning effect if it exists
	if (GetHasSpellEffect(SPELL_SPELL_TURNING, oCaster))
	{
		DeleteLocalInt(oCaster, "JX_SP_SPELLTURN_LVLS");
		effect eLoop = GetFirstEffect(oCaster);
		while (GetIsEffectValid(eLoop))
		{
			if (GetEffectSpellId(eLoop) == SPELL_SPELL_TURNING)
			{
				RemoveEffect(oCaster, eLoop);
			}
			eLoop = GetNextEffect(oCaster);
		}
	}

	// Get the duration and number of level to absorb
	float fDuration = TurnsToSeconds( HkGetCasterLevel(oCaster));
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	
	
	int iNumberLevels = HkApplyMetamagicVariableMods(6 + d4(), 10 );

	// Create the effect
	effect eDur = EffectVisualEffect(VFX_DUR_SPELL_SPELL_MANTLE);
	effect eAbsorb = EffectSpellLevelAbsorption(-1, 0);
	effect eLink = EffectLinkEffects(eDur, eAbsorb);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);

	// Set the number of spell absorption levels
	SetLocalInt(oCaster, "SC_SP_SPELLTURN_LVLS", iNumberLevels);
	DelayCommand(fDuration, DeleteLocalInt(oCaster, "SC_SP_SPELLTURN_LVLS"));

/*
	//Declare major variables
	object oCaster = OBJECT_SELF;
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(HkGetSpellDuration( oCaster )));
	object oTarget = HkGetSpellTarget();
	int iAbsorb = HkApplyMetamagicVariableMods(d8()+8, 16);
	effect eLink = EffectSpellLevelAbsorption(9, iAbsorb);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_SPELL_SPELL_MANTLE));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	CSLUnstackSpellEffects(oTarget, SPELL_LEAST_SPELL_MANTLE, "Least Spell Mantle");
	CSLUnstackSpellEffects(oTarget, SPELL_LESSER_SPELL_MANTLE, "Lesser Spell Mantle");
	CSLUnstackSpellEffects(oTarget, SPELL_SPELL_MANTLE);
	CSLUnstackSpellEffects(oTarget, SPELL_GREATER_SPELL_MANTLE, "Greater Spell Mantle");
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
	
	*/
	
	HkPostCast(oCaster);	
}

