//::///////////////////////////////////////////////
//:: Oaken Skin
//:: cmi_s2_oakenskin
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 13, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_formastoaken();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = FOREST_MASTER_OAKEN_SKIN;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes =98304;
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
	
	int nACBonus;
	int nForestMaster = GetLevelByClass(CLASS_FOREST_MASTER, OBJECT_SELF);
	
	if (nForestMaster > 6)
	{
		nACBonus = 7;
	}
	else if (nForestMaster > 4)
	{
		nACBonus = 5;
	}
	else
	{
		nACBonus = 3;
	}
	
	if (GetHasFeat(490, OBJECT_SELF))
	{
		nACBonus++;	
	}
	
		
	effect ACBonus =  EffectACIncrease(nACBonus, AC_NATURAL_BONUS);
	ACBonus = SetEffectSpellId(ACBonus,iSpellId);
	ACBonus = SupernaturalEffect(ACBonus);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, ACBonus, OBJECT_SELF, 0.0f, iSpellId));
	
	HkPostCast(oCaster);
}