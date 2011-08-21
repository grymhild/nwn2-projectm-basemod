//::///////////////////////////////////////////////
//:: Combust
//:: X2_S0_Combust
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The initial eruption of flame causes  2d6 fire damage +1
	point per caster level(maximum +10)
	with no saving throw.

	Further, the creature must make
	a Reflex save or catch fire taking a further 1d6 points
	of damage. This will continue until the Reflex save is
	made.

	There is an undocumented artificial limit of
	10 + casterlevel rounds on this spell to prevent
	it from running indefinitly when used against
	fire resistant creatures with bad saving throws

*/
//:://////////////////////////////////////////////
// Created: 2003/09/05 Georg Zoeller
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
// Modified: 8/16/06 - BDF-OEI: updated the target validity check
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Evocation"

void RunCombustImpact(object oTarget, object oCaster, int iDamageType, int iSpellPower, int iMetaMagic)
{
	//--------------------------------------------------------------------------
	// Check if the spell has expired (check also removes effects)
	//--------------------------------------------------------------------------
	if (CSLGetDelayedSpellEffectsExpired(SPELL_COMBUST,oTarget,oCaster))
	{
			return;
	}

	if (GetIsDead(oTarget) == FALSE)
	{

		int iDC = GetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));

		if(!HkSavingThrow( SAVING_THROW_REFLEX, oTarget, iDC, CSLGetSaveTypeByDamageType(iDamageType) ))
		{
			//------------------------------------------------------------------
			// Calculate the damage, 1d6 + casterlevel, capped at +10
			//------------------------------------------------------------------
			int iDamage = HkApplyMetamagicVariableMods(d6(2)+iSpellPower, 6 * 2 + iSpellPower, iMetaMagic);

			effect eDmg = EffectDamage(iDamage,iDamageType);
			effect eVFX = EffectVisualEffect(CSLGetHitEffectByDamageType(iDamageType));

			HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVFX,oTarget);

			//------------------------------------------------------------------
			// After six seconds (1 round), check damage again
			//------------------------------------------------------------------
			DelayCommand(6.0f,RunCombustImpact(oTarget,oCaster, iDamageType, iSpellPower,iMetaMagic));
		}
		else
		{
			DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST));
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_COMBUST );
		}

	}

}

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_COMBUST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int iMetaMagic = GetMetaMagicFeat();
	int iDC = HkGetSpellSaveDC();
	int iSpellPower = HkGetSpellPower( OBJECT_SELF, 10 ); // OldGetCasterLevel(OBJECT_SELF);
	int iDamage = HkApplyMetamagicVariableMods(d6(2)+iSpellPower, 6 * 2 + iSpellPower);
	int iDuration = 10 + HkGetSpellDuration( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_FIRE, SC_SHAPE_CONTDAMAGE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDam = HkEffectDamage(iDamage, iDamageType);
	effect eVis = EffectVisualEffect(iHitEffect);
	effect eVis2 = EffectVisualEffect(iShapeEffect);
	effect eHit = EffectLinkEffects(eDam, eVis);

	//if(!GetIsReactionTypeFriendly(oTarget)) // BDF: obsolete conditional
	if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) )
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE));
		//-----------------------------------------------------------------------
		// Check SR
		//-----------------------------------------------------------------------
		if(!HkResistSpell(OBJECT_SELF, oTarget))
		{
			//------------------------------------------------------------------
			// This spell no longer stacks. If there is one of that type,
			// that's enough
			//------------------------------------------------------------------
			if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_INFERNO,oTarget)  )
			{
				FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
				return;
			}
		
			//-------------------------------------------------------------------
			// Apply VFX
			//-------------------------------------------------------------------
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
			TLVFXPillar(VFX_HIT_SPELL_EVOCATION, GetLocation(oTarget), 5, 0.1f,0.0f, 2.0f);
			
			//------------------------------------------------------------------
			// Save the spell save DC as a variable for later retrieval
			//------------------------------------------------------------------
			SetLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (SPELL_COMBUST), iDC);
			
			//------------------------------------------------------------------
			// Tick damage after 6 seconds again
			//------------------------------------------------------------------
			DelayCommand(6.0, RunCombustImpact( oTarget, oCaster, iDamageType, iSpellPower, iMetaMagic) );
		}
	}
	HkPostCast(oCaster);
}