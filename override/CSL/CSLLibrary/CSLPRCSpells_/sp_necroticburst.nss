//::///////////////////////////////////////////////
//:: Name 	Necrotic Burst
//:: FileName sp_nec_burst.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Burst
Necromancy [Evil]
Level: Clr 5, sor/wiz 5
Components: V, S, F
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Target: Living creature with necrotic cyst
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: No

You cause the cyst of a subject already harboring a necrotic cyst
(see spell of the same name) to explosively enlarge itself at the
expense of the subject's body tissue. if the subject succeeds on
her saving throw, she takes 1d6 points of damage per level
(maximum 15d6), and half the damage is considered vile damage
(see necrotic bloat). The subject's cyst-derived saving throw
penalty against effects from the school of necromancy applies.

If the subject fails her saving throw, the cyst expands beyond
control, killing the subject. On the round following the subject's
death, the cyst exits the flesh of the slain subject as a free-willed
undead called a skulking cyst. The skulking cyst is formed from the
naked organs of the subject (usually the intestines, but also
including a mass of blood vessels, the odd bone or two, and
sometimes even half the lolling head).

	Author: 	Tenjac
	Created: 	9/22/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "spinc_necro_cyst"
//#include "inc_utility"
//#include "prc_inc_spells"


#include "_HkSpell"
#include "_SCInclude_BarbRage"
#include "_SCInclude_Necromancy"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_NECROTIC_BURST; // put spell constant here
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


	
	int nLevel = CSLGetMin(HkGetCasterLevel(oCaster), 15);
	int nMetaMagic = HkGetMetaMagicFeat();
	object oTarget = HkGetSpellTarget();
	int iAdjustedDamage, iSave;
	
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_NECROTIC_BURST, oCaster);

	if(!GetCanCastNecroticSpells(oCaster))
	return;

	if(!GetHasNecroticCyst(oTarget))
	{
		// "Your target does not have a Necrotic Cyst."
		SendMessageToPCByStrRef(oCaster, nNoNecCyst);
		return;
	}

	//Define nDC

	int nDC = HkGetSpellSaveDC(oCaster,oTarget);

	//Resolve spell
	iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, nDC, SAVING_THROW_TYPE_EVIL, oCaster, SAVING_THROW_RESULT_ROLL );
	if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
	{
		SCDeathlessFrenzyCheck(oTarget);
		effect eDeath = EffectDeath();

		eDeath = SupernaturalEffect(eDeath);
		effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
		RemoveCyst(oTarget);
		
	}
	else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
	{
		int nDam = d6(nLevel);

		//Metmagic: Maximize
		if (nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDam = 6 * (nLevel);
		}

		//Metmagic: Empower
		if (nMetaMagic == METAMAGIC_EMPOWER)
		{
			nDam += (nDam/2);
		}

		int nVile = nDam/2;
		int nNorm = (nDam - nVile);
		//Vile damage is currently being applied as Positive damage
		effect eVileDam = HkEffectDamage(nVile, DAMAGE_TYPE_POSITIVE);
		effect eNormDam = HkEffectDamage(nNorm, DAMAGE_TYPE_MAGICAL);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVileDam, oTarget);
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eNormDam, oTarget);
	}
	
	CSLSpellEvilShift(oCaster);
	
	HkPostCast( oCaster );
}

