//::///////////////////////////////////////////////
//:: Explosive Runes
//:: SP_explosiverunes.nss
//:: 2010 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
	Abjuration [Force]
	Level:	Sor/Wiz 3
	Components:	V, S
	Casting Time:	1 standard action
	Range:	Touch
	Target:	One touched object weighing no more than 10 lb.
	Duration:	Permanent until discharged (D)
	Saving Throw:	See text
	Spell Resistance:	Yes
	
	You trace these mystic runes upon a book, map, scroll, or similar object bearing
	written information. The runes detonate when read, dealing 6d6 points of force
	damage. Anyone next to the runes (close enough to read them) takes the full
	damage with no saving throw; any other creature within 10 feet of the runes is
	entitled to a Reflex save for half damage. The object on which the runes were
	written also takes full damage (no saving throw).
	
	You and any characters you specifically instruct can read the protected writing
	without triggering the runes. Likewise, you can remove the runes whenever
	desired. Another creature can remove them with a successful dispel magic or
	erase spell, but attempting to dispel or erase the runes and failing to do so
	triggers the explosion.
	
	Note: Magic traps such as explosive runes are hard to detect and disable. A
	rogue (only) can use the Search skill to find the runes and Disable Device to
	thwart them. The DC in each case is 25 + spell level, or 28 for explosive runes.
*/

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EXPLOSIVERUNES; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eDurVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);  // Duration effect
    effect eImpVis = EffectVisualEffect(VFX_IMP_HEAD_MIND);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
    SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurVis, oCaster, fDuration);

    HkPostCast(oCaster);
}


