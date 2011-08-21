//::///////////////////////////////////////////////
//:: [Confusion]
//:: [NW_S0_Confusion.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures within a 15 foot radius must
//:: save or be confused for a number of rounds
//:: equal to the casters level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30 , 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_confusion();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CONFUSION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_AOE_ENCHANTMENT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	object oTarget;
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	
	//effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20); // NWN1 VFX
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT); // NWN1 VFX
	effect eConfuse = EffectConfused();
	effect eMind = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE); // NWN1 VFX
	float fDelay;
	//Link duration VFX and confusion effects
	effect eLink = EffectLinkEffects(eMind, eConfuse);
	//eLink = EffectLinkEffects(eLink, eDur); // NWN1 VFX

	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, HkGetSpellTargetLocation()); // NWN1 VFX
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONFUSION));
			fDelay = CSLRandomBetweenFloat();
			//Make SR Check and faction check
			if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
			{
				//Make Will Save
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
				{
					//Apply linked effect and VFX Impact
					iDuration = HkGetScaledDuration(HkGetSpellPower(OBJECT_SELF), oTarget);
					if (GetSpellId() == SPELL_CONFUSION && !GetIsObjectValid(GetSpellCastItem()) && GetLastSpellCastClass() == CLASS_TYPE_INVALID)
					{
						iDuration = HkGetScaledDuration(GetHitDice(OBJECT_SELF), oTarget);
					}
					float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
					int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
					
					DelayCommand(fDelay, HkApplyEffectToObject( iDurType, eLink, oTarget, fDuration ) );
					//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget)); // NWN1 VFX
				}
			}
		}
		//Get next target in the shape
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	}
	
	HkPostCast(oCaster);
}

