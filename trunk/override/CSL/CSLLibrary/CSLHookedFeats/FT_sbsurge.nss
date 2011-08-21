//::///////////////////////////////////////////////
//:: Swiftsurge
//:: cmi_s2_swiftsurge
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: March 23, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_sbsurge();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SWIFTBLADE_SWIFTSURGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
		
	
	effect eLink = GetSwiftbladeSurgeEffect(OBJECT_SELF);
	
	
	
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
	
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF);
	
	HkPostCast(oCaster);
}

