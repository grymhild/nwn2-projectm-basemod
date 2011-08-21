//::///////////////////////////////////////////////
//:: Protective Ward (Abjuration)
//:: cmi_s2_protward
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 5, 2009
//:: Your connection to the divine principle of protection shields you or an ally from attacks.
//:: Prerequisite: Access to the Protection domain. Benefit: As long as you have a abjuration spell of
//:: 2nd level or higher available to cast, you can use a standard action to provide a sacred (or
//:: profane) bonus to AC equal to the level of the highest-level abjuration spell you have available to
//:: cast. You can apply this bonus either to your AC or to that of a single ally within 30 feet, and it
//:: persists until the beginning of your next turn. Secondary Benefit: You gain a +1 competence bonus to
//:: your caster level when casting abjuration spells.
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_spells"
#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"
#include "_SCInclude_Reserve"

/*
void ApplyACBuff(int iSpellId, object oCaster = OBJECT_SELF )
{
	int bRepeatBuff = 1;

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );
	
	int nReserveLevel = CSLGetHighestLevelByDescriptor( SCMETA_DESCRIPTOR_ENERGY, oCaster );
	if (nReserveLevel == -1)
	{
		bRepeatBuff = 0;
		SendMessageToPC(oCaster,"You do not have any valid spells left that can trigger this ability.");
		return;
	}

	if ( bRepeatBuff )
	{
		effect eACBuff = EffectACIncrease(nReserveLevel);
		eACBuff = SetEffectSpellId( eACBuff, iSpellId);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACBuff, oCaster, 12.0f);
		DelayCommand(12.0f, ApplyACBuff(iSpellId));
	}
}
*/


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SPELLABILITY_Protective_Ward;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}

	int nRanger = 1;
	int nRangerLevel = GetLevelByClass(CLASS_TYPE_RANGER);
	if (nRangerLevel > 23)
	{
		nRanger = 2;
	}
	
	effect eACBuff;

	if (nRangerLevel == GetHitDice(OBJECT_SELF))
	{
		eACBuff = EffectACIncrease(nRanger * 2);
		effect eABBuff = EffectAttackIncrease(nRanger);
		eACBuff = EffectLinkEffects(eABBuff, eACBuff);
	}
	else
	{
		eACBuff = EffectACIncrease(nRanger);
	}
	
	eACBuff = SetEffectSpellId(eACBuff,iSpellId);
	eACBuff = SupernaturalEffect(eACBuff);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, iSpellId );	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACBuff, oCaster, HoursToSeconds(48), iSpellId);
	
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	/*
	int nReserveLevel = 0;
	nReserveLevel = CSLGetHighestLevelByDescriptor( SCMETA_DESCRIPTOR_ENERGY, oCaster );
	if (nReserveLevel == -1)
	{
		SendMessageToPC(oCaster,"You do not have any valid spells left that can trigger this ability.");
		return;
	}
	
	

	

	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);

	//Fire cast spell at event for the specified target
	SignalEvent(OBJECT_SELF, EventSpellCastAt(oCaster, iSpellId, FALSE));

	DelayCommand(0.1f,	ApplyACBuff( iSpellId, oCaster ) );

	//Apply the effects
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

	*/
	HkPostCast(oCaster);

}