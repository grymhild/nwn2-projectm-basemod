//::///////////////////////////////////////////////
//:: Reciprocal Gyre
//:: SP_reciprocalgy.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reciprocal Gyre
//:: Abjuration 
//:: Level: Sorcerer/wizard 5 
//:: Components: V, S, M 
//:: Casting Time: 1 standard action 
//:: Range: Medium (100 ft. + 10 ft./level) 
//:: Target: One creature or object 
//:: Duration: Instantaneous 
//:: Saving Throw: Will half, then 
//:: Fortitude negates; see text 
//:: Spell Resistance: No 
//:: 
//:: You finger the tiny loop of wire in your hands as you
//:: complete the spell. You manipulate the magical aura of
//:: the target, creating a damaging feedback reaction, and
//:: the target explodes with white sparks.
//:: 
//:: The subject takes 1d12 points of damage per functioning
//:: spell or spell-like ability currently affecting it
//:: (maximum 25d12).
//:: 
//:: In addition, any creature so affected that fails its
//:: Will save must then succeed on a Fortitude save or be
//:: dazed for 1d6 rounds.
//:: 
//:: Only spells specifically targeted on the creature in
//:: question can be used to create the backlash of a
//:: reciprocal gyre, so spells that affect an area can't be
//:: used to deal reciprocal damage to creatures within
//:: their area. Likewise, persistent or continuous effects
//:: from magic items can't be used to deal reciprocal
//:: damage, but targeted spell effects can be.
//:: 
//:: Material Component: A tiny closed loop of copper wire.
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DISPEL_MAGIC;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ABJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	float   fDuration;
	effect eDaze = EffectLinkEffects( EffectDazed(), EffectCutsceneImmobilize() );	
	eDaze = EffectLinkEffects( eDaze, EffectVisualEffect( VFX_DUR_SPELL_DAZE ) );	
	int iSave, iAdjustedDamage, iDC;
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if (  GetIsObjectValid(oTarget)  )
	{
		int iDice = CSLCountEffectsOnTarget( oTarget, 1, 25 ); // 1 is beneficial, 25 limits the results pulled to 25 ( which lets it stop looking for them as well )
		
		if ( iDice < 1 )
		{
			SendMessageToPC( oCaster, "The Gyre Fizzled");
			return;
		}
				
		location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
		effect eImpactVis = EffectVisualEffect( iImpactSEF );
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
		
		//if (DEBUGGING >= 5) { CSLDebug( "----Damage of  " + IntToString( iDamage ), oCaster, oTarget); }
				
		iDC = HkGetSpellSaveDC();
		iSave = HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF);
		
		iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_WILL, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_SPELL, oCaster, iSave );
		if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
		{
			int iDamage = HkApplyMetamagicVariableMods( d12( iDice ), 12 * iDice );
			
			iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORPARTIALDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_SPELL, oCaster, iSave );
			effect eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
			
			
			effect eVis = EffectVisualEffect( VFX_IMP_DIVINE_STRIKE_HOLY );
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
			DelayCommand(0.5, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			
			if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
			{
				AssignCommand(oTarget, ClearAllActions() );
				CSLPlayCustomAnimation_Void(oTarget, "*whirlwind", 0);
				fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory( HkApplyMetamagicVariableMods( d6(), 6 ) ) );
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDuration);
			}
		}
	}
	HkPostCast(oCaster);	
}

