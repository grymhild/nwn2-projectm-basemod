//::///////////////////////////////////////////////
//:: Vine Mine, Camouflage
//:: X2_S0_VineMCam
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Area of effect spell that places concealment
	bonus of +4 on all friendly creatures.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_vineminecamo();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VINE_MINE_CAMOUFLAGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	float fDuration = RoundsToSeconds(HkGetSpellDuration(oCaster) * 10);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration ,FALSE  );
	effect eAOE = EffectAreaOfEffect( AOE_PER_VINE_MINE_CAMOUFLAGE, "", "", "", sAOETag ); //, "SP_vineminecamoA", "SP_vineminecamoC", "SP_vineminecamoB");
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	DelayCommand( 0.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, HkGetSpellTargetLocation(), fDuration) );
	HkPostCast(oCaster);
}

