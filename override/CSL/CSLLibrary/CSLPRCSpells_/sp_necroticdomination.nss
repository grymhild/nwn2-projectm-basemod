//::///////////////////////////////////////////////
//:: Name 	Necrotic Domination
//:: FileName sp_nec_domin.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Domination
Necromancy [Evil]
Level: Clr 4, sor/wiz 4
Components: V S, F
Target: Living creature with necrotic cyst

This spell functions like dominate person,
except you can dominate any humanoid that
harbors a necrotic cyst.


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
	int iSpellId = SPELL_NECROTIC_DOMINATION; // put spell constant here
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
	int nMetaMagic = HkGetMetaMagicFeat();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_NECROTIC_DOMINATION, oCaster);

	if(!GetCanCastNecroticSpells(oCaster))
	return;

	if(!GetHasNecroticCyst(oTarget))
	{
		// "Your target does not have a Necrotic Cyst."
		SendMessageToPCByStrRef(oCaster, nNoNecCyst);
		return;
	}
	//Domination

	effect eDom1 = EffectDominated();
	effect eDom = HkGetScaledEffect(eDom1, oTarget);
	effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	//Link duration effects
	effect eLink = EffectLinkEffects(eMind, eDom);
	eLink = EffectLinkEffects(eLink, eDur);

	effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
	int CasterLvl = HkGetCasterLevel(OBJECT_SELF);
	int nCasterLevel = CasterLvl;
	int nDuration = 2 + nCasterLevel/3;
	nDuration = HkGetScaledDuration(nDuration, oTarget);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
	//Make sure the target is a humanoid
	if(!GetIsReactionTypeFriendly(oTarget))
	{
		if ( CSLGetIsHumanoid(oTarget) )
		{

			//Make SR Check
			if (!HkResistSpell(OBJECT_SELF, oTarget ))
			{
				//Make Will Save
				if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, (HkGetSpellSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
				{
					//Check for metamagic extension
					float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(nDuration, SC_DURCATEGORY_ROUNDS) );
					//Apply linked effects and VFX impact
					DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
		}
	}
		
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );


	//CSLSpellEvilShift(oCaster);
}






