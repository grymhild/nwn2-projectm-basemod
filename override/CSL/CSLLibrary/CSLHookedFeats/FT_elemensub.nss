//::///////////////////////////////////////////////
//:: Elemental Substitution
//:: sg_s0_elemsub.nss
//:: 2005 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
    For use in toggling elemental substitution on/off
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: June 24, 2005
//:://////////////////////////////////////////////
// #include "sg_inc_elements"
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
	int iAttributes = 0;
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
	int     iCurrentSubType = GetLocalInt(oCaster, "HKPERM_damagemodtype");
    int     iSetSubType;
    
    switch(iSpellId)
    {
        case SPELLABILITY_ELEMENTAL_SUBSTITUTION_ACID:
            iSetSubType = ELEMENTAL_SUBSTITUTION_TYPE_ACID;
            break;
        case SPELLABILITY_ELEMENTAL_SUBSTITUTION_COLD:
            iSetSubType = ELEMENTAL_SUBSTITUTION_TYPE_COLD;
            break;
        case SPELLABILITY_ELEMENTAL_SUBSTITUTION_ELECTRICITY:
            iSetSubType = ELEMENTAL_SUBSTITUTION_TYPE_ELECTRICITY;
            break;
        case SPELLABILITY_ELEMENTAL_SUBSTITUTION_FIRE:
            iSetSubType = ELEMENTAL_SUBSTITUTION_TYPE_FIRE;
            break;
        case SPELLABILITY_ELEMENTAL_SUBSTITUTION_SONIC:
            iSetSubType = ELEMENTAL_SUBSTITUTION_TYPE_SONIC;
            break;
    }
    
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


    //CSLAutoDebugString("Setting Elemental Substitution Type to "+ IntToString(iSpellId));
    if(iCurrentSubType==ELEMENTAL_SUBSTITUTION_TYPE_NONE || iCurrentSubType!=iSetSubType)
    {
        SetLocalInt(oCaster, "HKPERM_damagemodtype", iSetSubType);
        DelayCommand(HkApplyDurationCategory(1)*1.5, SetLocalInt(oCaster, "HKPERM_damagemodtype", ELEMENTAL_SUBSTITUTION_TYPE_NONE));
    }
    else
    {
        SetLocalInt(oCaster, "HKPERM_damagemodtype", ELEMENTAL_SUBSTITUTION_TYPE_NONE);
    }
    
}

