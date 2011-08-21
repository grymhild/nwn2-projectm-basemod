//::///////////////////////////////////////////////
//:: Lion's Swiftness
//:: cmi_s2_lionswftness
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: March 22, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
#include "_SCInclude_Transmutation"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_ltlionsswift();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = LION_TALISID_LIONS_SWIFTNESS;
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
	int nClassLevel = GetLevelByClass(CLASS_LION_TALISID, OBJECT_SELF);	
	
		
		//effect eHaste =  EffectHaste();
		//eHaste = SetEffectSpellId(eHaste,iSpellId);
		//eLink = SupernaturalEffect(eLink);
		
		//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHaste, OBJECT_SELF,  RoundsToSeconds(nClassLevel));
	SCApplyHasteEffect( oCaster, oCaster, iSpellId, RoundsToSeconds(nClassLevel), DURATION_TYPE_TEMPORARY );
	
	HkPostCast(oCaster);
}