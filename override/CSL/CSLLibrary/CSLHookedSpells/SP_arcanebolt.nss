//::///////////////////////////////////////////////
//:: Arcane Bolt
//:: sg_s0_arcbolt.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Evocation [Force]
Level: Sor/Wiz 1
Components: V, S
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Targets: One creature
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

A bolt of magical energy shoots forth from your fingertips
at its target, dealing 1d6+1 points of damage.

For every two levels of experience past 1st, you gain
an additional bolt, which you fire at the same time. You
have two at 3rd level, three at 5th level, four at 7th level,
and the maximum of five bolts at 9th level or higher.

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 6, 2004
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

    int     iDieType        = 6;
    int     iNumDice        = 1;
    int     iBonus          = 1;
    int     iDamage         = 0;

    int     iResist         = FALSE;
    int     iCnt;
    int     iMissiles       = 1+((iCasterLevel - 1)/2);
    float   fDist           = GetDistanceBetween(oCaster, oTarget);
    float   fDelay          = fDist/(3.0 * log(fDist) + 2.0);
    float   fDelay2         = 0.0;
    float   fTime;

    if(iMissiles>5) iMissiles=5;


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis     = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eDam;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ARCANE_BOLT));
    if(!HkResistSpell(oCaster, oTarget, fDelay))
    {
        for (iCnt = 1; iCnt <= iMissiles; iCnt++)
        {
            iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice )+iBonus;
            iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC);
            fTime = fDelay;
            fDelay2 += 0.1;
            fTime += fDelay2;

            if(iDamage>0)
            {
                eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
                DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
            }
            DelayCommand(fDelay2, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
         }
     }

    HkPostCast(oCaster);
}


