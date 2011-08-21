//::///////////////////////////////////////////////
//:: Alter Text
//:: SP_altertext.nss
//:: 2010 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
	Transmutation
	Level:	Brd 2, Sor/Wiz 2
	Components:	V, S
	Casting Time:	1 standard action
	Range:	Touch
	Target:	One scroll or two pages
	Duration:	Instantaneous
	Saving Throw:	See text
	Spell Resistance:	No
	Alter text allows a wizard to take non magical writings and rearrange the
	letters as he pleases. The wizard must be able to understand what is written in
	order to change it. However the entire page can be altered to any extent desired
	by the wizard. Once altered the original text can no longer be known, but the
	act of altering it might be detected via careful use of detect magic, generally
	by a more powerful wizard.
	
	Magical writings cannot be affected by this spell but this can be used to alter
	the non magical descriptions.
*/

#include "_HkSpell"
#include "_SCInclude_Language"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ALTERTEXT; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
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
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurVis, oCaster, fDuration);
	
	// redisplay the book if it's open now, note this does not work if the gui is closed, but it should be open - if not there is a an issue so that is a good thing
	object oBook = GetLocalObject(oCaster, "CSLBOOK_VIEWING");
	if ( GetIsObjectValid( oBook) )
	{
		int iSpreadNumber = GetLocalInt(oBook, "CSLBOOK_CURRENTSPREAD");
		SCBook_DisplaySpread( iSpreadNumber, oBook, oCaster );
	}
	
    HkPostCast(oCaster);
}


