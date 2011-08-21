//::///////////////////////////////////////////////
//:: Name 	Solid Fog: On Enter
//:: FileName sp_solid_fogA.nss
//:://////////////////////////////////////////////
/**@file Solid Fog
Conjuration (Creation)
Level: Sor/Wiz 4, Hexblade 4
Components: V, S, M
Duration: 1 min./level
Spell Resistance: No

This spell functions like fog cloud, but in addition
to obscuring sight, the solid fog is so thick that
any creature attempting to move through it progresses
at a speed of 5 feet, regardless of its normal speed,
and it takes a -2 penalty on all melee attack and
melee damage rolls. The vapors prevent effective
ranged weapon attacks (except for magic rays and the
like). A creature or object that falls into solid fog
is slowed, so that each 10 feet of vapor that it
passes through reduces falling damage by 1d6. A
creature can't take a 5-foot step while in solid fog.

However, unlike normal fog, only a severe wind
(31+ mph) disperses these vapors, and it does so in
1 round.

Solid fog can be made permanent with a permanency
spell. A permanent solid fog dispersed by wind
reforms in 10 minutes.

Material Component: A pinch of dried, powdered peas
				combined with powdered animal hoof.
**/
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_SOLID_FOG;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 2;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();


	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eSlow = EffectMovementSpeedDecrease(80);
	effect eConceal = EffectConcealment(20, MISS_CHANCE_TYPE_VS_MELEE);
	effect eConceal2 = EffectConcealment(100, MISS_CHANCE_TYPE_VS_RANGED);
	effect eMiss = EffectMissChance(100, MISS_CHANCE_TYPE_VS_RANGED);
	effect eHitReduce = EffectAttackDecrease(2);
	effect eDamReduce = EffectDamageDecrease(2);

	// Link
	effect eLink = EffectLinkEffects(eConceal, eConceal2);
	eLink = EffectLinkEffects(eLink, eSlow);
	eLink = EffectLinkEffects(eLink, eMiss);
	eLink = EffectLinkEffects(eLink, eHitReduce);
	eLink = EffectLinkEffects(eLink, eDamReduce);	

	//Fire cast spell at event for the target
	SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_SOLID_FOG));

	// Maximum time possible. If its less, its simply cleaned up when the spell ends.
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, (60.0f * HkGetCasterLevel(GetAreaOfEffectCreator())));
}