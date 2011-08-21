//::///////////////////////////////////////////////
//:: Grease
//:: NW_S0_Grease.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creatures entering the zone of grease must make
	a reflex save or fall down.  Those that make
	their save have their movement reduced by 1/2.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 1, 2001
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void main()
{
	//scSpellMetaData = SCMeta_SP_grease();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREASE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool=SPELL_SCHOOL_CONJURATION;
	int iSpellSubSchool=SPELL_SUBSCHOOL_CREATION;
	if ( GetSpellId() == SPELL_MSC_GREASE  )
	{
		iSpellSchool=SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool=SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	
	int iSpellPower = CSLGetMax( HkGetSpellPower( oCaster )/8, 2);
	
	location lTarget = HkGetSpellTargetLocation();
	//int iDuration = 2 + HkGetSpellPower(OBJECT_SELF) / 3;
	int iDuration =  HkGetSpellDuration( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF); // AFW-OEI 04/16/2007: Change duration to 1 round/level.
		
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );

	//SendMessageToPC( GetFirstPC( TRUE ) , "Grease time2");

	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_PER_GREASE, "", "", "", sAOETag); //, "nw_s0_greasea", "nw_s0_greasea");
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//iDuration = 200;
	//Create an instance of the AOE Object using the Apply Effect function
	DelayCommand( 0.1f, HkApplyEffectAtLocation(iDurType, eAOE, lTarget, fDuration ) );
	DelayCommand( 0.5f, SetLocalInt( GetObjectByTag( sAOETag ), "CSL_ENVIRO", CSL_ENVIRO_FLAMMABLE ) );
    
	HkPostCast(oCaster);
}
