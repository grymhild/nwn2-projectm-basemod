//::///////////////////////////////////////////////
//:: Ice Storm
//:: NW_S0_IceStorm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Everyone in the area takes 3d6 Bludgeoning
	and 2d6 Cold damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_icestorm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ICE_STORM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nDamageBlud, nDamageCold;
	int iDice = iSpellPower/3;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_COLD );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	int iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_HUGE_COLD, SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); // note this does not return a visual effect ID, but an AOE ID for walls
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ICE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_COLD );
	
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	//int iDamageType = DAMAGE_TYPE_COLD;	
	//if ( GetHasFeat(FEAT_FROSTMAGE_PIERCING_COLD ) )
	//{
	//	iDamageType = DAMAGE_TYPE_MAGICAL;
	//}
	
	//if (DEBUGGING >= 6) { CSLDebug(  "Ice Storm Data: Class " + CSLGetClassesDataName( GetLastSpellCastClass() ) + " CasterLevel is " + IntToString( iSpellPower ) , oCaster ); }
	
	
	
		
	effect eVis = EffectVisualEffect( iHitEffect );
	location lTarget = HkGetSpellTargetLocation();
	
	//effect eCone  = EffectNWN2SpecialEffectFile( "sp_ice_cast", OBJECT_INVALID, GetPositionFromLocation( lTarget ) );
	//ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eCone, GetLocation( oCaster) );
	
	//effect eParticle = EffectNWN2SpecialEffectFile( "sp_ice_aoe" );
	ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect(iShapeEffect), lTarget );
		
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId ));
			if ( !HkResistSpell(oCaster, oTarget, 0.0) )
			{
				
				int nDamageBlud = HkApplyMetamagicVariableMods(d6(3), 18);
				int nDamageCold = HkApplyMetamagicVariableMods(d6(2 + iDice), 6 * (2 + iDice));
				
				DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamageBlud, DAMAGE_TYPE_BLUDGEONING), oTarget));
				DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDamageCold, iDamageType,DAMAGE_POWER_NORMAL,FALSE,oTarget,oCaster), oTarget));
				
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			}
		}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

