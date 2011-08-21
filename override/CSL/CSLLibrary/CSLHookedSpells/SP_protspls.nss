//::///////////////////////////////////////////////
//:: Protection  from Spells
//:: NW_S0_PrChaos.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants the caster and up to 1 target per 4
	levels a +8 saving throw bonus versus spells
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: June 27, 2001
//:://////////////////////////////////////////////
//:: PKM-OEI 07.25.06 Update to use the CSLSpellsIsTarget function


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_protspls();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PROTECTION_FROM_SPELLS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ABJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF;
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
	


	//Declare major variables
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	int nTargets = iDuration / 4;
	if(nTargets == 0)
	{
			nTargets = 1;
	}

	
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	object oTarget;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	
	//effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_PROTECTION);
	effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 8, SAVING_THROW_TYPE_SPELL);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_PROTECTION_FROM_SPELLS );
	//effect eDur2 = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
	effect eLink = EffectLinkEffects(eSave, eDur);
	//eLink = EffectLinkEffects(eLink, eDur2);

	float fDelay;
	//Get first target in spell area
	location lLoc = GetLocation(OBJECT_SELF);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE);
	while(GetIsObjectValid(oTarget) && (nTargets != 0))
	{
			if (CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF ))
		
			{
				fDelay = CSLRandomBetweenFloat();
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PROTECTION_FROM_SPELLS, FALSE));
				//Apply the VFX impact and effects
				//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				nTargets--;
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, FALSE);
	}
	//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF));
	DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration ));
	
	HkPostCast(oCaster);
}

