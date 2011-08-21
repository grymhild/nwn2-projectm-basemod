//::///////////////////////////////////////////////
//:: Magic Stone
//:: sg_s0_magstone.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Transmutation
     Level: Clr 1, Earth 1
     Components: V, S
     Casting Time: 1 action
     Range: Touch
     Targets: Up to three stones touched
     Duration: 30 minutes or until discharged
     Saving Throw: None
     Spell Resistance: No

     You transmute up to three pebbles, which can be
     no larger than sling bullets, so that they strike
     with great force when used as sling bullets.
     This spell gives them a +1 enhancement bonus to
     attack and damage rolls.  Each stone that hits
     does 1d6+1 (including the bonus) of extra
     bludgeoning damage, aside from normal sling damage.
     Against undead, the damage increases to 2d6+2.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 11, 2004
//:://////////////////////////////////////////////
//
// #include "_CSLCore_Items"
// 
// void main()
// {
//
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//     //--------------------------------------------------------------------------
//     // Spellcast Hook Code
//     // Added 2003-06-20 by Georg
//     // If you want to make changes to all spells, check x2_inc_spellhook.nss to
//     // find out more
//     //--------------------------------------------------------------------------
//     if (!X2PreSpellCastCode())
//     {
//         return;
//     }
    // End of Spell Cast Hook
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(30, SC_DURCATEGORY_MINUTES) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
   
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis = EffectVisualEffect(VFX_IMP_DEATH); // = EffectVisualEffect();

    itemproperty ipEnhanceBonus     = ItemPropertyEnhancementBonus(1);
    itemproperty ipDamageBonus      = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);
    itemproperty ipUndEnhanceBonus  = ItemPropertyEnhancementBonusVsRace(RACIAL_TYPE_UNDEAD, 1);
    itemproperty ipUndDamageBonus   = ItemPropertyDamageBonusVsRace(RACIAL_TYPE_UNDEAD, IP_CONST_DAMAGETYPE_BLUDGEONING, IP_CONST_DAMAGEBONUS_1d6);
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	

    
     object oStone = CreateItemOnObject("magicstone", oCaster, 3);
    if(GetIsObjectValid(oStone))
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
        SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_MAGIC_STONE, FALSE));
        CSLSafeAddItemProperty(oStone, ipEnhanceBonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, TRUE);
        CSLSafeAddItemProperty(oStone, ipDamageBonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, TRUE);
        CSLSafeAddItemProperty(oStone, ipUndEnhanceBonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, TRUE);
        CSLSafeAddItemProperty(oStone, ipUndDamageBonus, fDuration, SC_IP_ADDPROP_POLICY_IGNORE_EXISTING, FALSE, TRUE);
    }
    else
    {
    	SendMessageToPC( oCaster, "Could not create stone" );
    }

    HkPostCast(oCaster);
}


