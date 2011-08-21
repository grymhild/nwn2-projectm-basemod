//::///////////////////////////////////////////////
//:: Cleansing Nova: On Enter
//:: nw_s2_clnsnovaa.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	New targets entering the nova may take damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On:04/24/2006
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




int GetIsValidNovaTarget( object oTarget )
{
	int nRacialType = GetRacialType(oTarget);
	if ( CSLGetIsUndead( oTarget ) || // Only target Undead OR Outsiders
		nRacialType == RACIAL_TYPE_OUTSIDER )
		return TRUE;

	return FALSE;
}
	
void main()
{
	//scSpellMetaData = SCMeta_FT_cleansingnov(); //SPELLABILITY_CLEANSING_NOVA;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	object oCaster = GetAreaOfEffectCreator();
	int    iCasterLevel = HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); // GetTotalLevels( oCaster, TRUE );
	effect eDam = EffectDamage(iCasterLevel, DAMAGE_TYPE_FIRE); // Nova damage = character level
	object oTarget = GetEnteringObject(); // Capture the entering object.
	
	//Declare and assign personal impact visual effect.
	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_FIRE ); //
	effect eLink = EffectLinkEffects( eDam, eVis );
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELLABILITY_CLEANSING_NOVA));

		if (GetIsValidNovaTarget(oTarget))
		{
				//Make SR check.
				if(!HkResistSpell(oCaster, oTarget))
				{
					// Apply effects to the currently selected target.
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
					//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
		}
	}
}