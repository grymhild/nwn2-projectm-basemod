//::///////////////////////////////////////////////
//:: Wall of Iron
//:: LK_S0_WallIron.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a temporary wall of ice.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001
//
//#include "sg_inc_elements"
//
//
//
// 
// void main()
// {
//
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
    object  oWall = CreateObject(OBJECT_TYPE_PLACEABLE,"sp_wallofice",CSLGetOffsetLocation(lTarget, 0.0f, 0.0f, -0.5f));




    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_COLD);
    effect eVis = EffectVisualEffect(VFX_DUR_GLOW_BLUE);
    effect eVis2 = EffectVisualEffect(VFX_IMP_TORNADO);
    effect eAOE = EffectAreaOfEffect(AOE_PER_WALL_OF_ICE, "", "", "", sAOETag);

	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SetLocalObject(oWall,"Caster",oCaster);
    DelayCommand(0.05,HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis2,oWall));
    DelayCommand(0.06,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oWall,1.0));
    DelayCommand(0.5,HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eAOE,lTarget,fDuration));
    DelayCommand(fDuration-2.0,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oWall,2.0));
    DestroyObject(oWall,fDuration);

    HkPostCast(oCaster);
}


