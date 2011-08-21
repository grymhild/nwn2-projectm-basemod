//::///////////////////////////////////////////////
//:: Scorching Ray
//:: [NX1_S0_scorchingraysingle.nss]
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
//:: Targets a single enemy and shoots up to 3
//:: rays of fire at them, each ray doing 4d6
//:: damage.  
//:: 1 ray at level 3, 2 rays at level 7, 3 rays at level 11.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SCORCHING_RAY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lTarget = HkGetSpellTargetLocation();
	int iSpellPower = HkGetSpellPower(oCaster, 10);
	int iSaveDC = HkGetSpellSaveDC();
	int iTargetShape = HkApplyShapeMods( SC_SHAPE_BEAM );
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_BEAM_FIRE, SC_SHAPE_BEAM );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	/////////////////////////////////////////////////////////////////////////////////
	
	location lCaster = GetLocation(oCaster);
	effect eRay = EffectBeam( iShapeEffect, oCaster, BODY_NODE_HAND);
	effect eVis = EffectVisualEffect( iHitEffect );
	
	effect eLink;
	int iDamage;
	
	int nNumRays = 0;
	if      (iSpellPower >=11) nNumRays = 3;        // 3 Rays @ lvl 11
	else if (iSpellPower >= 7) nNumRays = 2;        // 2 Rays @ lvl 7
	else if (iSpellPower >= 3) nNumRays = 1;        // 1 Ray  @ lvl 3
	if (nNumRays==0) return;
	
	object oTarget = HkGetSpellTarget();
	if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster) )
	{
		int nCnt=0;
		float fDelay = 0.75;
		int bMantle = HkHasSpellAbsorption(oTarget);
		if (bMantle) // has Spell Mantle, do MyResistSpell just once, plus visuals
		{
			int bResisted = FALSE;
			while (nCnt<nNumRays)
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
				if (iTouch!=TOUCH_ATTACK_RESULT_MISS && !bResisted)
				{
					HkResistSpell(oCaster, oTarget);
					bResisted = TRUE;
				}
				DelayCommand((fDelay-0.5), HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));
				nCnt++;
				fDelay+=1.6f;
			}
		}
		else
		{
			while (nCnt<nNumRays)
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
				if (iTouch!=TOUCH_ATTACK_RESULT_MISS) //Make SR check
				{  
					if ( !HkResistSpell(oCaster, oTarget))
					{  
						iDamage = HkApplyTouchAttackCriticalDamage(oTarget, iTouch, HkApplyMetamagicVariableMods( d6(4), 24, -1 ), SC_TOUCHSPELL_RAY );
						eLink = EffectLinkEffects(eVis, HkEffectDamage( iDamage, iDamageType ) );
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
					}
				}
				DelayCommand((fDelay-0.5), HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 0.5));
				nCnt++;
				fDelay+=1.6f;
			}        
		}
	}
	
	HkPostCast(oCaster);
}