//::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If the caster succeeds at a ranged touch attack
	the target takes 1d4 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: feb 4, 2001
//:://////////////////////////////////////////////
//:: Bug Fix: Andrew Nobbs, April 17, 2003
//:: Notes: Took out ranged attack roll.
//:://////////////////////////////////////////////
//:: AFW-OEI 06/06/2006:
//::	Pur ranged touch attack back in.
//::PKM-OEI: 05.28.07: Touch attacks now do critical hit damage
//:: 	- Modernized the metamagic behavior
//#include "NW_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"

/*

SPELL_RAY_OF_ACID
SPELL_RAY_OF_LIGHTNING
SPELL_RAY_OF_FIRE
*/

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ELEMENTAL_RAY;
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
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetSpellTargetObject();
	int nTouch 	= TouchAttackRanged(oTarget);


	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Enter Metamagic conditions
				int nDam = d4(1)+1;
				nDam = HkApplyMetamagicVariableMods(nDam, 5);

				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
				{
					nDam = d4(2)+1;
					nDam = HkApplyMetamagicVariableMods(nDam, 9);
				}

				//Set damage effect
				effect eDam = EffectDamage(nDam, DAMAGE_TYPE_ACID);
					effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);

				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}
	}

	effect eRay = EffectBeam(VFX_BEAM_ACID, OBJECT_SELF, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}

/*
acid
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
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
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetSpellTargetObject();
	int nTouch 	= TouchAttackRanged(oTarget);


	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Enter Metamagic conditions
				int nDam = d4(1)+1;
				nDam = HkApplyMetamagicVariableMods(nDam, 5);

				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
				{
					nDam = d4(2)+1;
					nDam = HkApplyMetamagicVariableMods(nDam, 9);
				}

				

				//Set damage effect
				effect eDam = EffectDamage(nDam, DAMAGE_TYPE_ACID);
					effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ACID);

				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}
	}

	effect eRay = EffectBeam(VFX_BEAM_ACID, OBJECT_SELF, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}

electric
void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
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
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetSpellTargetObject();
	int nTouch 	= TouchAttackRanged(oTarget);


	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Enter Metamagic conditions
				int nDam = d4(1)+1;
				nDam = HkApplyMetamagicVariableMods(nDam, 5);

				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
				{
					nDam = d4(2)+1;
					nDam = HkApplyMetamagicVariableMods(nDam, 9);
				}


				//Set damage effect
				effect eDam = EffectDamage(nDam, DAMAGE_TYPE_ELECTRICAL);
					effect eVis = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);

				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}
	}

	effect eRay = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}

fire
void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
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
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetSpellTargetObject();
	int nTouch 	= TouchAttackRanged(oTarget);


	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Enter Metamagic conditions
				int nDam = d4(1)+1;
				nDam = HkApplyMetamagicVariableMods(nDam, 5);

				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
				{
					nDam = d4(2)+1;
					nDam = HkApplyMetamagicVariableMods(nDam, 9);
				}

				//Set damage effect
				effect eDam = EffectDamage(nDam, DAMAGE_TYPE_FIRE);
					effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);

				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}
	}

	effect eRay = EffectBeam(VFX_BEAM_FIRE, OBJECT_SELF, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}


*/