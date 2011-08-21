//::///////////////////////////////////////////////
//:: Wall of Iron
//:: LK_S0_WallIron.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a temporary wall of thick steel.
*/
//:://////////////////////////////////////////////
//:: Created By: Danmar - Lands of Kray
//:: Created On: 
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 20, 2001
//
//
//
// 
// void main()
// {
// 
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration  = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    effect eVis = EffectVisualEffect(VFX_DUR_GLOW_RED);
    effect eVis2 = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);

	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    object oWall = CreateObject(OBJECT_TYPE_PLACEABLE,"sp_wallofiron", CSLGetOffsetLocation(lTarget, 0.0f, 0.0f, -0.5f));
    SetLocalObject(oWall,"Caster",oCaster);
    DelayCommand(0.05,HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis2,oWall));
    DelayCommand(0.06,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oWall,1.0));
    DelayCommand(fDuration-2.0,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oWall,2.0));
    DestroyObject(oWall,fDuration);

    HkPostCast(oCaster);
}