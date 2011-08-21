//::///////////////////////////////////////////////
//:: Secret Page
//:: SP_secretpage.nss
//:: 2010 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
	Transmutation
	Level:	Brd 3, Sor/Wiz 3
	Components:	V, S, M
	Casting Time:	10 minutes
	Range:	Touch
	Target:	Page touched, up to 3 sq. ft. in size
	Duration:	Permanent
	Saving Throw:	None
	Spell Resistance:	No
	Secret page alters the contents of a page so that they appear to be something entirely different. The text of a spell can be changed to show even another spell. Explosive runes or sepia snake sigil can be cast upon the secret page.
	
	A comprehend languages spell alone cannot reveal a secret page's contents. You are able to reveal the original contents by speaking a special word. You can then peruse the actual page, and return it to its secret page form at will. You can also remove the spell by double repetition of the special word. A detect magic spell reveals dim magic on the page in question but does not reveal its true contents. True seeing reveals the presence of the hidden material but does not reveal the contents unless cast in combination with comprehend languages. A secret page spell can be dispelled, and the hidden writings can be destroyed by means of an erase spell.
	
	Material Component
	Powdered herring scales and will-o-wisp essence.
*/

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SECRETPAGE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_LANGUAGE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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


