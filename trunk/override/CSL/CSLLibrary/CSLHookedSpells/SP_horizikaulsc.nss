//::///////////////////////////////////////////////
//:: Horizikaul's Cough
//:: sg_s0_horcough.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation [Sonic]
     Level: Sor/Wiz 0
     Components: V, S
     Casting Time: 1 action
     Range: Close (25ft + 5ft / 2 levels)
     Target: One creature or object
     Duration: Instantaneous
     Saving Throw: Will partial
     Spell Resistance: Yes

     You create a brief but loud noise adjacent to
     the target.  Horizikaul's Cough strikes unerringly,
     even if the target is in melee or has anything
     less than total cover or concealment.  The target
     takes 1 point of sonic damage and must succeed at
     a Will saving throw or be deafened for 1 round.
     This spell has no effect if cast into the area of
     a silence spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 19, 2004
//:://////////////////////////////////////////////
// #include "sg_inc_elements"
//
//
//
// 
// void main()
// {
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(2) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    //int     iDieType        = 0;
    //int     iNumDice        = 0;
    //int     iBonus          = 0;
    int     iDamage         = 1;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(iHitEffect);  // Visible impact effect
    effect eDeaf    = EffectDeaf();
    effect eDeafVis = EffectVisualEffect( VFX_DUR_SPELL_BLIND_DEAF );
    effect eDamage  = HkEffectDamage(iDamage, iDamageType);
    effect eLink    = EffectLinkEffects(eImpVis, eDamage);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HORIZIKAULS_COUGH));
    if((!GetHasSpellEffect(SPELL_SILENCE, oTarget) || !GetHasFeatEffect(EFFECT_TYPE_DEAF, oTarget)) && !HkResistSpell(oCaster, oTarget))
	{
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
        if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, iSaveType))
        {
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeafVis, oTarget);
        }
    }

    HkPostCast(oCaster);
}

