//::///////////////////////////////////////////////
//:: Minor Shapechange
//:: cmi_s2_mnrshape
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 22, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 

int GetPolyReserveLevel()
{

	if (GetHasSpell(161)) //Level 9
		return 9;
	if (GetHasSpell(184)) //Level 6
		return 6;	
	if (GetHasSpell(130)) //Level 4
		return 4;
	if (GetHasFeat(305))
		return 9;			
																		
	return 0;
}

void main()
{	
	//scSpellMetaData = SCMeta_FT_minorshapesh();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
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
	int nReserveLevel = 0;	
	
	nReserveLevel = GetPolyReserveLevel();
		 
	if (nReserveLevel == 0)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");	
	}
	else
	{
		
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  OBJECT_SELF, SPELLABILITY_Minor_Shapeshift );
		
						
	
		if (iSpellId == SPELLABILITY_Minor_Shapeshift || iSpellId == SPELLABILITY_Minor_Shapeshift_Might)
		{
			effect eMight = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_MAGICAL);
			eMight = SetEffectSpellId(eMight, SPELLABILITY_Minor_Shapeshift);
			eMight = SupernaturalEffect(eMight);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMight, OBJECT_SELF, RoundsToSeconds(nReserveLevel));		
		}
		else
		if (iSpellId == SPELLABILITY_Minor_Shapeshift_Speed)
		{
			effect eSpeed = EffectMovementSpeedIncrease(25);
			eSpeed = SetEffectSpellId(eSpeed, SPELLABILITY_Minor_Shapeshift);
			eSpeed = SupernaturalEffect(eSpeed);			
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, OBJECT_SELF, RoundsToSeconds(nReserveLevel));			
		}		
		else
		if (iSpellId == SPELLABILITY_Minor_Shapeshift_Vigor)
		{
			effect eVigor = EffectBonusHitpoints(GetHitDice(OBJECT_SELF));
			eVigor = SetEffectSpellId(eVigor, SPELLABILITY_Minor_Shapeshift);
			eVigor = SupernaturalEffect(eVigor);			
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVigor, OBJECT_SELF, RoundsToSeconds(nReserveLevel));			
		}
		
		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	
		//Fire cast spell at event for the specified target
		SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));			

		//Apply the effects
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
		
	}			


	HkPostCast(oCaster);
}