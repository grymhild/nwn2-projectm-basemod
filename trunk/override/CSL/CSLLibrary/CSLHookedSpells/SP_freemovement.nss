//::///////////////////////////////////////////////
//:: Freedom of Movement
//:: NW_S0_FreeMove.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target creature gains immunity to the
	Entangle, Slow and Paralysis effects
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Magic"


void main()
{
	//scSpellMetaData = SCMeta_SP_freemovement();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FREEDOM_OF_MOVEMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	object oTarget = HkGetSpellTarget();
	
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(HkGetSpellDuration(oCaster)));
	effect eLink = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
	eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE));
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_FREEDOM_OF_MOVEMENT));
	eLink = SetEffectSpellId(eLink, SPELL_FREEDOM_OF_MOVEMENT);
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FREEDOM_OF_MOVEMENT, FALSE));
	
	// remove any existing slowing effects
	CSLRestore( oTarget, NEGEFFECT_MOVEMENT|NEGEFFECT_PETRIFY|NEGEFFECT_SLOWED );
	/*
	effect eLook = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eLook)) // Search for and remove negative effects
	{
		if ((GetEffectType(eLook)==EFFECT_TYPE_PARALYZE ||
				GetEffectType(eLook)==EFFECT_TYPE_ENTANGLE ||
				GetEffectType(eLook)==EFFECT_TYPE_SLOW ||
				GetEffectType(eLook)==EFFECT_TYPE_MOVEMENT_SPEED_DECREASE) &&
				GetEffectSpellId(eLook)!=SPELL_FOUNDATION_OF_STONE &&
				GetEffectSpellId(eLook)!=SPELL_TORTOISE_SHELL &&
				GetEffectSpellId(eLook)!=SPELL_STONE_BODY &&
				GetEffectSpellId(eLook)!=SPELL_IRON_BODY &&
				GetEffectSpellId(eLook)!=SPELL_BLADE_BARRIER_SELF) {
			RemoveEffect(oTarget, eLook);
		}
		eLook = GetNextEffect(oTarget);
	}
	*/
	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELL_FREEDOM_OF_MOVEMENT );
	
	HkPostCast(oCaster);
}

