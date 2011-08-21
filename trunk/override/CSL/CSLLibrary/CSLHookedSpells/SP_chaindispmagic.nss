//::///////////////////////////////////////////////
//:: Chain Dispel
//:: NW_S0_DisMagic.nss
//:: Copyright (c) 2008 Pain/Brian Meyer/Seed and Dex Devs
//:://////////////////////////////////////////////
//:: Players Handbook II
//:: Abjuration
//:: Level: Cleric 8, Sorceror/Wizard 8
//:: Components: V, S, M/DF
//:: Casting Time: 1 standard Action
//:: Range Close
//:: Targets: One or more creatures, no two of which 
//::          are more than 30 feet apart
//:: Duration: Instantaneous
//:: Saving Throw: None
//:: Spell Resistance: No  
//:: 
//:: A couscating bolt rips through the air, humming 
//:: with power as it strikes each targeted creature.
//:: 
//:: Each creature struck by this spel is affected as 
//:: if by a targeted dispel magic, except that you can 
//:: add your caster level to the dispel check, up to 
//:: a maximum of 25.
//:: 
//:: Material component: A pair of bronze nails, each 
//:: no less than 6 inches in length.
//:: 
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"

void main()
{
	//scSpellMetaData = SCMeta_SP_mordsdisjunc();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CHAIN_DISPEL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
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
	

	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	object oTarget = HkGetSpellTarget();
	
	
	if (  GetIsObjectValid(oTarget)  )
	{
		DelayCommand( 0.1f,  SCDispelTarget(oTarget, oCaster, SCGetDispellCount(iSpellId, TRUE), SPELL_CHAIN_DISPEL ) );
	}
	else
	{
		location lLocal = HkGetSpellTargetLocation();
		int nStripCnt = SCGetDispellCount(iSpellId, FALSE);
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		while (GetIsObjectValid(oTarget) && nStripCnt > 0)
		{
			if (GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT)
			{
				SCDispelAoE(oTarget, oCaster);
			}
			else
			{
				DelayCommand( 0.1f, SCDispelTarget(oTarget, oCaster, nStripCnt, SPELL_CHAIN_DISPEL) );
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
		}
	}
	
	
	
	HkPostCast(oCaster);	
}