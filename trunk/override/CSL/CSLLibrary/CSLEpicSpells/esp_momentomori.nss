//::///////////////////////////////////////////////
//:: Epic Spell: Momento Mori
//:: Author: Boneshank (Don Armstrong)
//#include "prc_alterations"
//#include "inc_epicspells"


#include "_HkSpell"
#include "_SCInclude_Epic"
#include "_SCInclude_BarbRage"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_MORI;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iAdjustedDamage;
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_MORI))
	{
		
		object oTarget = HkGetSpellTarget();
		int nDamage;
		effect eDam;
		effect eVis = EffectVisualEffect(VFX_IMP_DEATH_L);
		effect eVis2 = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
			GetHitDice(oTarget) < 50 && oTarget != OBJECT_SELF)
		{
			//Make SR check
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Make Fortitude save
				iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget)+10, SAVING_THROW_TYPE_DEATH, oCaster, SAVING_THROW_RESULT_ROLL );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
				{
					SCDeathlessFrenzyCheck(oTarget);
					//Apply the death effect and VFX impact
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
				}
				else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					//Roll damage
					nDamage = d6(3) + 20;
					//Set damage effect
					eDam = HkEffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
					//Apply damage effect and VFX impact
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);	
					
				}
			}
		}
		else 
		{
			SendMessageToPC(OBJECT_SELF, "Spell failure - the target was not valid.");
		}
	}
	HkPostCast(oCaster);
}
