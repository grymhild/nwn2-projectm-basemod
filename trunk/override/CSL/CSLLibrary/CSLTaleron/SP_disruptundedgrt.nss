/*
Disrupt Undead Greater
Sean Harrington
11/11/07
#1372
*/

//::///////////////////////////////////////////////
//:: Disrupt Undead, Greater
//::
//:://////////////////////////////////////////////
/*
	If the caster succeeds at a ranged touch attack
	the undead target takes 1d8/level damage.
*/
//:://////////////////////////////////////////////
//::
//:://////////////////////////////////////////////
//:: Bug Fix: Andrew Nobbs, April 17, 2003
//:: Notes: Took out ranged attack roll.
//:://////////////////////////////////////////////
//:: AFW-OEI 06/06/2006:
//::	Pur ranged touch attack back in.
//::
//:: 	- Modernized the metamagic behavior
//#include "NW_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"


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
	int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));

		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{

				if (nCasterLevel > 10) nCasterLevel = 10;
				//Enter Metamagic conditions
				int nDam = d8(nCasterLevel);



				int nMetaMagic = HkGetMetaMagicFeat();
				if (nMetaMagic == METAMAGIC_MAXIMIZE)
				{
					nDam = 8 * nCasterLevel ;//Damage is at max
				}
				else if (nMetaMagic == METAMAGIC_EMPOWER)
				{
					nDam = nDam + nDam/2; //Damage/Healing is +50%
				}

				//Set damage effect
				effect eDam = EffectDamage(nDam, DAMAGE_TYPE_POSITIVE);
					effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);

				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}
	}

	effect eRay = EffectBeam(VFX_BEAM_HOLY, OBJECT_SELF, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}