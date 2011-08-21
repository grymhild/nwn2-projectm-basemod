//::///////////////////////////////////////////////
//:: Rune of Return
//:: SP_runeofreturn.nss
//:: 2010 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
	Caster Level(s): Wizard / Sorcerer 5
	Innate Level: 5
	School: Conjuration ( Teleportation )
	Descriptor(s): 
	Component(s): Verbal, Somantic
	Range: Personal
	Area of Effect / Target: Caster
	Duration: Permament until read
	Save: None
	Spell Resistance: No
	
	The caster inscribes a magical rune of  power on the targeted item, usually his
	spell book which activates upon being read. Once read it the chosen item
	immediately teleports back to the wizard and disappears. If the spell
	dimensional anchor is cast on the spell book, the caster is dead or on another
	plane the spell has no effect.
*/

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_RUNEOFRETURN; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_TELEPORTATION, iAttributes ) )
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


