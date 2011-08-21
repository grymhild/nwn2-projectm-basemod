//::///////////////////////////////////////////////
//:: x0_s3_chokehb
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Heartbeat script for choking powder.
	Every round make a saving throw
	or be dazed.
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
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSaveDC = GetLocalInt(OBJECT_SELF, "SaveDC");
	SCStinkingCloud(OBJECT_INVALID, iSaveDC); // Area of effect stinking cloud
}