//::///////////////////////////////////////////////
//:: Name 	Channeled Pyroburst
//:: FileName sp_chan_pyrob.nss
//:://////////////////////////////////////////////
/**@file Channeled Pyroburst
Evocation [Fire]
Level: Duskblade 4, sorcerer/wizard 4
Components: V,S
Casting Time: See text
Range: Medium
Area: See text
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

This spell creates a bolt of fiery energy that blasts
your enemies. The spell's strength depends on the
amount of time you spend channeling energy into it.

If you cast this spell as a swift action, it deals
1d4 points of fire damage per two caster levels
(maximum 10d4) against a single target of your choice.

If you cast this spell as a standard action, it deals
1d6 points of fire damage per caster level
(maximum 10d6) to all creatures in a 10-foot-radius
spread.

If you cast this spell as a full-round action, it deals
1d8 points of fire damage per caster level
(maximum 10d8) to all creatures in a 15-foot-radius
spread.

If you spend 2 rounds casting this spell, it deals 1d10
points of fire damage per caster level (maximum 10d10)
to all creatures in a 20-foot-radius spread.

You do not need to declare ahead of time how long you
want to spend casting the spell. When you begin casting
the spell, you decide that you are finished casting after
the appropriate time has passed.

**/
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CHANNELED_PYROBURST; // put spell constant here
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

	//


	
	int nSpell = HkGetSpellId();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	location lLoc = HkGetSpellTargetLocation();
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nDam;
	int nMetaMagic = HkGetMetaMagicFeat();
	float fRadius = 0.0f;
	int iSpellPower = HkGetSpellPower( oCaster, 10 ); 
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_CHANNELED_PYROBURST, oCaster);

	//Check Spell Resistance
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//swift
		if(nSpell == SPELL_CHANNELED_PYROBURST_1)
		{
			if(!TakeSwiftAction(oCaster))
			{
				return;
			}
			iSpellPower = HkGetSpellPower( oCaster, 20 )/2; 
			nDam = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);
		}

		//standard
		else if(nSpell == SPELL_CHANNELED_PYROBURST_2)
		{
			nDam = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
			fRadius = 3.048f;
		}

		//full round
		else if(nSpell == SPELL_CHANNELED_PYROBURST_3)
		{
			nDam = HkApplyMetamagicVariableMods(d8(iSpellPower), 8 * iSpellPower);
			fRadius = 4.57f;
		}

		//two rounds
		else if(nSpell == SPELL_CHANNELED_PYROBURST_4)
		{
			nDam = HkApplyMetamagicVariableMods(d10(iSpellPower), 10 * iSpellPower);
			fRadius = 6.10f;
		}
		else
		{
			//--------------------------------------------------------------------------
			// Clean up
			//--------------------------------------------------------------------------
			HkPostCast( oCaster );
			return;
		}
		
		if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE))
		{
			nDam = nDam/2;
		}

		effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_FIRE);

		if(fRadius == 0.0f)
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		}

		else
		{
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

			while(GetIsObjectValid(oTarget))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

				oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
			}
		}
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




