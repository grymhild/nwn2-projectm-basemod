//::///////////////////////////////////////////////
//:: Drown, Mass
//:: NX_s0_massdrown.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Drown, Mass
	Conjuration (Creation) [Water]
	Level: Druid 9
	Components: V, S
	Range: Close
	Target: Any creature within 30 ft of the targeted area or creature.
	Saving Throw: Fortitude negates
	Spell Resistance: Yes
	
	You create water in the lungs of the subject,
	reducing it to 90% of its current hit points.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_msdrown();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_DROWN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_WATER, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nDam;
	effect eVis = EffectVisualEffect(VFX_HIT_DROWN);
	effect eDam;
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	location lTarget = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, 1019));
			//if(!HkResistSpell(oCaster, oTarget))
			//{
				if ( CSLGetIsDrownable(oTarget) )
				{
					if ( !HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()) )
					{
						nDam = FloatToInt(GetCurrentHitPoints(oTarget) * 0.9);
						eDam = HkEffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL, TRUE);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
						DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					}
				}
			//}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	HkPostCast(oCaster);
}

