//::///////////////////////////////////////////////
//:: Choking Powder
//:: x0_s3_choke
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a stinking cloud where thrown for 5 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 10, 2002
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_grenchoking();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_AOE_TRANSMUTATION;
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = 5;
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);
	object oItem = GetSpellCastItem();
	string sTag = GetStringLowerCase(GetTag(oItem));
	int iSaveDC;

	if (sTag == "x1_wmgrenade004")
	{
		iSaveDC = 15;
	}
	else if (sTag == "n2_it_chok_2")
	{
		iSaveDC = 17;
	}
	else if (sTag == "n2_it_chok_3")
	{
		iSaveDC = 19;
	}
	else if (sTag == "n2_it_chok_4")
	{
		iSaveDC = 21;
	}
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	//Declare major variables
	//string sAOETag = GetAOETag();
	effect eAOE = EffectAreaOfEffect(AOE_PER_CHOKE_POWDER, "", "", "", sAOETag);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Create the AOE object at the selected location
	DelayCommand( 0.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration ) );
	
	object oAOE = GetObjectByTag(sAOETag);
	SetLocalInt(oAOE, "SaveDC", iSaveDC);
	
	HkPostCast(oCaster);
}

