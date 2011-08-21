//::///////////////////////////////////////////////
//:: Name 	Doom Scarabs
//:: FileName sp_doom_scarab.nss
//:://////////////////////////////////////////////
/**@file Doom Scarabs
Conjuration/Necromancy
Level: Duskblade 3, sorcerer/wizard 4
Components: V,S
Casting Time: 1 standard action
Range: 60ft
Area: Cone-shaped burst
Duration: Instantaneous
Saving Throw: Will half
Spell Resistance: See text

This spell has two effects. It deals 1d6 points of
damage per two caster levels (maximum 10d6) to all
creatures in the area. Spell resistance does not
apply to this damage. However, spell resistance
does apply to the spell's secondary effect. If you
ovecome a creature's spell resistance, you gain 1d4
temporary hit points as the scarabs feast on the
creature's arcane energy and bleed it back into you.
You gain these temporary hit points for each creature
whose spell resistance you overcome. You never gain
temporary hit points from creatures that do not have
spell resistance.

The temporary hit points gained from this spell last
for up to 1 hour.

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
	int iSpellId = SPELL_DOOM_SCARABS; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	location lLoc = HkGetSpellTargetLocation();
	
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nBonusDice;
	int nDam;
	int nDC, iSave;
	//float fDur = HoursToSeconds(1);
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(1, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int iAdjustedDamage;
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
		
		nDam = d6(CSLGetMin(nCasterLvl/2, 10));
		nDC = HkGetSpellSaveDC(oCaster,oTarget);

		if(nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDam = 6 * (CSLGetMin(nCasterLvl/2, 10));
		}

		if(nMetaMagic == METAMAGIC_EMPOWER)
		{
			nDam += (nDam/2);
		}
		
		nDam = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORFULLDAMAGE, nDam, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster, iSave );
		
		
		if ( nDam == 0 )
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
		}
		
		if(!HkResistSpell(oCaster, oTarget ))
		{
			nBonusDice++;
		}
		
		object oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 18.29f, lLoc, TRUE, OBJECT_TYPE_CREATURE);
	}

	effect eBonus = EffectTemporaryHitpoints(d4(nBonusDice));

	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBonus, oCaster, fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


