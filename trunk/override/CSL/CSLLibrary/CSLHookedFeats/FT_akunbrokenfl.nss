//::///////////////////////////////////////////////
//:: Unbroken Flesh
//:: cmi_s2_unbrokenflesh
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: March 23, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"

void main()
{
    //scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = AKNIGHT_UNBROKEN_FLESH;
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
		
	int nDR = 3;
	
	if (GetHasFeat(494))
	{
		nDR = 12;
	}
	else
	if (GetHasFeat(493))
	{
		nDR = 9;
	}	
	else
	if (GetHasFeat(492))
	{
		nDR = 6;
	}
	
	
	if (GetHasFeat(1253))
		nDR++;	
	
	effect eDR = EffectDamageReduction(nDR, DR_TYPE_NONE, 0, DR_TYPE_NONE);
	eDR = SetEffectSpellId(eDR,iSpellId);
	eDR = SupernaturalEffect(eDR);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eDR, OBJECT_SELF, 0.0f, iSpellId ));
	
	HkPostCast(oCaster);
}