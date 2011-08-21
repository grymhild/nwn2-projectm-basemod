//::///////////////////////////////////////////////
//:: Deep Slumber
//:: NW_S0_DeepSlmbr
//:://////////////////////////////////////////////
/*
	Goes through the area and sleeps the lowest 10+1d10 HD of creatures first.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"






void main()
{
	//scSpellMetaData = SCMeta_SP_deepslumber();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DEEP_SLUMBER;
	int iClass = CLASS_TYPE_NONE;
	if ( iSpellId == SPELL_ASN_Deep_Slumber )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	//Has same SpellId as Deep Slumber, not an item, but returns no valid class -> it's Fey Presence
	if (GetSpellId() == SPELL_DEEP_SLUMBER && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
	{
		iSpellPower = GetHitDice(OBJECT_SELF);
	}
	
	effect eSleep =  EffectSleep();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	int nMaxHD = HkApplyMetamagicVariableMods(10 + iSpellPower, 10 + iSpellPower);
	int iHD;
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(3 + HkGetSpellDuration( oCaster )/5));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lLocation = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocation);
	while (nMaxHD>0 && GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && !CSLGetIsConstruct(oTarget) && !CSLGetIsUndead( oTarget ) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
			iHD = GetHitDice(oTarget);
			if (iHD<=nMaxHD)
			{
				nMaxHD -= iHD;
				if (!HkResistSpell(oCaster, oTarget))
				{
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
					{
						if (!GetIsImmune(oTarget, IMMUNITY_TYPE_SLEEP)) HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						HkApplyEffectToObject(iDurType, eSleep, oTarget, fDuration);// * even though I may be immune apply the sleep effect for the immunity message
					}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocation);
	}
	
	HkPostCast(oCaster);
}

