//::///////////////////////////////////////////////
//:: Repellant Flesh
//:: cmi_s2_repelflesh
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Jan 17, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_wodrepellant();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = WOD_REPELLANT_FLESH;
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
		
	
	effect eSR =  EffectSpellResistanceIncrease( 10 + GetHitDice(OBJECT_SELF) );
	eSR = SetEffectSpellId(eSR,iSpellId);
	eSR = SupernaturalEffect(eSR);
	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSR, OBJECT_SELF, HkApplyDurationCategory(2, SC_DURCATEGORY_DAYS) );
	
	HkPostCast(oCaster);
}