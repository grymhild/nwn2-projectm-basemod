//::///////////////////////////////////////////////
//:: Silence: On Enter
//:: NW_S0_SilenceA.nss
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
//const string EVENFLW_NOT_SILENCE_SCARED = "EVENFLW_NOT_SILENCE_SCARED";

// this seems to be included from nw_i0_generic.nss, need to look at it some more or just remove it
const string SCSTRING_SILENCE = "EVENFLW_SILENCE";


#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_silence(); //SPELL_SILENCE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_SILENCE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_GLAMER );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	// just to check to see if the vars i set are accesible
	if (DEBUGGING >= 6) { CSLDebug("AOE Level is "+IntToString( GetLocalInt(OBJECT_SELF, "SC_"+IntToString(GetSpellId())+"_SPELLLEVEL" ) ), GetEnteringObject() ); }
	
	
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_SILENCE);
	eLink = EffectLinkEffects(eLink, EffectSilence());
	eLink = EffectLinkEffects(eLink, EffectDamageResistance(DAMAGE_TYPE_SONIC, 9999,0));
	eLink = SetEffectSpellId(eLink, SPELL_SILENCE);
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		if (!GetIsInCombat(oTarget)) SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE));
		if ( !CSLGetPreferenceSwitch("SilenceUseResistSpell",FALSE) || !HkResistSpell(oCaster,oTarget) )
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(20));
		}
	}
	else
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(20));
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SILENCE, FALSE));
	}
	if (!GetLocalInt(oTarget, SCSTRING_SILENCE))
	{
		SetLocalObject(oTarget, SCSTRING_SILENCE, OBJECT_SELF);
	}
	else
	{
		SetLocalObject(oTarget, SCSTRING_SILENCE, OBJECT_INVALID);
	}
}