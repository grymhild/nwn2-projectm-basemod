//::///////////////////////////////////////////////
//:: Bookward
//:: SP_bookward.nss
//:: 2010 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
	School: abjuration
	Level: bard 2, cleric 2, sorcerer/wizard 2  
	Casting time: 1 standard action 
	Components: V, S, M/DF (a drop of clear oil)  
	Range: touch 
	Target: one touched object of up to 10 pounds/level 
	Duration: 1 day/level or until discharged (see text) 
	Saving throw: Will negates (harmless, object);
	Spell Resistance: Yes (harmless, object) 
	
	As protection from energy, except as noted above and that 
	the spell only protects against acid and fire damage. While 
	the energy protection remains, the item is also completely 
	waterproof (this protection extends to other liquids as well, 
	such as alcohol and oil).

*/

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BOOKWARD; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
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


