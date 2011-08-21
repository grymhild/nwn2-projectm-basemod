//::///////////////////////////////////////////////
//:: Name 	Necrotic Bloat
//:: FileName sp_nec_bloat.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Bloat
Necromancy [Evil]
Level: Clr 3, sor/wiz 3
Components: V, S, F
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Target: Living creature with necrotic cyst
Duration: Instantaneous
Saving Throw: None
Spell Resistance: No

You cause the cyst of a subject already harboring
a necrotic cyst (see spell of the same name) to
pulse and swell. This agitation of the necrotic
cyst tears living tissue and expands the size of
the cyst, dealing massive internal damage to the
subject. The subject takes 1d6 points of damage
per level (maximum 10d6), and half the damage is
considered vile damage because the cyst expands
to envelop the newly necrotized tissue. The cyst
is reduced to its original size when the vile
damage is healed.

Vile damage can only be healed
by magic cast within the area of a consecrate or
hallow spell (or an area naturally consecrated or
hallowed). Points of vile damage represent such
an evil violation to a character's body or soul
that only in a holy place, with holy magic, can
the damage be repaired.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "spinc_necro_cyst"
//#include "inc_utility"
//#include "prc_inc_spells"


#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_NECROTIC_BLOAT; // put spell constant here
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


	
	object oTarget = HkGetSpellTarget();
		
	int iSpellPower = HkGetSpellPower( oCaster, 10 );
	
	int nMetaMagic = HkGetMetaMagicFeat();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_NECROTIC_BLOAT, oCaster);

	if(!GetCanCastNecroticSpells(oCaster))
	return;

	if(!GetHasNecroticCyst(oTarget))
	{
		// "Your target does not have a Necrotic Cyst."
		SendMessageToPCByStrRef(oCaster, nNoNecCyst);
		return;
	}

	//Resolve spell
	int nDam = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);

	int nVile = nDam/2;
	int nNorm = (nDam - nVile);

	//Vile damage is currently being applied as Positive damage
	effect eVileDam = HkEffectDamage(nVile, DAMAGE_TYPE_POSITIVE);
	effect eNormDam = HkEffectDamage(nNorm, DAMAGE_TYPE_MAGICAL);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVileDam, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eNormDam, oTarget);


	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

	CSLSpellEvilShift(oCaster);
}
