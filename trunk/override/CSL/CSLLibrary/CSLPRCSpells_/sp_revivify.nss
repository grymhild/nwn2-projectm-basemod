//::///////////////////////////////////////////////
//:: Name 	Revivify
//:: FileName sp_revivify.nss
//:://////////////////////////////////////////////
/** @file Revivify
Conjuration (Healing)
Level: Clr 5, Hlr 5
Components: V,S,M
Casting Time: 1 standard action
Range: Touch
Target: Dead creature touched
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes (harmless)

Revivify miraculously restores life to a recently
deceased creature. However, the spell must be cast
within 1 round of the victim's dead. Before the
soul of the deceased has completely left the body,
this spell halts its journey while repairing
somewhat the damage to the body. This spell
functions like raise dead, except that the raised
creature receives no level loss, no Constitution
loss, and no loss of spells. The creature is only
restored to -1 hit points (but is stable).

Material Component: Diamonds worth at least 1000 gp.
**/
///////////////////////////////////////////////////
// Author: Tenjac
// Date: 	6.10.06
///////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"
#include "_CSLCore_Nwnx"
void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_REVIVIFY; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	effect eResurrect = EffectResurrection();
	effect eVis 		= EffectVisualEffect(VFX_IMP_RAISE_DEAD);

	// Make sure the target is in fact dead
	if(GetIsDead(oTarget))
	{
		// Let the AI know - Special handling
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, FALSE, SPELL_RAISE_DEAD, oCaster);

		// Apply effects
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eResurrect, oTarget);

			// Do special stuff
			ExecuteScript("prc_pw_raisedead", oCaster);
			if(CSLGetPreferenceSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
				CSLSetPersistentInt(oTarget, "persist_dead", FALSE);
	}
	// end if - Deadness check

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}