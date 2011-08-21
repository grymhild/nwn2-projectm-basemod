//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Heartbeat
//:: NW_S0_InvSphC.nss
//:: Copyright (c) 2006 Obsidian Entertainment Inc.
//:://////////////////////////////////////////////
/*
	All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Aug 18, 2006
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_INVISIBILITY_SPHERE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_GLAMER );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//int nID = (92);
	if ( !GetHasSpellEffect(SPELL_INVISIBILITY_SPHERE, oCaster) )
	{
		DestroyObject(OBJECT_SELF, 3.0);
	}
}