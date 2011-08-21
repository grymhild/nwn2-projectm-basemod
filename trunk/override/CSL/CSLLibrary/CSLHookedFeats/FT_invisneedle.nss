//::///////////////////////////////////////////////
//:: Invisible Needle
//:: cmi_s2_invisneedle
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 12, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"
#include "_SCInclude_Reserve"

void main()
{	
	//scSpellMetaData = SCMeta_FT_invisneedle();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iImpactSEF = VFXSC_HIT_HYPOTHERMIA;
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
	
	int nDamageDice = CSLGetHighestLevelByDescriptor( SCMETA_DESCRIPTOR_FORCE, oCaster );
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
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_CONJURATION);
			
			int iTouch = CSLTouchAttackRanged(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS)
			{
				int iDamage = SCGetReserveFeatDamage( nDamageDice, 4);
				iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, OBJECT_SELF );
				/*		
				if (GetHasFeat(2992,OBJECT_SELF,TRUE))
					iDamage += 2;	
				if (iTouch == TOUCH_ATTACK_RESULT_CRITICAL)
					iDamage = iDamage * 2;
					
				//include sneak attack damage
				if (UseSneakAttackForSpells())
					iDamage += EvaluateSneakAttack(oTarget, OBJECT_SELF);					
				*/			
				effect eDamage = EffectDamage(iDamage,DAMAGE_TYPE_MAGICAL);
				
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));				

				//Apply the effects
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
			
			}
		}	
	}			


	HkPostCast(oCaster);
}

