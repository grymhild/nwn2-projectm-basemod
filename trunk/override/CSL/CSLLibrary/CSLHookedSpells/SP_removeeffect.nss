//::///////////////////////////////////////////////
//:: Remove Effects
//:: NW_SO_RemEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Takes the place of
		Remove Disease
		Neutralize Poison
		Remove Paralysis
		Remove Curse
		Remove Blindness / Deafness
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Magic"

void SCRemoveEffectsOnTarget( object oTarget, object oCaster, int iSpellId )
{
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE) );
	
	if ( iSpellId == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS)
	{
		if ( CSLRestore( oTarget, NEGEFFECT_PERCEPTION ) )
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_CONJURATION), oTarget);
		}
	}
	else if (iSpellId==SPELL_REMOVE_CURSE)
	{		
		if ( CSLRestore( oTarget, NEGEFFECT_CURSE ) )
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ABJURATION), oTarget);
		}
	}
	else if (iSpellId==SPELL_REMOVE_DISEASE || iSpellId==SPELLABILITY_REMOVE_DISEASE)
	{
		if ( CSLRestore( oTarget, NEGEFFECT_DISEASE|NEGEFFECT_ABILITY ) )
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_CONJURATION), oTarget);
		}
	}
	else if (iSpellId==SPELL_NEUTRALIZE_POISON)
	{
		if ( CSLRestore( oTarget, NEGEFFECT_POISON ) )
		{
			ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_M), oTarget);
		}
	}
}


void main()
{
	//scSpellMetaData = SCMeta_SP_removeeffect();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_REMOVE_DISEASE;
	int iSpellSchool = SPELL_SCHOOL_CONJURATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_HEALING;
	int iClass = CLASS_TYPE_NONE;
	int bAreaOfEffect = FALSE;
	int iImpactEffect = -1;
	if ( GetSpellId() == SPELL_NEUTRALIZE_POISON )
	{
		iSpellId = SPELL_NEUTRALIZE_POISON;
		iSpellSchool = SPELL_SCHOOL_CONJURATION;
		iSpellSubSchool = SPELL_SUBSCHOOL_HEALING;
	}
	else if ( GetSpellId() == SPELL_REMOVE_BLINDNESS_AND_DEAFNESS )
	{
		iSpellId = SPELL_REMOVE_BLINDNESS_AND_DEAFNESS;
		iSpellSchool = SPELL_SCHOOL_CONJURATION;
		iSpellSubSchool = SPELL_SUBSCHOOL_HEALING;
		
		bAreaOfEffect = TRUE;
		iImpactEffect = VFX_HIT_AOE_CONJURATION;
	}
	else if ( GetSpellId() == SPELL_REMOVE_CURSE )
	{
		iSpellId = SPELL_REMOVE_CURSE;
		iSpellSchool = SPELL_SCHOOL_ABJURATION;
	}
	else if ( GetSpellId() == SPELL_REMOVE_DISEASE )
	{
		iSpellId = SPELL_REMOVE_DISEASE;
		iSpellSchool = SPELL_SCHOOL_CONJURATION;
		iSpellSubSchool = SPELL_SUBSCHOOL_HEALING;
	}
	else if ( GetSpellId() == SPELLABILITY_REMOVE_DISEASE )
	{
		iSpellId = SPELLABILITY_REMOVE_DISEASE;
		iSpellSchool = SPELL_SCHOOL_EVOCATION;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//Declare major variables
	
	object oTarget;
	if (bAreaOfEffect)
	{
		float fDelay = 0.0;
		float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
		
		location lTargetLoc = HkGetSpellTargetLocation();
		if ( iImpactEffect > -1 )
		{
			effect eImpact = EffectVisualEffect(iImpactEffect);
			ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTargetLoc);
		}
		
		
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTargetLoc, FALSE, OBJECT_TYPE_CREATURE);
		while(GetIsObjectValid(oTarget))
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) )
			{
				fDelay = GetDistanceBetweenLocations(lTargetLoc, GetLocation(oTarget))/20;
				DelayCommand( fDelay, SCRemoveEffectsOnTarget( oTarget, oCaster, iSpellId ) );
				
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTargetLoc, FALSE, OBJECT_TYPE_CREATURE);
		}
	}
	else
	{
		oTarget = HkGetSpellTarget();
		SCRemoveEffectsOnTarget( oTarget, oCaster, iSpellId );
	}
	HkPostCast(oCaster);
}
