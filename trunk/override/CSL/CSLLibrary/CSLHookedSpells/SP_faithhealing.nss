//::///////////////////////////////////////////////
//:: Faith Healing
//:: sg_s0_faithheal.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Conjuration (Healing)
     Level: Blk 1, Clr 1, Pal 1
     Components: V,S
     Casting Time: 1 action
     Range: Touch
     Target: Creature touched
     Duration: Instantaneous
     Saving Throw: Will half (harmless)
     Spell Resistance: Yes (harmless)

    When laying your hand upon a living creature,
    you channel positive energy that cures 8 points
    of damage +1 point per caster level (up to +5).
    The spell only works on a creature with the same
    patron as you.  A target with no patron or a
    different patron than you is unaffected by the
    spell, even if the target would normally be harmed
    by positive energy.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 2, 2004
//:://////////////////////////////////////////////
// #include "sg_i0_deities"
//
//
//
// 
// void main()
// {
// 
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
//
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
	object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    //int     iDieType        = 0;
    //int     iNumDice        = 0;
    int     iBonus          = iCasterLevel;
    int     iDamage         = 8;

    if(iBonus>5) iBonus=5;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_IMP_HEALING_L);  // Visible impact effect
    effect eHeal    = EffectHeal(iDamage+iBonus);
    effect eLink    = EffectLinkEffects(eImpVis, eHeal);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_FAITH_HEALING, FALSE));
    if( CSLGetIsSameFaith(oCaster, oTarget) && CSLGetIsLiving(oTarget))
    {
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
    }
    else
    {
        FloatingTextStringOnCreature("This spell may only be cast on living targets with the same patron as yourself.", oCaster, FALSE);
    }

    HkPostCast(oCaster);
}


