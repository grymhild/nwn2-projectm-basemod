//::///////////////////////////////////////////////
//:: Spirit Worm
//:: sg_s0_spworm.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Necromancy
     Level: Sor/Wiz 1
     Components: V, S
     Casting Time: 1 action
     Range: Touch
     Target: Living Creature Touched
     Duration: 1 round/level (see text)
     Saving throw: Fortitude partial
     Spell Resistance: Yes

     You create a lingering decay in the spirit and
     body of the target.  If the target fails is
     saving throw, it takes 1 point of temporary
     Constitution damage each round while the spell
     lasts (maximum 5 points of Constitution).  If
     it makes its save, it does not lose any
     Constitution but takes 1d2 points of damage each
     round while the spell lasts (maximum 5d2).  The
     damage remains after the spell ends.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: May 20, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     SGSetSpellInfo( );
// 
//
//
//
//
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
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	int iDuration = HkGetSpellDuration( oCaster, 5 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_SPIRIT_WORM, "", "", "", sAOETag);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SPIRIT_WORM));
    if(!HkResistSpell(oCaster, oTarget))
    {
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
    }

    HkPostCast(oCaster);
}


