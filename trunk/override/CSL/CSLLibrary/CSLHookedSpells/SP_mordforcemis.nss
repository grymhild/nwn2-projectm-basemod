//::///////////////////////////////////////////////
//:: Mordenkainen's Force Missiles
//:: sg_s0_mordfmiss.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation [Force]
     Level: Sor/Wiz 4
     Components: V, S
     Casting Time: 1 action
     Range: Medium (100 ft. + 10 ft./level)
     Targets: Up to four creatures, no two of which can be more than 20 ft. apart
     Duration: Instantaneous
     Saving Throw: None or Reflex half (see text)
     Spell Resistance: Yes

     You create a powerful missile of magical force,
     which darts from your fingertips and unerringly
     strikes its target, dealing 2d6 points of damage.
     The missile then bursts in a 5-foot blast of force
     that inflicts half this amount of damage to any
     creatures in the area (other than the primary target).
     The primary target is not entitled to a saving throw
     against the burst, but creatures affected by the burst
     may attempt a Reflex save for half damage.

     If the missiles' burst areas overlap, secondary targets
     make only one saving throw attempt (and only one SR check,
     if applicable). A character can be struck by one missile
     (or more) and also be caught in the burst of another missile.
     In such a case, the character may attempt a Reflex save
     to halve the burst damage, and SR might apply.

     The missile strikes unerringly, even if the target is
     in melee or has anything less than total cover or concealment.
     A caster cannot single out specific parts of a creature.
     The spell can target and damage unattended objects.

     For every five caster levels, the caster gains one missile.
     A caster has two missiles at 9th level or lower, three
     missiles from 10th to 14th level, and four missiles at 15th
     level or higher. A caster can make more than one missile strike
     a single target, if desired. However, the caster must designate
     targets before rolling for SR or damage.

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On:
//:://////////////////////////////////////////////
//
// 
// void main()
// {
//
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
	
	location lTarget = GetLocation(oTarget);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = 2;
    int     iBonus          = 0;
    int     iDamage         = 0;

    float   fRadius         = FeetToMeters(5.0);
    int     iMissiles       = (iCasterLevel/5)+1;
    float   fDist           = GetDistanceBetween(oCaster, oTarget);
    float   fDelay          = fDist/(3.0 * log(fDist) + 2.0);
    float   fDelay2, fTime;
    object  oOrigTarget     = oTarget;
    int     iCount;
    int     iBurstDamage;
    int     iDmg;
    string  sSpellID        ="MFM_"+IntToString(GetTimeHour())+IntToString(GetTimeMinute())+IntToString(GetTimeSecond());

    if(iMissiles>4) iMissiles = 4;  // Limit to 4 missiles
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis     = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eVis2    = EffectVisualEffect(VFX_COM_HIT_FROST);
    effect eDam;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MORD_FORCE_MISSILE));
    for (iCount = 1; iCount <= iMissiles; iCount++)
    {
        iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice );
        iBurstDamage=iDamage/2;
        if(iBurstDamage<1) iBurstDamage=1;
        fTime = fDelay;
        fDelay2 += 0.1;
        fTime += fDelay2;
        eDam = EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
        if(!HkResistSpell(oCaster, oOrigTarget)) {
            DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oOrigTarget));
            DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oOrigTarget));
        }
        DelayCommand(fDelay2, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oOrigTarget));
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        while(GetIsObjectValid(oTarget)) {
            if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
                SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_MORD_FORCE_MISSILE));
                // CHECK AT BEGINNING IF RESISTED OR SAVED AS TARGET ONLY NEEDS TO DO THIS ONCE FOR BLAST DAMAGE
                if(iCount==1 || !GetLocalInt(oTarget,sSpellID+"_AFFECTED")) {
                    if(HkResistSpell(oCaster,oTarget,fTime)) {
                        SetLocalInt(oTarget,sSpellID+"_RESIST",TRUE);
                    } else {
                        SetLocalInt(oTarget,sSpellID+"_RESIST",FALSE);
                    }
                    iDmg=HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iBurstDamage,oTarget,iDC);
                    if(iDmg<iBurstDamage) {
                        SetLocalInt(oTarget,sSpellID+"_SAVED",TRUE);
                    } else {
                        SetLocalInt(oTarget,sSpellID+"_SAVED",FALSE);
                    }
                    SetLocalInt(oTarget,sSpellID+"_AFFECTED",TRUE);
                }
                // APPLY BLAST DAMAGE EFFECTS
                if(!GetLocalInt(oTarget,sSpellID+"_RESIST") && oTarget!=oOrigTarget) {
                    iDmg=iBurstDamage;
                    // Adjust Damage if saved & for evasion/improved evasion feats
                    if(GetLocalInt(oTarget,sSpellID+"_SAVED")) {
                        if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION,oTarget)) {
                            iDmg=0;
                        } else {
                            iDmg=iBurstDamage/2;
                        }
                    } else if(GetHasFeat(FEAT_IMPROVED_EVASION,oTarget)) {
                        iDmg=iBurstDamage/2;
                    }

                    eDam=EffectDamage(iDmg,DAMAGE_TYPE_MAGICAL);
                    if(iDmg>0) {
                        DelayCommand(fTime+fDelay2, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                        DelayCommand(fTime+fDelay2, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    }
                }

                // if last missile, delete local variables on target
                if(iCount==iMissiles) {
                    DeleteLocalInt(oTarget,sSpellID+"_AFFECTED");
                    DeleteLocalInt(oTarget,sSpellID+"_SAVED");
                    DeleteLocalInt(oTarget,sSpellID+"_RESIST");
                }
            }

            oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    HkPostCast(oCaster);
}


