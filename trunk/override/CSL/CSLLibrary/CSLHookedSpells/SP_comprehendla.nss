//::///////////////////////////////////////////////
//:: Comprehend Languages
//:: sg_s0_complang.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Divination
     Level: Clr 1, Sor/Wiz 1
     Components: V,S
     Casting Time: 1 action
     Range: Personal
     Target: You
     Duration: 10 minutes/level

     You can understand the spoken words of creatures
     or read otherwise incomprehensible written messages.
     Note that the ability to read does not necessarily
     impart insight into the material, merely its literal
     meaning.  The spell enables you to understand or read
     an unknown language, not speak or write it.

     Written material can be read at the rate of one page
     (250 words) per minute.  Magical writing cannot be read,
     other than to know it is magical, but the spell is
     often useful when deciphering treasure maps.  This
     spell can be fooled by certain warding magic.  It does
     not decipher codes or reveal messages concealed in
     otherwise normal text.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 5, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//     //--------------------------------------------------------------------------
//     // Spellcast Hook Code
//     // Added 2003-06-20 by Georg
//     // If you want to make changes to all spells, check x2_inc_spellhook.nss to
//     // find out more
//     //--------------------------------------------------------------------------
//     if (!X2PreSpellCastCode())
//     {
//         return;
//     }
    // End of Spell Cast Hook
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_COMPREHEND_LANGUAGES; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	
	if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_BABBLE ) )
	{
		SignalEvent(oCaster, EventSpellCastAt(oTarget, iSpellId, FALSE));
		CSLPlayerMessageSplit(  "The spell Babble was removed from "+GetName(oTarget)+"!", oTarget, oCaster);
		return;
	}
	
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


