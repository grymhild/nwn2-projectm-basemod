//::///////////////////////////////////////////////
//:: Jaws of the Wolf
//:: sg_s0_jawswolf.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Transmutation
     Level: Drd 4
     Components: V, S
     Casting Time: 1 action
     Range: Close
     Effect: One or more created wolves
     Duration: 1 round/level
     Saving Throw: None
     Spell Resistance: No

     You turn small wooden carvings into wolves
     (one for every two caster levels) that appear
     next to you.  The wolves act on their own but
     obey your mental commands.  The wolves are
     normal in all respects except they have spell
     resistance 13 and the special ability of
     frightful presence.  At the end of the spell,
     the wolves become carvings again.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 5, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
// 
//
//     object  oTarget;         //= HkGetSpellTarget();
//     location lTarget        = GetLocation(oCaster);
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
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

    int     iNumWolves      = iCasterLevel/2;
    int     i;
    int     j;
    object  oWolf;
    
    if(iNumWolves>7) iNumWolves=7;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eSummon = EffectSummonCreature("csl_sum_celest_wolf",VFX_FNF_SUMMON_MONSTER_2,0.5f);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_JAWS_OF_THE_WOLF, FALSE));
    for(i=1; i<=iNumWolves; i++) {
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSummon, oCaster, fDuration);
        for(j=1; j<=i; j++) {
            oWolf = GetNearestObjectByTag("csl_sum_celest_wolf", oCaster, j);
            if(GetPlotFlag(oWolf)==FALSE) {
                SetPlotFlag(oWolf, TRUE);
            }
        }
    }
    for(i=1; i<=iNumWolves; i++) {
        oWolf = GetNearestObjectByTag("csl_sum_celest_wolf", oCaster, i);
        SetPlotFlag(oWolf,FALSE);
    }

    HkPostCast(oCaster);
}


