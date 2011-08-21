//::///////////////////////////////////////////////
//:: Name 	Starmantle
//:: FileName sp_starmantle.nss
//:://////////////////////////////////////////////
/**@file Starmantle
Abjuration
Level: Joy 7, Sor/Wiz 6
Components: V, S, M
Casting Time: 1 standard action
Range: Touch
Target: One living creature touched
Duration: 1 minute/level (D)
Saving Throw: None
Spell Resistance: Yes (harmless)

This spell manifests as a draping cloak of tiny,
cascading stars that seem to flicker out before
touching the ground. The cloak forms over the
target's existing apparel and sheds light as a
torch, although this is not the mantle's primary
function.

The starmantle renders the wearer impervious to
non-magical weapon attacks and transforms any
non-magical weapon or missile that strikes it
into harmless light, destroying it forever.
Contact with the starmantle does not destroy
magic weapons or missiles, but the starmantle's
wearer is entitled to a Reflex saving throw
(DC 15) each time he is struck by such a weapon;
success indicates that the wearer takes only
half damage from the weapon (rounded down).

Material Component: A pinch of dust from a
pixie's wing (20 gp).

Author: 	Tenjac
Created: 	7/17/06
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
	int iSpellId = SPELL_STARMANTLE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();

	int nCasterLvl = HkGetCasterLevel(oCaster);
	//float fDur = (60.0f * nCasterLvl);
	int nMetaMagic = HkGetMetaMagicFeat();

	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	if( CSLGetIsUndead(oTarget) || CSLGetIsConstruct(oTarget) )
	{
		//--------------------------------------------------------------------------
		// Clean up
		//--------------------------------------------------------------------------
		HkPostCast( oCaster );
		return;
	}

	//VFX
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SANCTUARY), oTarget, fDuration);

	object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget);

	itemproperty ipOnHit = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
	CSLSafeAddItemProperty(oArmor, ipOnHit, fDuration);

	//Add event script
	AddEventScript(oTarget, EVENT_ONHIT, "prc_evnt_strmtl", TRUE, FALSE);

	//impervious to non-magical weapons for the duration
	effect eReduce = EffectDamageReduction(0, DAMAGE_POWER_PLUS_ONE, 0);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReduce, oTarget, fDuration);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}





