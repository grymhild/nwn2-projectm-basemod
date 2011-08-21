//::///////////////////////////////////////////////
//:: Earthquake
//:: X0_S0_Earthquake
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Ground shakes. 1d6 damage, max 10d6
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"
//#include "ginc_math"
////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_earthquake();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EARTHQUAKE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iImpactSEF = VFX_SPELL_HIT_EARTHQUAKE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_EARTH, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	
	//Move to precast hook
	//if (SCStoneCasterInTown(oCaster)) return;
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	location lTarget = HkGetSpellTargetLocation();
	int iDice = 10 + iSpellPower/3;
	int nSpellDC = HkGetSpellSaveDC();

	int iDamage;
	float fDelay;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	effect eShake = EffectVisualEffect(VFX_SCFNF_SCREEN_SHAKE2); // screen shake
	effect eQuake = EffectLinkEffects(eShake, EffectVisualEffect(VFX_SPELL_HIT_EARTHQUAKE));

	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_EVOCATION);
	effect eDam;

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, oCaster, 30.0);
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eQuake, lTarget, 30.0);
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && oTarget!=oCaster)
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_EARTHQUAKE));
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			if (ReflexSave(oTarget, nSpellDC)==SAVING_THROW_CHECK_FAILED)
			{
				DelayCommand(fDelay + CSLRandomUpToFloat(6.0), HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 6.0));
				if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
				{
					CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  fDelay, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
				}
			}
			if (GetCurrentAction(oTarget)==ACTION_CASTSPELL && !GetIsSkillSuccessful(oTarget, SKILL_CONCENTRATION, 9 + iSpellPower))
			{
				DelayCommand(fDelay + CSLRandomUpToFloat(6.0), HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellFailure(100), oTarget, 6.0));
			}
			
			iDamage = HkApplyMetamagicVariableMods(d6(iDice), 6*iDice);
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_ALL);
			if (iDamage > 0)
			{
				eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

