//::///////////////////////////////////////////////
//:: Calm Animals
//:: SG_S0_CalmAni.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     This spell soothes and quiets animals, beasts,
     and magical beasts, rendering them docile, and
     harmless.  Only creatures with an Intelligence
     of 1 or 2 are affected.  All subjects must be
     of the same species and with a 30' sphere.  Roll
     2d4 + caster level to determine number of HD
     affected.  Animals trained to attack or guard,
     dire animals, beasts, and magical beasts get
     saving throws.

     The affected creatures remain where they are and
     do not attack or flee.  They are not helpless and
     defend themselves normally if attacked.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 7, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
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
	int iSpellLevel = 1;
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
	//
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    int     iHDAffected     = 0;
    int iHDTotal = iCasterLevel+HkApplyMetamagicVariableMods( d4(2), 4 * 2 );
    
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eDaze    = EffectDazed();
    effect eDur     = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eImp     = EffectVisualEffect(VFX_FNF_LOS_NORMAL_30);
    effect eLink    = EffectLinkEffects(eDaze, eDur);
	
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp, lTarget);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    while(GetIsObjectValid(oTarget) && (iHDAffected<iHDTotal))
    {
        if((CSLGetIsAnimalOrBeast(oTarget)) && GetAbilityScore(oTarget,ABILITY_INTELLIGENCE)<=3)
        {

                SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CALM_ANIMALS));
                if(!HkResistSpell(oCaster, oTarget))
                {
                    if((CSLGetIsAnimal(oTarget) || CSLGetIsVermin(oTarget)) &&
                        !((FindSubString(GetName(oTarget),"Dire")!=-1) || (FindSubString(GetName(oTarget),"Winter")!=-1)
                        || (FindSubString(GetName(oTarget),"Malar")!=-1) && GetMaster(oTarget)==OBJECT_INVALID)) {

                            iHDAffected += GetHitDice(oTarget);
                            if(iHDAffected<=iHDTotal) {
                                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                                SetIsTemporaryNeutral(oTarget, oCaster, FALSE, fDuration);
                            } else {
                                iHDAffected-=GetHitDice(oTarget);
                            }

                    }
                    else if(WillSave(oTarget,HkGetSpellSaveDC(oCaster, oTarget), SAVING_THROW_TYPE_MIND_SPELLS)==0)
                    {
                        iHDAffected += GetHitDice(oTarget);
                        if(iHDAffected<=iHDTotal) {
                            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDuration);
                            SetIsTemporaryNeutral(oTarget, oCaster, FALSE, fDuration);
                        }
                        else 
                        {
                            iHDAffected-=iHDTotal;
                        }
                    }
                }
        } 
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
    }

    HkPostCast(oCaster);
}


