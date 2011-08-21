//::///////////////////////////////////////////////
//:: Potion of Lore
//:: NW_S0_PLore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

Gives the user a +4 bonus to lore for 5 minutes.

*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: July 26, 2006
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_potionlore();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iBonus = 4;
	effect eLore = EffectSkillIncrease( SKILL_LORE, iBonus );
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_IDENTIFY );
	effect eLink = EffectLinkEffects( eLore, eDur );



	if(!GetHasSpellEffect( 983, oTarget ) || !GetHasSpellEffect( SPELL_LEGEND_LORE, oTarget ))
	{
			SignalEvent( oTarget, EventSpellCastAt(OBJECT_SELF, 983 , FALSE));
			HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( 50 ));
	}
	
	HkPostCast(oCaster);
}