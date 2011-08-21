//::///////////////////////////////////////////////
//:: Corpse Visage
//:: sg_s0_corpvis.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Illusion
     Level: Sor/Wiz 1
     Components: V, S
     Casting Time: 1 action
     Range: Touch
     Target: One creature
     Duration: 1 round/caster level
     Saving Throw: Will negates
     Spell Resistance: Yes

     This spell transforms your face or the face of
     any creature touched by you into a horrifying
     visage of a rotting corpse.  Creatures with
     Intelligence 5 or higher and with 1 Hit Die or
     less (or who are 1st level or lower) must make
     a successful Will saving throw when first viewing
     the corpse visage or flee in terror for 1-4 rounds.

     Corpse Visage does not distinguish between friend
     and foe, and all who view it are subject to its
     effects.  If the spell is cast upon an unwilling
     victim, the victim is allowed a Will saving throw
     to avoid the effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: June 3, 2004
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis  = EffectVisualEffect(VFX_IMP_DOMINATE_S);  // Visible impact effect
    effect eAOE     = EffectAreaOfEffect(AOE_MOB_CORPSE_VISAGE, "", "", "", sAOETag);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if(CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_ALLALLIES, oCaster))
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CORPSE_VISAGE, FALSE));
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
    }
    else
    {
        if(!HkResistSpell(oCaster, oTarget))
        {
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CORPSE_VISAGE));
            if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
            {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oTarget, fDuration);
            }
        }
    }
	
    HkPostCast(oCaster);
}


