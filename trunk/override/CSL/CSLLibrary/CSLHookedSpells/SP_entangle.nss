//::///////////////////////////////////////////////
//:: Entangle
//:: NW_S0_Enangle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Area of effect spell that places the entangled
	effect on enemies if they fail a saving throw
	each round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On:  Dec 12, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 31, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main() {

	
	//scSpellMetaData = SCMeta_SP_entangle();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ENTANGLE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_TRANSMUTATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	location lTarget = HkGetSpellTargetLocation();
	
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(3 + HkGetSpellDuration( oCaster ) / 2));
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE, "", "", "", sAOETag);
	
	int nDC = HkGetSpellSaveDC(); // this should handle getting the correct DC now
	//Has same SpellId as Entangle, not an item, but returns no valid class -> it's racial ability
	if ( GetSpellId() == SPELL_ENTANGLE && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
	{
		fDuration = RoundsToSeconds( 7 );	//CL4 -> 3 + 4/2 = 5
		nDC = 10 + 2 + GetAbilityModifier(ABILITY_CHARISMA, oCaster );
		
	}
	
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration);

	effect eLink = EffectVisualEffect(VFX_DUR_ENTANGLE);
	eLink = EffectLinkEffects(eLink, EffectEntangle());
	
	effect eSlow = EffectSlow();
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 6.1, lTarget );
	while (oTarget!=OBJECT_INVALID)
	{
		if (!CSLGetIsIncorporeal( oTarget ) ) // AFW-OEI 05/01/2006: Woodland Stride no longer protects from spells.
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ENTANGLE, TRUE ));
				if (!GetHasSpellEffect(SPELL_ENTANGLE, oTarget))
				{
					//if (!HkResistSpell(oCaster, oTarget))
					//{
						if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC ))
						{
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
						}
						else
						{
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(1));
						}
					//}
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.1, lTarget);
	}	
	HkPostCast(oCaster);
}

