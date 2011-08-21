//::///////////////////////////////////////////////
//:: Seek Eternal Rest
//:: sg_s0_seekrest.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Conjuration (Healing)
     Level: Pal 4 (Jergal)
     Components: V
     Casting Time: 1 action
     Range: Personal
     Target: You
     Duration: 10 minutes/level

     Originally granted by Jergal to his followers,
     this spell improves your ability to turn undead.
     Your paladin level is treated as two levels
     higher for the purpose of turning or destroying
     undead.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 5, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     object  oTarget         = oCaster;
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
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*10, SC_DURCATEGORY_MINUTES) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_SEEK_ETERNAL_REST, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, fDuration);

    HkPostCast(oCaster);
}


