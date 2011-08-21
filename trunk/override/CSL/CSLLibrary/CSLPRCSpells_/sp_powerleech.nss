//::///////////////////////////////////////////////
//:: Name: 	Power Leech
//:: Filename: sp_power_leech.nss
//::///////////////////////////////////////////////
/**@file Power Leech
Necromancy [Evil]
Level: Corrupt 5
Components: V, S, Corrupt
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Target: One living creature
Duration: 1 round/level
Saving Throw: Will negates
Spell Resistance: Yes

The caster creates a conduit of evil energy between
himself and another creature. Through the conduit,
the caster can leech off ability score points at
the rate of 1 point per round. The other creature
takes 1 point of drain from an ability score of
the caster's choosing, and the caster gains a +1
enhancement bonus to the same ability score per
point drained during the casting of this spell.
In other words, all points drained during this
spell stack with each other to determine the
enhancement bonus, but they don't stack with
other castings of power leech or with other
enhancement bonuses.

The enhancement bonus lasts for 10 minutes per
caster level.

Corruption Cost: 1 point of Wisdom drain.


@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "inc_dynconv"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POWER_LEECH; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	

	
	object oSkin = CSLGetPCSkin(oCaster);
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nAbility;
	int nSpell = HkGetSpellId();
	int nRoundCounter = nCasterLvl;
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_POWER_LEECH, oCaster);

	

	//Set float
	SetLocalFloat(oCaster, "PRC_Power_Leech_fDur", fRemove);

	//Set counter int
	SetLocalInt(oCaster, "PRC_Power_Leech_Counter", nRoundCounter);

	//Set target as local object
	SetLocalObject(oCaster, "PRC_PowerLeechTarget", oTarget);

	//Clear actions for the convo
		ClearAllActions(TRUE);

	//Check for ability to drain

	/* <Stratovarius> That would be easiest to do as a convo I think
			<Stratovarius> just steal the animal affinity one from psionics and modify*/

	StartDynamicConversation("power_leech", oCaster, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oCaster);

	//Corruption Cost
	{
		DelayCommand(fDuration, SCApplyCorruptionCost(oCaster, ABILITY_WISDOM, 1, 1));
	}

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}