//::///////////////////////////////////////////////
//:: Name 	Dancing Web
//:: FileName sp_dancg_web.nss
//:://////////////////////////////////////////////
/**@file Dancing Web
Evocation [Good]
Level: Clr 5, Drd 5, Sor/Wiz 4
Components: V, S, M/DF
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Area: 20-ft.-radius burst
Duration: Instantaneous
Saving Throw: Reflex half; see text
Spell Resistance: Yes

This spell creates a burst of magical energy that
deals 1d6 points per level of non-lethal damage
maximum 10d6). Further, evil creatures that fail
their saving throw become entangled by lingering
threads of magical energy for 1d6 rounds. An
entangled creature takes a -2 penalty on attack
rolls and a -4 penalty to effective Dexterity;
the entangled target can move at half speed but
can't run or charge.

Arcane Material Component: A bit of spider's web.

Author: 	Tenjac
Created: 	7/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DANCING_WEB; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lLoc = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 6.10f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	float fDuration;
	int nMetaMagic = HkGetMetaMagicFeat();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDam;
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int iSpellPower = HkGetSpellPower( oCaster, 10 );

	while(GetIsObjectValid(oTarget))
	{
		//SR
		if(!HkResistSpell(oCaster, oTarget ))
		{
			//Should be non-lethal
			nDam = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);

			HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);

			if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
			{
				if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_GOOD))
				{
					float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(d6(), SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEntangle(), oTarget, fDuration);
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 6.10f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}

	CSLSpellGoodShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}









