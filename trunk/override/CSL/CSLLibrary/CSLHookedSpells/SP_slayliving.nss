//::///////////////////////////////////////////////
//:: [Slay Living]
//:: [NW_S0_SlayLive.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Caster makes a touch attack and if the target
//:: fails a Fortitude save they die.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: January 22nd / 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: June 25, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_slayliving();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SLAY_LIVING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE|SCMETA_DESCRIPTOR_DEATH, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDamage;
	
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_DEATH );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	

	effect eDam;
	effect eVis = EffectVisualEffect(iHitEffect);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		if( CSLGetIsUndead( oTarget ) )
		{
			FloatingTextStrRefOnCreature(40105, oCaster, FALSE);
			return;
		}
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SLAY_LIVING));
		//Make melee touch attack
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			//Make SR check
			if(!HkResistSpell(oCaster, oTarget))
			{
				//Make Fort save
				int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_ALL, oCaster );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
				else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					//Roll damage
					iDamage = HkApplyMetamagicVariableMods(d6(3)+ iSpellPower, 18+ iSpellPower );

					//Apply damage effect and VFX impact
					eDam = HkEffectDamage(iDamage, iDamageType);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

