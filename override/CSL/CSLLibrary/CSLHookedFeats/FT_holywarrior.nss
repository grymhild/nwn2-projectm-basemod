//::///////////////////////////////////////////////
//:: Holy Warrior
//:: cmi_s2_holywarrior
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 22, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
#include "_SCInclude_Class"
#include "_SCInclude_Reserve"


void ApplyDamageBuff(int iSpellId)
{
	int bRepeatBuff = 1;
	
	int nReserveLevel = GetWarReserveLevel();

	nReserveLevel = CSLGetMin( nReserveLevel, CSLGetPreferenceInteger("HolyWarriorCap",10) );
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  OBJECT_SELF, iSpellId );
		
	if (nReserveLevel == 0)
	{
		bRepeatBuff = 0;
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");	
	}
	
	int nDamageAmount = CSLGetDamageBonusConstantFromNumber(nReserveLevel, TRUE);
	
	if (bRepeatBuff)
	{
		effect eDmgBuff = EffectDamageIncrease(nDamageAmount, DAMAGE_TYPE_DIVINE);
		eDmgBuff = SetEffectSpellId(eDmgBuff,iSpellId);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmgBuff, OBJECT_SELF, 6.0f);
		DelayCommand(6.0f, ApplyDamageBuff(iSpellId));
	}
}

void main()
{	
	//scSpellMetaData = SCMeta_FT_holywarrior();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
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
	nReserveLevel = GetWarReserveLevel();
		 
	if (nReserveLevel == 0)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");	
	}
	else
	{
		
		effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);
	
		//Fire cast spell at event for the specified target
		SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));	
		
		DelayCommand(0.1f,	ApplyDamageBuff(iSpellId)); 		

		//Apply the effects
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
		
	}			

	HkPostCast(oCaster);

}