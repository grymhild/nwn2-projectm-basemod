//::///////////////////////////////////////////////
//:: Towering Oak
//:: sg_s0_toweroak.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Illusion (Glamer)
     Level: Rgr 1
     Components: V, S
     Casting Time: 1 action
     Range: Personal
     Target: You
     Duration: 3 rounds/level

    You draw on the oak's strength to improve your
    ability to intimidate you enemies.  You gain a
    competence bonus of +10 on your Intimidate checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 3, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
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
	int iSpellId = SPELL_TOWERING_OAK; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_GLAMER, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(3*iDuration) );
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);	

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_IMP_MAGBLUE);  // Visible impact effect
    effect eOak   = EffectSkillIncrease(SKILL_INTIMIDATE, 10);
    eOak   = EffectLinkEffects(eOak, EffectAbilityIncrease(ABILITY_STRENGTH, 2));

    eOak   = EffectLinkEffects(eOak, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));

	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


    SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOak, oTarget, fDuration);

    HkPostCast(oCaster);
}


