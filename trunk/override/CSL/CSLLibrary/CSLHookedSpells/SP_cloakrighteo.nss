//::///////////////////////////////////////////////
//:: Cloak of Righteousness
//:: sg_s0_clkright.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     This spell creates a shining, white cloak/aura
     around the caster.  Foes seeing the aura must
     make a Fortitude save or be blinded for the
     remaining duration of the spell.  Allies seeing
     the aura are affected as if by a Bless spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 28, 2003
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
//     //int     iDieType        = 0;
//     //int     iNumDice        = 0;
//     //int     iBonus          = 0;
//     //int     iDamage         = 0;
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_GOOD, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, -1.0f, FALSE  );
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eAOE = EffectAreaOfEffect(AOE_MOB_CLOAK_RIGHT, "", "", "", sAOETag);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oCaster, SPELL_CLOAK_RIGHTEOUSNESS ) )
    {
        DeleteLocalInt(oCaster, "SG_L_CR_DUR");
    }

    SignalEvent(oCaster,EventSpellCastAt(oCaster, SPELL_CLOAK_RIGHTEOUSNESS, FALSE));
    HkApplyEffectToObject(iDurType, eAOE, oCaster, fDuration);
    SetLocalInt(oCaster,"SG_L_CR_DUR",iDuration);

    HkPostCast(oCaster);
}


