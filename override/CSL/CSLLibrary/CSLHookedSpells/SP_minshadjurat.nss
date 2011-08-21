//::///////////////////////////////////////////////
//:: Shadow Conjuration
//:: NW_S0_ShadConj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the opponent is clicked on Shadow Bolt is cast.
    If the caster clicks on himself he will cast
    Mage Armor and Mirror Image.  If they click on
    the ground they will summon a Shadow.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001
//
void ShadowBolt (object oTarget, int iMetamagic);

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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_SHADOW, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iSpellVersion;
	int iDurationCategory = SC_DURCATEGORY_HOURS;
	
	
	
    if( GetIsObjectValid(oTarget) )
    {
        if(oTarget == oCaster)
        {
            iSpellVersion = 1;
            int iDurationCategory = SC_DURCATEGORY_HOURS;
        }
        else
        {
            iSpellVersion = 2;
        }
    }
    else
    {
        iSpellVersion = 3;
    }
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, iDurationCategory) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
   	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	

    effect eVis;
    effect eAC;
    effect eSummon;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    switch(iSpellVersion)
    {
        case 1:
            eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
            eAC = EffectACIncrease(4, AC_NATURAL_BONUS);
            //effect eMirror = EffectVisualEffect(VFX_DUR_MIRROR_IMAGE);
            HkApplyEffectToObject(iDurType, eAC, oCaster, fDuration);
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster);
            break;
        case 2:
           if(!HkResistSpell(oCaster, oTarget))
           {
              ShadowBolt(oTarget, HkGetMetaMagicFeat());
           }
           break;
        case 3:
           eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
           eSummon = EffectSummonCreature("csl_sum_shadow_shadow3");
           HkApplyEffectAtLocation(iDurType, eSummon, lTarget, fDuration);
           HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
    }

    HkPostCast();
}


void ShadowBolt (object oTarget, int iMetamagic)
{
    int iDamage;
    int iBolts = HkGetSpellPower(OBJECT_SELF)/5;
    int iCnt;
    int iDC = HkGetSpellSaveDC(OBJECT_SELF, oTarget);
    effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);

    for (iCnt = 0; iCnt < iBolts; iCnt++)
    {
        iDamage = HkApplyMetamagicVariableMods( d6(4), 6 * 4 );
        iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC);
        if(HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
        {
            iDamage = FloatToInt(iDamage*0.60); // will disbelief does 60% damage
        }
        effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE);
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        if(iDamage>0)
        {
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
    }
}


