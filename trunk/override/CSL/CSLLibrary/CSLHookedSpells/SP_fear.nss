//::///////////////////////////////////////////////
//:: [Fear]
//:: [NW_S0_Fear.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes an area of fear that reduces Will Saves
//:: and applies the frightened effect.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 23, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001

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
	int iSpellId = SPELL_FEAR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_NECROMANCY;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND|SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	int iCasterLevel = CSLGetMin(10, HkGetSpellPower(oCaster));
	
	//Has same SpellId as Fear, not an item, but returns no valid class -> it's Fiendish Presence
	if (GetSpellId() == SPELL_FEAR && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
	{
		iCasterLevel = GetHitDice(OBJECT_SELF);
	}
	
	
	
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(HkGetSpellDuration( oCaster )));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	effect eScary = CSLGetFearEffect(FALSE);
	location lTarget = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE); // | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while (GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster)) {
			float fDelay = CSLRandomBetweenFloat();
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
			if (!HkResistSpell(oCaster, oTarget, fDelay)) {
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_FEAR, OBJECT_SELF, fDelay)) {
					DelayCommand(fDelay, HkApplyEffectToObject(iDurType, eScary, oTarget, fDuration));
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE); // | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	
	HkPostCast(oCaster);
}

