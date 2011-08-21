//::///////////////////////////////////////////////
//:: Rejuvination Cocoon
//:: nw_s0_rejuvcocoon.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	When you cast the spell, the rejuvination cocoon forms
	around the subject.  While inside the cocoon, the subject
	cannot move or act in any way.

	The cocoon heals the subject every second, restoring a
	number of hit points equal to the caster's level (maximum
	of 15/second).  It also immediately purges the subject of
	poison and disease effects, and makes the subject immune to
	similar effects for the duration.

	While enveloped in the cocoon, the subject has DR 10/-.  Once
	the damage reduction has absorbed damage equal to 10 per caster
	level, the cocoon is the destroyed.  Such destruction halts any
	health and protective effects offered by the cocoon.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




//#include "x0_i0_petrify"


void main()
{
	//scSpellMetaData = SCMeta_SP_rejuvenation();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REJUVENATION_COCOON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_HEALING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	object oTarget     = HkGetSpellTarget();
	int iCasterLevel     = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float  fDuration   = HkApplyMetamagicDurationMods(12.0);
	int    nDRLimit    = 10 * iCasterLevel;
	int    nRegen      = HkGetSpellPower( oCaster, 15 ); //CSLGetMin(15, iCasterLevel);
	
	//Link duration effects
	effect eLink = EffectVisualEffect( VFX_SPELL_DUR_COCOON );
	eLink = EffectLinkEffects( eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE) );
	eLink = EffectLinkEffects( eLink, EffectImmunity(IMMUNITY_TYPE_POISON) );
	eLink = EffectLinkEffects( eLink, EffectCutsceneImmobilize() );
	eLink = EffectLinkEffects( eLink, EffectDamageReduction(10, 0, nDRLimit, DR_TYPE_NONE) );
	eLink = EffectLinkEffects( eLink, EffectRegenerate(nRegen, 1.0) );
	eLink = EffectLinkEffects( eLink, EffectSpellFailure(100) );
	
	//Validate target
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			CSLRestore( oTarget, NEGEFFECT_POISON|NEGEFFECT_DISEASE|NEGEFFECT_ABILITY );
			HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
		}
	}
	
	HkPostCast(oCaster);
}

