//::///////////////////////////////////////////////
//:: Smite (Destruction Domain Power)
//:: sg_s2_destsmite.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     You gain the smite power, the supernatural
     ability to make a single melee attack with a +4
     attack bonus and a damage bonus equal to your
     cleric level (if you hit).  You must declare the
     smite before making your attack.  It is usable
     once per day.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 9, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
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
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	

    int     iCasterLevel    = HkGetSpellPower(oCaster);
    object  oTarget         = HkGetSpellTarget();
    //location lTarget        = HkGetSpellTargetLocation();
    int     iDC             = HkGetSpellSaveDC(oCaster, oTarget);
    int     iMetamagic      = HkGetMetaMagicFeat();
    float   fDuration       = HkApplyDurationCategory(2);



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAttBonus    = EffectAttackIncrease(4,ATTACK_BONUS_ONHAND);
    effect eDmgBonus    = EffectDamageIncrease(iCasterLevel, DAMAGE_TYPE_DIVINE);
    effect eVis         = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eLink        = EffectLinkEffects(eAttBonus,eDmgBonus);
    
    if(iSpellId==SPELL_ORC_SMITE)
    {
        eLink = eDmgBonus;
        if(GetRacialType(oTarget)==RACIAL_TYPE_ELF || GetRacialType(oTarget)==RACIAL_TYPE_DWARF)
        {
            eLink = EffectLinkEffects(eLink, eAttBonus);
        }
    }
    
    eLink = EffectLinkEffects(eLink,eVis);
        
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oCaster,EventSpellCastAt(oCaster, GetSpellId(), FALSE));
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
    AssignCommand(oCaster,ClearAllActions(TRUE));
    DelayCommand(0.5, AssignCommand(oCaster,ActionAttack(oTarget)));

    HkPostCast(oCaster);
}


