//::///////////////////////////////////////////////
//:: Battletide
//:: X2_S0_BattTideA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	You create an aura that steals energy from your
	enemies. Your enemies suffer a -2 circumstance
	penalty on saves, attack rolls, and damage rolls,
	once entering the aura. On casting, you gain a
	+2 circumstance bonus to your saves, attack rolls,
	and damage rolls.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Transmutation"





void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_BATTLETIDE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 5;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//Declare major variables
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster)) {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
		if (!HkResistSpell(GetAreaOfEffectCreator(), oTarget)) {
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NEGATIVE,OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
			{
				effect eLink = SCCreateBadTideEffectsLink();
				DelayCommand(CSLRandomBetweenFloat(0.75, 1.75), HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget));
			}
		}
	} else if(oTarget==oCaster) {
		SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	}
	
	HkPostCast(oCaster);
}