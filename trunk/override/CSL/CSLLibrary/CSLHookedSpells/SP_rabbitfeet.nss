//::///////////////////////////////////////////////
//:: Rabbit Feet
//:: SG_S0_Rabbit.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Transmutation
Level: Brd 1, Drd 1, Rgr 1, Sor/Wiz 1
Casting Time: 1 action
Range: Personal
Target: You
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: No

With the aid of Rabbit Feet, you can pass silently around
attentive guards or sneak through creaky-floored rooms. The
spell softens footfalls, quiets loose equipment, and otherwise
allows you to move silently.

The spell adds +2/level of the caster (maximum +18) to any
Move Silently checks.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 17, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//
//     object  oTarget         = oCaster;
//
//
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
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
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    //int     iDieType        = 0;
    //int     iNumDice        = 0;
    int     iBonus          = iCasterLevel*2;
    //int     iDamage         = 0;

    if(iBonus>18) iBonus=18;
 




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eInc = EffectSkillIncrease(SKILL_MOVE_SILENTLY, iBonus);
    effect eImp = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oCaster,EventSpellCastAt(oCaster,SPELL_RABBIT_FEET, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oCaster);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInc, oCaster, fDuration);

    HkPostCast(oCaster);
}


