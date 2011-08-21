//::///////////////////////////////////////////////
//:: Name 	Cloud of the Achaierai
//:: FileName sp_cloud_achai
//:://////////////////////////////////////////////
/**@file Cloud of the Achaierai
Conjuration (Creation) [Evil]
Level: Clr 6, Demonologist 4
Components: V, S, Disease
Casting Time: 1 action
Range: Personal
Area: 10-ft.radius spread
Duration: 10 minutes/level
Saving Throw: Fortitude partial
Spell Resistance: Yes

The caster conjures a choking, toxic cloud of inky
blackness. Those other than the caster within the
cloud take 2d6 points of damage. They must also
succeed at a Fortitude save or be subject to a
confusion effect for the duration of the spell.

Disease Component: Soul rot.

Author: 	Tenjac
Created: 	03/24/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_misc_const"


#include "_HkSpell"
#include "_CSLCore_Nwnx"
void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CLOUD_OF_THE_ACHAIERAI;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables including Area of Effect Object
	effect eAOE = EffectAreaOfEffect(AOE_PER_ACHAIERAI);
	
	object oTarget = HkGetSpellTarget();
	object oItemTarget = oTarget;
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	location lLoc = HkGetSpellTargetLocation();

	//Check for Soul Rot
	if(CSLGetPersistentInt(oCaster, "PRC_Has_Soul_Rot"))
	{

		//Create an instance of the AOE Object using the Apply Effect function

		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lLoc, fDuration);
	}

	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

}