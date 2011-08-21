//::///////////////////////////////////////////////
//:: Repel Vermin
//:: sg_s0_repvermin.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Abjuration
     Level: Animal 4, Clr 4, Drd 4
     Casting Time: 1 action
     Range: 10 ft
     Area: 10 ft emanation centered on you
     Duration: 10 minutes/level
     Saving Throw: None or will negates (see text)
     Spell Resistance: Yes

     An invisible barrier holds back vermin. A vermin
     with less than 1/3 you level in HD cannot
     penetrate the barrier.  a vermin with at least
     1/3 your level in HD can penetrate the barrier
     on a successful Will Save.  Even so, crossing
     the barrier does 2d6 points of damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: July 29, 2003
//:://////////////////////////////////////////////
// 
// void main()
// {
// 
//
//     object  oTarget         = oCaster;
//
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
//     int     iMetamagic      = HkGetMetaMagicFeat();
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*10, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = 2;
    int     iBonus          = 0;
    int     iDamage         = 0;

    float   fRadius         = FeetToMeters(10.0);
    location lBehindLoc;
	int     iDC;  



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_REPEL_VERMIN, "", "", "", sAOETag);
    effect eImpact  = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
    effect eImp     = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect eVis     = EffectVisualEffect(VFX_IMP_HEAD_FIRE);
    effect eDamage;
    effect eLink;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oCaster, SPELL_REPEL_VERMIN );
    
    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_REPEL_VERMIN, FALSE));
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration);
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oCaster);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
    while(GetIsObjectValid(oTarget))
    {
        if(CSLGetIsVermin(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            if(!HkResistSpell(oCaster, oTarget))
            {
                iDC = HkGetSpellSaveDC(oCaster, oTarget);
                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_REPEL_VERMIN));
                if((GetHitDice(oTarget)<(iCasterLevel/3)) || (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC)))
                {
					lBehindLoc = CSLGenerateNewLocation(oTarget, SC_DISTANCE_SHORT, CSLGetOppositeDirection(GetFacing(oTarget)), GetFacing(oTarget));
					AssignCommand(oTarget,ClearAllActions(TRUE));
					AssignCommand(oTarget,JumpToLocation(lBehindLoc));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
                }
                else
                {
					iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice )+iBonus;
					eDamage = HkEffectDamage(iDamage);
					eLink = EffectLinkEffects(eDamage,eVis);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                }
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(oCaster));
    }
    HkPostCast(oCaster);
}


