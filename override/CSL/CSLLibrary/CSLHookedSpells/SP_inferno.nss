//::///////////////////////////////////////////////
//:: Inferno
//:: x0_s0_inferno.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Does 2d6 fire per round
	Duration: 1 round per level
*/
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, 2003-Oct-19
//::            - VFX update
//::            - Spell no longer stacks with itself
//::            - Spell can now be dispelled
//::            - Spell is now much less cpu expensive


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void RunImpact(object oTarget, object oCaster, int iDamageType, int iMetaMagic)
{
	//--------------------------------------------------------------------------
	// Check if the spell has expired (check also removes effects)
	//--------------------------------------------------------------------------
	if (CSLGetDelayedSpellEffectsExpired(446,oTarget,oCaster))
	{
		return;
	}

	if (GetIsDead(oTarget) == FALSE)
	{
		//----------------------------------------------------------------------
		// Calculate Damage
		//----------------------------------------------------------------------
		int iDamage = HkApplyMetamagicVariableMods(d6(2), 6);
		effect eDam = HkEffectDamage(iDamage, iDamageType);
		effect eVis = EffectVisualEffect( CSLGetHitEffectByDamageType(iDamageType) );
		eDam = EffectLinkEffects(eVis,eDam); // flare up
		HkApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
		DelayCommand(6.0f,RunImpact( oTarget, oCaster, iDamageType, iMetaMagic));
	}
	
	HkPostCast(oCaster);
}



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_INFERNO;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	object oTarget = HkGetSpellTarget();

	int iMetaMagic = HkGetMetaMagicFeat();
	//--------------------------------------------------------------------------
	// This spell no longer stacks. If there is one of that type, thats ok
	//--------------------------------------------------------------------------
	if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_COMBUST,oTarget))
	{
			FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
			return;
	}

	//--------------------------------------------------------------------------
	// Calculate the duration
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_FIRE, SC_SHAPE_CONTDAMAGE ); 
	int iBeamEffect = HkGetShapeEffect( VFX_BEAM_FIRE, SC_SHAPE_BEAM );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	effect eRay = EffectBeam(iBeamEffect,OBJECT_SELF,BODY_NODE_CHEST);
	effect eBurn = EffectVisualEffect(iShapeEffect);


	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

	float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/13;
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			//----------------------------------------------------------------------
			// Engulf the target in flame
			//----------------------------------------------------------------------
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 3.0f);

			//----------------------------------------------------------------------
			// Apply the VFX that is used to track the spells duration
			//----------------------------------------------------------------------
			object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
			HkApplyEffectToObject(iDurType, eBurn, oTarget, fDuration );
			DelayCommand(fDelay+0.1f,RunImpact(oTarget, oSelf, iDamageType, iMetaMagic));
		}
	}
	else
	{
			//----------------------------------------------------------------------
			// Indicate Failure
			//----------------------------------------------------------------------
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0f);
	}

}