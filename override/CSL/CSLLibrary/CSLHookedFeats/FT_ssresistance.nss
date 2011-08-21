//::///////////////////////////////////////////////
//:: Stormsinger Resist Electricity
//:: cmi_s2_resistelec
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 15, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_ssresistance();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = STORMSINGER_RESIST_ELECTRICITY;
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
	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, -iSpellId );
		
	
	int iValue;
	int nClassLevel = GetLevelByClass(CLASS_STORMSINGER);
	if (nClassLevel > 7)
		iValue = 15;
	else
	if (nClassLevel > 5)
		iValue = 10;
	else
		iValue = 5;
			
	effect eDmgRes =  EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, iValue);
	eDmgRes = SetEffectSpellId(eDmgRes, -iSpellId);
	eDmgRes = SupernaturalEffect(eDmgRes);
	
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDmgRes, OBJECT_SELF);
	
	HkPostCast(oCaster);
}      

