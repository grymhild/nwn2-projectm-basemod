//::///////////////////////////////////////////////
//:: Name: Seething Eyebane
//:: Filename: sp_seeth_eyebn.nss
//::///////////////////////////////////////////////
/**Seething Eyebane
Transmutation [Evil, Acid]
Level: Corrupt 1
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Target: Creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates (see text)
Spell Resistance: Yes

The subject's eyes burst, spraying acid upon everyone
within 5 feet. The subject is blinded and takes 1d6
points of acid damage. Those sprayed take 1d6 points
of acid damage (Reflex save for half). Creatures
without eyes can't be blinded, but they might take
acid damage if someone nearby is the subject of
seething eyebane.

Corruption Cost: 1d6 points of Constitution damage

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SEETHING_EYEBANE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	
	
	object oTarget = HkGetSpellTarget();
	location lTarget = GetLocation(oTarget);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_SEETHING_EYEBANE, oCaster);

	if( CSLGetIsLiving(oTarget) && !CSLGetIsOoze(oTarget) )
	{
		//Spell Resistance
		if (!HkResistSpell(oCaster, oTarget))
		{
			//Fort save
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_ACID))
			{

				//Blind target permanently
				effect eBlind = EffectBlindness();
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget);

				oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_CREATURE);

				while(GetIsObjectValid(oTarget))
				{
					//nDam = 1d6 acid
					int nDam = d6(1);
					effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_ACID);

					//apply damage
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

					oTarget = GetNextObjectInShape(SHAPE_SPHERE, 5.0, lTarget, FALSE, OBJECT_TYPE_CREATURE);
				}

			}
		}
	}
	//Corruption cost 1d6 CON regardless of success
	int nCost = d6(1);

	SCApplyCorruptionCost(oCaster, ABILITY_CONSTITUTION, nCost, 0);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

}