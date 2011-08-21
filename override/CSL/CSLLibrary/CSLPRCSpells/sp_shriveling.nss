//::///////////////////////////////////////////////
//:: Name 	Shriveling
//:: FileName sp_shriveling.nss
//:://////////////////////////////////////////////
/**@file Shriveling
Necromancy [Evil]
Level: Clr 3, Sor/Wiz 2
Components: V, S, Disease
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

The caster channels dark energy that blasts and
blackens the subject's flesh. The subject takes
1d4 points of damage per caster level (maximum 10d4).

Disease Component: Soul rot.

Author: 	Tenjac
Created: 	05/04/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

int GetHasSoulRot(object oCaster);
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	
	

	//spellhook
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHRIVELING; // put spell constant here
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

	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int iSpellPower = HkGetSpellPower( oCaster, 10 );

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_SHRIVELING, oCaster);

	//Check for Soul rot
	if(GetHasSoulRot(oCaster))
	{
		//SR
		if(!HkResistSpell(oCaster, oTarget))
		{
			int nDam = HkApplyMetamagicVariableMods(d4(iSpellPower), 4 * iSpellPower);

			//Check for save
			if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
			{
				nDam = nDam/2;
			}

			effect eVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);

			//Apply damage & visual
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}
	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

int GetHasSoulRot(object oCaster)
{
	int bHasDisease = FALSE;
	effect eTest = GetFirstEffect(oCaster);
	effect eDisease = SupernaturalEffect(EffectDisease(DISEASE_SOUL_ROT));

	if (CSLGetHasEffectType(oCaster,EFFECT_TYPE_DISEASE))
	{
		while (GetIsEffectValid(eTest))
		{
			if(eTest == eDisease)
			{
				bHasDisease = TRUE;

			}
			eTest = GetNextEffect(oCaster);
		}
	}
	return bHasDisease;
}