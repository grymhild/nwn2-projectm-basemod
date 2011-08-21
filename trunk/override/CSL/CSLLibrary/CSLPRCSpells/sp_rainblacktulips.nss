//::///////////////////////////////////////////////
//:: Name 	Rain of Black Tulips
//:: FileName sp_rain_btul.nss
//:://////////////////////////////////////////////
/**@file Rain of Black Tulips
Evocation [Good]
Level: Drd 9
Components: V, S, M
Casting Time: 1 standard action
Range: Long (400 ft. + 40 ft./level)
Area: Cylinder (80-ft. radius, 80 ft. high)
Duration: 1 round/level (D)
Saving Throw: None (damage), Fortitude negates (nausea)
Spell Resistance: Yes

Tulips as black as midnight fall from the sky. The
tulips explode with divine energy upon striking evil
creatures, each of which takes 5d6 points of damage.
In addition, evil creatures that fail a Fortitude
save are nauseated (unable to attack, cast spells,
concentrate on spells, perform any task requiring
concentration, or take anything other than a single
move action per turn) until they leave the spell's
area. A successful Fortitude save renders a creature
immune to the nauseating effect of the tulips, but
not the damage.

Material Component: A black tulip.

Author: 	Tenjac
Created: 	7/14/06
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
	int iSpellId = SPELL_RAIN_OF_BLACK_TULIPS; // put spell constant here
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
	int nCasterLvl = HkGetCasterLevel(oCaster);
	effect eAOE = EffectAreaOfEffect(VFX_AOE_RAIN_OF_BLACK_TULIPS);
	location lLoc = HkGetSpellTargetLocation();
	int nMetaMagic = HkGetMetaMagicFeat();
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	int nDam;
	int nAlign;
	//fDuration = RoundsToSeconds(nCasterLvl);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//Create AoE
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);

	//Loop through and damage creatures
	while(GetIsObjectValid(oTarget))
	{
		if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
		{
			//SR
			if(!HkResistSpell(oCaster, oTarget ))
			{
				int nDam = HkApplyMetamagicVariableMods(d6(5), 30);
				
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, 24.38f, lLoc, FALSE, OBJECT_TYPE_CREATURE);
	}
	CSLSpellGoodShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




