//::///////////////////////////////////////////////
//:: Herald's Call
//:: sg_s0_herald.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Enchantment (Compulsion) [Mind-Affecting, Sonic]
     Level: Brd 1, Hrp 1
     Components: V, S
     Casting Time: 1 action
     Range: 30 ft.
     Area: 30-ft.-radius burst centered on you
     Duration: 1 round
     Saving Throw: Will negates
     Spell Resistance: Yes

    You produce a crowd-stopping shout that holds an
    air of authority others find difficult to ignore.
    The spell affects only those creatures that have
    5HD or less.  Anyone affected is dazed for 1 round.

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 2, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     object  oTarget;         //= HkGetSpellTarget();
//     
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//
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
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(2) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	float   fRadius         = FeetToMeters(30.0);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lTarget        = GetLocation(oCaster);
	int     iDC;  




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_FNF_SOUND_BURST);  // Visible impact effect
    effect eDaze    = EffectDazed();

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    while(GetIsObjectValid(oTarget)) {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && GetHitDice(oTarget)<=5) {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HERALDS_CALL));
            if(!HkResistSpell(oCaster, oTarget)) {
                if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS | SAVING_THROW_TYPE_SONIC)) {
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDuration);
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    }

    HkPostCast(oCaster);
}


