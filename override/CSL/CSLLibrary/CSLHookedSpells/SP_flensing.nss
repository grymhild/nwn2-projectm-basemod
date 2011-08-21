//::///////////////////////////////////////////////
//:: Flensing
//:: SG_S0_Flensing.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     You strip the flesh from a corporeal creature's
     body. Each round, the target suffers pain and
     psychological trauma that undermines the spirit.
     The assault deals 2d6 points of damage and 1d6
     points of temporary Charisma and Constitution
     damage.  A fort save negates the ability damage
     and reduces the physical damage by half.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 5, 2003
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(4) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = 2;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iChaDmg;
    int     iConDmg;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
    iDamage = HkApplyMetamagicVariableMods( d6(2), 12 );
    iChaDmg = HkApplyMetamagicVariableMods( d6(1), 6 );
	iConDmg = HkApplyMetamagicVariableMods( d6(1), 6 );
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE=EffectAreaOfEffect(AOE_MOB_FLENSING, "", "", "", sAOETag);
    effect eImp=EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eVis=EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM);
    effect eDamage;
    effect eLink;
    effect eCha=EffectAbilityDecrease(ABILITY_CHARISMA, iChaDmg);
    effect eCon=EffectAbilityDecrease(ABILITY_CONSTITUTION, iConDmg);
    effect eAbilityLink=EffectLinkEffects(eCha, eCon);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FLENSING));
    if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && !CSLGetIsIncorporeal(oTarget) )
    {
        if(!HkResistSpell(oCaster, oTarget))
        {
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
			
			
			int iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster);
			iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, iSave );
			int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, iSave );
			if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
			{
				if( iDamage > 0 )
				{
					eLink=EffectLinkEffects(eVis,EffectDamage(iDamage));
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				}
			
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbilityLink, oTarget, fDuration);
				}
			}
			
			
			/*
			int nSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC);
			iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORFULLDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster, nSave );
            if(!nSave)
            {
                eDamage=EffectDamage(iDamage);
                eLink=EffectLinkEffects(eDamage,eVis);
                if( iDamage > 0 )
				{
                	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                }
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAbilityLink, oTarget, fDuration);
            }
            else
            {
				eDamage=HkEffectDamage(iDamage);
				eLink=EffectLinkEffects(eDamage, eVis);
				if( iDamage > 0 )
				{
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
				}
            }
            */
        }
    }

    HkPostCast(oCaster);
}


