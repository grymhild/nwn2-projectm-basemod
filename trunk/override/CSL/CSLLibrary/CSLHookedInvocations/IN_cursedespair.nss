//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Curse of Despair
//:: nw_s0_icharm.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
			5.7.2.4   Curse of Despair
			Complete Arcane, pg. 132
			Spell Level: 4
			Class:       Misc

			This is the equivalent to the Bestow Curse spell (4th level wizard).
			But even if the target makes their save,
			they still suffer a -1 penalty to hit for 10 rounds.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"




void main()
{
	//scSpellMetaData = SCMeta_IN_cursedespair();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ALL );


	
	int nMod = 3;
	object oTarget = HkGetSpellTarget();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BESTOW_CURSE) );
		if ( !HkResistSpell(oCaster, oTarget) )
		{
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY), oTarget);
			
			// GetInvocationSaveDC
			int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_WILL, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, HkGetSpellSaveDC(oCaster, oTarget), iSaveType, oCaster );
			if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
			{
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCurse(nMod, nMod, nMod, nMod, nMod, nMod)), oTarget);
			}
			else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE ) // partial damage is full hit point damage
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectAttackDecrease(1)), oTarget);
			}
		}
	}
	
	HkPostCast(oCaster);
}

