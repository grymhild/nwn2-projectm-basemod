//::///////////////////////////////////////////////
//:: Name 	Call Dretch Horde
//:: FileName sp_call_dretch.nss
//:://////////////////////////////////////////////
/**@file Call Dretch Horde
Conjuration (Calling) [Evil]
Level: Demonologist 3, Mortal Hunter 4, Sor/Wiz 5
Components: V S, Soul
Casting Time: 1 minute
Range: Close (25 ft. + 5 ft./2 levels)
Effect: 2d4 dretches
Duration: One year
Saving Throw: None
Spell Resistance: No

The caster calls 2d4 dretches from the Abyss to where
she is, offering them the soul that she has prepared.
In exchange, they will serve the caster for one year
as guards, slaves, or whatever else she needs them
for. They are profoundly stupid, so the caster cannot
give them more complicated tasks than can be described
in about ten words.

No matter how many times the caster casts this spell,
she can control no more than 2 HD worth of fiends per
caster level. If she exceeds this number, all the newly
called creatures fall under the caster's control, and
any excess from previous castings become uncontrolled.
The caster chooses which creatures to release.

Author: 	Tenjac
Created: 	5/7/2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Summon"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CALL_DRETCH_HORDE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//



	
	int nCasterLvl = HkGetCasterLevel(oCaster);
	location lLoc = HkGetSpellTargetLocation();
	string sResRef = "csl_sum_tanar_dretch";
	effect eModify = EffectModifyAttacks(2);

	CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
	if(CSLGetPreferenceInteger("MaxNormalSummons"))
	{
		CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
		
		effect eSummon = EffectSummonCreature(sResRef);
			eSummon = SupernaturalEffect(eSummon);

		//determine how many to take control of
		int nTotalCount = d4(2);
		int i;
		int nMaxHDControlled = nCasterLvl * 2;
		int nTotalControlled = SCGetControlledFiendTotalHD(oCaster);
		//Summon loop
		while(nTotalControlled < nMaxHDControlled
			&& i < nTotalCount)
		{
			HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lLoc, HoursToSeconds(24*12*30));
			i++;
			nTotalControlled = SCGetControlledFiendTotalHD(oCaster);
		}
		FloatingTextStringOnCreature("Currently have "+IntToString(nTotalControlled)+"HD out of "+IntToString(nMaxHDControlled)+"HD.", OBJECT_SELF);
	}
	else
	{
		//non-multisummon
		//this has a swarm type effect since dretches are useless individually
		effect eSummon = EffectSwarm(TRUE, sResRef);
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lLoc, HoursToSeconds(24));
	}
	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

