//::///////////////////////////////////////////////
//:: Silence
//:: NW_S0_Silence.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target is surrounded by a zone of silence
	that allows them to move without sound.  Spell
	casters caught in this area will be unable to cast
	spells.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////

//const string SCSTRING_SILENCE = "EVENFLW_SILENCE";

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SILENCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ILLUSION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_GLAMER, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	effect eHit = EffectVisualEffect(VFX_DUR_SPELL_SILENCE);
	object oTarget = HkGetSpellTarget();
	location lTarget = HkGetSpellTargetLocation();
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( HkGetSpellDuration( oCaster ) ));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	effect eAOE = EffectVisualEffect( VFX_DUR_SPELL_SILENCE_AURA );
	eAOE = EffectLinkEffects(eAOE, EffectAreaOfEffect(AOE_MOB_SILENCE, "", "", "", sAOETag) );
	eAOE = SetEffectSpellId(eAOE, SPELL_SILENCE);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	
	if (GetIsObjectValid(oTarget)) // for when the spell is cast on a target
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE));
			if (!HkResistSpell(oCaster, oTarget)) {
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC())) {
					HkApplyEffectToObject(iDurType, eAOE, oTarget, fDuration);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
					SetLocalInt(oTarget,"EVENFLW_SILENCE", TRUE);
				}
			}
		}
		else
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE) {
				HkApplyEffectToObject(iDurType, eHit, oTarget, fDuration);
				HkApplyEffectToObject(iDurType, eAOE, oTarget, fDuration);
				SetLocalInt(oTarget, "EVENFLW_SILENCE", TRUE);
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE, FALSE));
			} else {
				lTarget = GetLocation(oTarget);
				HkApplyEffectAtLocation(iDurType, eAOE, lTarget, fDuration);        
			}
		}
	} else { // for when the spell is cast at a location
		DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	}
	
	HkPostCast(oCaster);
}

