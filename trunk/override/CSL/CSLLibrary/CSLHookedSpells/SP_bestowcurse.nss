//::///////////////////////////////////////////////
//:: Bestow Curse
//:: NW_S0_BesCurse.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Afflicted creature must save or suffer a -2 penalty
	to all ability scores. This is a supernatural effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Bob McCabe
//:: Created On: March 6, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001
//:: AFW-OEI 04/05/2007: Increase curse to -3 to all ability scores (from -2).

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_bestowcurse();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BESTOW_CURSE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY); // NWN1 VFX
	effect eCurse = EffectCurse(3, 3, 3, 3, 3, 3);
	eCurse = EffectLinkEffects( eCurse, EffectVisualEffect( VFX_DUR_SPELL_BESTOW_CURSE ) );
	eCurse = SupernaturalEffect(eCurse);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Signal spell cast at event
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BESTOW_CURSE));
		//Make SR Check
		if (!HkResistSpell(oCaster, oTarget))
		{
			//Make Will Save
			if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC()))
			{
				//Apply Effect and VFX
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget);
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget); // NWN1 VFX
			}
		}
	}
	
	HkPostCast(oCaster);
}

