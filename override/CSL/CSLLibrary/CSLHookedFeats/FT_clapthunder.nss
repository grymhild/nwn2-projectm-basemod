//::///////////////////////////////////////////////
//:: Clap of Thunder
//:: cmi_s2_clapthunder
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 11, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
//#include "_SCInclude_Class"
#include "_SCInclude_Reserve"

void main()
{	
	//scSpellMetaData = SCMeta_FT_clapthunder();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	
	int nDamageDice = CSLGetHighestLevelByDescriptor( SCMETA_DESCRIPTOR_SONIC, oCaster );
	if (nDamageDice == -1)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");
		return;
	}
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	int iImpactEffect = HkGetShapeEffect( VFXSC_FNF_BURST_SMALL_SONIC, SC_SHAPE_AOEEXPLODE, oCaster, RADIUS_SIZE_SMALL ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{		
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_SONIC);
			
			int nMeleeTouch = CSLTouchAttackMelee(oTarget);
			if (nMeleeTouch != TOUCH_ATTACK_RESULT_MISS)
			{
				int iDamage = SCGetReserveFeatDamage( nDamageDice, 6);
				iDamage = HkApplyTouchAttackCriticalDamage( oTarget, nMeleeTouch, iDamage, SC_TOUCHSPELL_MELEE, OBJECT_SELF );
				
				if ( GetHasSpellEffect(FEAT_LYRIC_THAUM_SONIC_MIGHT,oCaster) && CSLGetPreferenceSwitch("SonicMightAffectsClapofThunder",FALSE)  )
				{
					iDamage += d6(nDamageDice);
				}
				
				/*
				if (GetHasFeat(2991,OBJECT_SELF,TRUE))
					iDamage += 2;	
				if (nMeleeTouch == TOUCH_ATTACK_RESULT_CRITICAL)
					iDamage = iDamage * 2;
										
				//include sneak attack damage
				if (UseSneakAttackForSpells())
					iDamage += EvaluateSneakAttack(oTarget, OBJECT_SELF);
				*/				
				effect eDamage = HkEffectDamage(iDamage,iDamageType);
				
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));				

				//Apply the effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				
				int iDC = GetReserveSpellSaveDC(nDamageDice,OBJECT_SELF);
				effect eStatusEffect = EffectDeaf();	
                if  (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType))
                {
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStatusEffect, oTarget, 6.0f);
				}
			}
		}	
	}			

	HkPostCast(oCaster);
}

