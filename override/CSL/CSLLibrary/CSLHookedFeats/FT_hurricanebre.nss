//::///////////////////////////////////////////////
//:: Hurricane Breath
//:: cmi_s2_hurricbreath
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 11, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Reserve"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 

void main()
{	
	//scSpellMetaData = SCMeta_FT_hurricanebre();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iImpactSEF = VFX_HIT_AOE_EVOCATION;
	int iAttributes = SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();	
	int nDamageDice = CSLGetHighestLevelByDescriptor( SCMETA_DESCRIPTOR_AIR, oCaster );
	if (nDamageDice == -1)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");
		return;
	}
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{		
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TOUCH_OF_FATIGUE);
					
				effect eEffect = EffectKnockdown();
				
				int nKnockdownStrength = d20(1) + nDamageDice;
				
				int nEnemyStr = GetAbilityModifier(ABILITY_STRENGTH,oTarget);
				int nEnemyDex = GetAbilityModifier(ABILITY_DEXTERITY,oTarget);
				int nEnemyKDStrength;	
							
				if (nEnemyStr > nEnemyDex)
					nEnemyKDStrength = d20(1) + nEnemyStr;
				else
					nEnemyKDStrength = d20(1) + nEnemyDex;

				
				if (nKnockdownStrength > nEnemyKDStrength)
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));				
	
					//Apply the effects
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 6.0f);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  6.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
				}
		}	
	}			

	HkPostCast(oCaster);

}

