//#include "_CSLCore_Items"
//#include "nwn2_inc_spells"
//#include "cmi_ginc_spells"
//#include "cmi_ginc_polymorph"


#include "_HkSpell"
#include "_SCInclude_Polymorph"


void main()
{	
		//scSpellMetaData = SCMeta_FT_wildshape();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_VGUARD_PLANT_SHAPE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	//if (!GetHasFeat(FEAT_WILD_SHAPE, OBJECT_SELF))
	//{
	//		SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_FEAT_USES);
	//		return;
	//}
	
	if (GetHasSpellEffect(SPELL_Plant_Body))	
	{
		SendMessageToPC(OBJECT_SELF, "Wildshape failed.  The spell Plant Body prevents shifting forms.");
		int nFeatId = GetSpellFeatId();
		IncrementRemainingFeatUses(OBJECT_SELF, nFeatId);
		return;
	}
	
	if( CSLGetPreferenceSwitch("UnlimitedWildshapeUses",FALSE) )
	{
		IncrementRemainingFeatUses(OBJECT_SELF, GetSpellFeatId() );
	}
	
	int iLevel = GetLevelByClass(CLASS_TYPE_RANGER, OBJECT_SELF);
	iLevel += GetLevelByClass(CLASS_VERDANT_GUARDIAN, OBJECT_SELF);
	
	//int iLevel = CSLGetWildShapeLevel(oCaster);
	int bElder = FALSE; //( iLevel >= 12 );
	float fDuration = HoursToSeconds( iLevel );
	PolyMerge(oCaster, SPELLABILITY_VGUARD_PLANT_SHAPE, fDuration, bElder, TRUE, TRUE);
	
	HkPostCast(oCaster);
}