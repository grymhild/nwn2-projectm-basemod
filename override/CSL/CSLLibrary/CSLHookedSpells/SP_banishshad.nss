//::///////////////////////////////////////////////
//:: Banish Shadow
//:: sg_s0_banshad.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Banish creature of plane of Shadow.  If creature
     makes a Will save, they still take 3d4 +1/lvl hp
     dmg (max bonus +10)
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 24, 2003
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
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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

	int     iDieType        = 4;
    int     iNumDice        = 3;
    int     iBonus          = iCasterLevel;
    int     iDamage         = 0;

    string  sTargetName     = GetStringLeft(GetName(oTarget),7);
    int     iAppearanceType = GetAppearanceType(oTarget);
    string sResRef = GetResRef(oTarget);
    
    if(iBonus>10) iBonus=10;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
    int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );

	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    iDamage = HkApplyMetamagicVariableMods( d4(iNumDice), 4 * iNumDice )+iBonus;

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFX_IMP_DISPEL);
    effect eDmg     = HkEffectDamage(iDamage,DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	
		
	
	
    if( sTargetName=="Shadow" || iAppearanceType==APPEAR_TYPE_DOG_SHADOW_MASTIF ||  iAppearanceType==APPEAR_TYPE_SHADOW ||  iAppearanceType==APPEAR_TYPE_SHADOW_REAVER ||  iAppearanceType==APPEAR_TYPE_NPC_KINGOFSHADOWS || CSLStringStartsWith(sResRef,"csl_sum_sh_elem_",FALSE) || CSLStringStartsWith(sResRef,"csl_sum_shadow_",FALSE) )
    {
        SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF, SPELL_BANISH_SHADOW));
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        if(!HkResistSpell(oCaster, oTarget))
        {
            if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
            {
                if(!GetIsPC(oTarget))
                {
                    DestroyObject(oTarget);
                }
                else
                {
                    // if is PC - kill them
                    eDmg = HkEffectDamage(GetCurrentHitPoints(oTarget), DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_PLUS_FIVE);
                    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
                }
            }
            else
            {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
            }
        }
    }

    HkPostCast(oCaster);
}


