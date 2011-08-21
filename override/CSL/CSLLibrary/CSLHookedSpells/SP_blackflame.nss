//::///////////////////////////////////////////////
//:: Blackflame
//:: sg_s0_blkflame.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    shadowy flames burst to life on one subject,
    causing dmg.  target must save each round throughout
    the duration of the spell.  Those failing a will save
    take no actions that round and are considered to be cowering.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 25, 2003
//::////////////////////////////////////////////// 
//
//
// 
// void main()
// {
//     
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	location lTarget = GetLocation(oTarget);
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	
	int     iDieType        = 10;
	int     iNumDice        = 1;
	int     iBonus          = 0;
	int     iDamage         = 0;
	
	string  sAfraid         = "Help me please! Help me! I'm burning!";
	
	
	
	iDamage = HkApplyMetamagicVariableMods( d10(iNumDice), 10 * iNumDice )+iBonus;
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eAOE     = EffectAreaOfEffect(AOE_MOB_BLACKFLAME, "****","sg_s0_blkflameb","****", sAOETag);
	eAOE = EffectLinkEffects(eAOE, EffectVisualEffect(VFXSC_DUR_FAERYAURA_NEGATIVE) );
	
	effect eDmg     = HkEffectDamage(iDamage,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_PLUS_FIVE);
	effect eVis     = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MAJOR);
	effect eImp     = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
	effect eCowerVis= EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
	
	effect eCower   = EffectLinkEffects( EffectFrightened(), EffectParalyze());
	eCower = EffectLinkEffects(eCowerVis,eCower);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
	if(!HkResistSpell(oCaster, oTarget))
	{
        SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_BLACKFLAME));
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);

        DelayCommand(0.2f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDuration));
        if(FortitudeSave(oTarget, iDC)==0)
        {
            HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
            if(WillSave(oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS)==0)
            {
                AssignCommand(oTarget,ClearAllActions());
                DelayCommand(0.2f,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCower, oTarget, HkApplyDurationCategory(1)));
                DelayCommand(0.5f,AssignCommand(oTarget,ActionSpeakString(sAfraid)));
            }
        }
    }

    HkPostCast(oCaster);
}


