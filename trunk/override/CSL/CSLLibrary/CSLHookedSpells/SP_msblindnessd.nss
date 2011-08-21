//::///////////////////////////////////////////////
//:: Mass Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: Update Pass By: Preston W, On: Aug 2, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_msblindnessd();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_BLINDNESS_AND_DEAFNESS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_NECROMANCY;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	effect eBlind =  EffectBlindness();
	effect eDeaf = EffectDeaf();
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); // NWN1 VFX
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_BLIND_DEAF ); // NWN2 VFX

	//Link the blindness and deafness effects
	effect eLink = EffectLinkEffects(eBlind, eDeaf);
	eLink = EffectLinkEffects(eLink, eDur);
	//effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M); // NWN1 VFX
	//effect eXpl = EffectVisualEffect(VFX_FNF_BLINDDEAF); // NWN1 VFX
	//Check for metamagic extend
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	//Play area impact VFX
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eXpl, HkGetSpellTargetLocation()); // NWN1 VFX
	//Get the first target in the spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_BLINDNESS_AND_DEAFNESS));
			//Make SR check
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Make Fort save
				if (!/*Fort Save*/ HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
				{
					//Apply the linked effects and the VFX impact
					HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
					//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget); // NWN1 VFX
				}
			}
		}
		//Get next object in spell area
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	}
	
	HkPostCast(oCaster);
}

