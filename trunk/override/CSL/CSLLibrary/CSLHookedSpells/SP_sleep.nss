//::///////////////////////////////////////////////
//:: Sleep
//:: NW_S0_Sleep
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Goes through the area and sleeps the lowest 2d4 HD of creatures first.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"






void main()
{
	//scSpellMetaData = SCMeta_SP_sleep();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SLEEP;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_ASN_Sleep )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	else if ( GetSpellId() == SPELLABILITY_SLEEP )
	{
		iClass = CLASS_TYPE_NONE;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster );
	effect eSleep =  EffectSleep();
	eSleep = SetEffectSpellId(eSleep, SPELL_SLEEP);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	int nMaxHD = HkApplyMetamagicVariableMods(5 + iSpellPower/2, 5 + iSpellPower/2);
	int iHD;
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(2 + iDuration/5));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lLocation = HkGetSpellTargetLocation();
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocation);
	while ( nMaxHD > 0 && GetIsObjectValid(oTarget) )
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && !CSLGetIsConstruct(oTarget) && !CSLGetIsUndead( oTarget ) )
		{
			iHD = GetHitDice(oTarget);
			if (iHD <= nMaxHD)
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
				nMaxHD -= iHD;
				if ( !HkResistSpell(oCaster, oTarget) )
				{
					if ( !HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS) )
					{
						if (!GetIsImmune(oTarget, IMMUNITY_TYPE_SLEEP))
						{
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						}
						HkApplyEffectToObject(iDurType, eSleep, oTarget, fDuration);// * even though I may be immune apply the sleep effect for the immunity message
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocation);
	}
	
	HkPostCast(oCaster);
}

