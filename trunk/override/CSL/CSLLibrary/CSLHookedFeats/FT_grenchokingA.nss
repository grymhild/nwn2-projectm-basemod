//::///////////////////////////////////////////////
//:: x0_s3_chokeen
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Choke effect on entering object
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Evocation"

void main()
{
	//scSpellMetaData = SCMeta_FT_grenchoking(); //SPELL_GRENADE_CHOKING;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iSaveDC = GetLocalInt(OBJECT_SELF, "SaveDC");
	SCStinkingCloud(GetEnteringObject(), iSaveDC); // Area of effect stinking cloud
}