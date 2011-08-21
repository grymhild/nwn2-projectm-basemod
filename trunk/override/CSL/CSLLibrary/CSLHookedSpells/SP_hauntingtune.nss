//::///////////////////////////////////////////////
//:: Haunting Tune
//:: sg_s0_haunting.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Enchantment (Compulsion) [Mind-Affecting, Sonic]
     Level: Brd 3
     Components: V, S
     Casting Time: 1 full round
     Range: Medium
     Area: 1 target/level
     Duration: 10 minutes/level
     Saving Throw: Will negates
     Spell Resistance: Yes

     Your song or poem causes a deep depression in
     intelligent creatures.  Any creature with
     Intelligence 10 or higher is shaken (-2 morale
     penalty on attack rolls, damage rolls, and saving
     throws).
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 4, 2004
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	//object  oTarget = HkGetSpellTarget();
	
	//int iMetamagic = HkGetMetaMagicFeat();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	location lTarget = HkGetSpellTargetLocation();
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
	//int     iBonus          = 0;
	int     iDamage         = 2;
	
	float   fRadius         = FeetToMeters(100.0+10.0*iCasterLevel);
	int     iNumTargets     = iCasterLevel;
	int     iNumAffected    = 0;
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImpVis  = EffectVisualEffect(VFX_FNF_HOWL_MIND);
	effect eAtt     = EffectAttackDecrease(iDamage);
	effect eDam     = EffectDamageDecrease(iDamage);
	effect eSave    = EffectSavingThrowDecrease(SAVING_THROW_ALL, iDamage);
	effect eVis     = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
	effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eLink    = EffectLinkEffects(eAtt, eDam);
	eLink = EffectLinkEffects(eSave, eLink);
	eLink = EffectLinkEffects(eVis, eLink);
	eLink = EffectLinkEffects(eDur, eLink);
	int iDC;
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oCaster);
	object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while(GetIsObjectValid(oTarget) && iNumAffected<iNumTargets)
	{
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HAUNTING_TUNE));
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            if(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE)>10 && !HkResistSpell(oCaster, oTarget) && !HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS))                
			{
				int iDC = HkGetSpellSaveDC(oCaster, oTarget);				
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			}
			iNumAffected++;
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}
	HkPostCast(oCaster);
}


