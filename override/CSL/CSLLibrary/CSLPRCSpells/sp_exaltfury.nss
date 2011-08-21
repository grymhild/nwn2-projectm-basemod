//::///////////////////////////////////////////////
//:: Name 	Exalted Fury
//:: FileName sp_exalt_fury.nss
//:://////////////////////////////////////////////
/**@file Exalted Fury
Evocation [Good]
Level: Sanctified 9
Components: V, Sacrifice
Casting Time: 1 standard action
Range: 40 ft.
Area: 40-ft. radius burst, centered on you
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

Uttering a single, awesomely powerful syllable of
the Words of Creation, your body erupts in the same
holy power that shaped the universe at its birth.
All evil creatures within the area take damage equal
to your current hit points +50.

Sacrifice: You die. You can be raised or resurrected
normally.

Author: 	Tenjac
Created:
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
	int iSpellId = SPELL_EXALTED_FURY; // put spell constant here
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
	
	int nMetaMagic = HkGetMetaMagicFeat();
	location lLoc = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	effect eVisLink = EffectLinkEffects(EffectVisualEffect(VFX_FNF_STRIKE_HOLY), EffectVisualEffect(VFX_FNF_SCREEN_BUMP));
			eVisLink = EffectLinkEffects(eVisLink, EffectVisualEffect(VFX_FNF_SUNBEAM));
	int nCasterLvl = HkGetCasterLevel(oCaster);

	//Damage = Hitpoints + 50
	int nDam = (GetCurrentHitPoints(oCaster) + 50);

	if(nMetaMagic == METAMAGIC_EMPOWER)
	{
		nDam += (nDam/2);
	}

	//You die, make it spectacular
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisLink, oCaster);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oCaster);

	//Loop
	while(GetIsObjectValid(oTarget))
	{
		//only looking for evil
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			//SR
			if(!HkResistSpell(OBJECT_SELF, oTarget ))
			{
				//Hit 'em
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
			}
		}

		//cycle
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 12.19f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}