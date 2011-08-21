//::///////////////////////////////////////////////
//:: Ioun Stone
//:: nx_s2_ioun_stone.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
		Applies the proper Ioun Stone VFX to the
		bearer of an Ioun Stone when granted the
		associated Ioun Stone feat.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 02/28/2007
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_FT_iounstone();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // leave this one like this
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	object oTarget  = HkGetSpellTarget();

	// Toggle the VFX
	if (GetHasSpellEffect(iSpellId, oTarget))
	{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, oTarget, oTarget, iSpellId );
			//SCRemoveSpellEffects(iSpellId, oTarget, oTarget);
	}
	else
	{
			int nVFX = VFX_DUR_IOUN_STONE_STR;
			switch(iSpellId)
			{
				case SPELLABILITY_IOUN_STONE_STR: nVFX = VFX_DUR_IOUN_STONE_STR; break;
				case SPELLABILITY_IOUN_STONE_DEX: nVFX = VFX_DUR_IOUN_STONE_DEX; break;
				case SPELLABILITY_IOUN_STONE_CON: nVFX = VFX_DUR_IOUN_STONE_CON; break;
				case SPELLABILITY_IOUN_STONE_INT: nVFX = VFX_DUR_IOUN_STONE_INT; break;
				case SPELLABILITY_IOUN_STONE_WIS: nVFX = VFX_DUR_IOUN_STONE_WIS; break;
				case SPELLABILITY_IOUN_STONE_CHA: nVFX = VFX_DUR_IOUN_STONE_CHA; break;
			}
			
		effect eVFX = EffectVisualEffect(nVFX);
					eVFX = ExtraordinaryEffect(eVFX);    // Should not be dispellable.
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eVFX, oTarget);
	}
	
	HkPostCast(oCaster);
}