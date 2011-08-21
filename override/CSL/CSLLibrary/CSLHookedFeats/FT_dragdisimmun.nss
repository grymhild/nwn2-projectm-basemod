//::///////////////////////////////////////////////
//:: Sacred Flesh
//:: cmi_s2_sacredflesh
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: March 23, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_dragdisimmun();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = FEAT_DRAGON_DIS_IMMUNITY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_BUFF;
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
	
	int nDragonDis = GetLocalInt(OBJECT_SELF, "DragonDisciple");
	if (nDragonDis == 0)
	{
		SetupDragonDis();
		nDragonDis = GetLocalInt(OBJECT_SELF, "DragonDisciple");	
	}
	
	int iDamageType = DAMAGE_TYPE_FIRE;	
	if (nDragonDis == 2)
		iDamageType = DAMAGE_TYPE_ACID;
	else
	if (nDragonDis == 3)
		iDamageType = DAMAGE_TYPE_ELECTRICAL;	
	else
	if (nDragonDis == 4)
		iDamageType = DAMAGE_TYPE_COLD;	
	
	effect eImmunity = EffectDamageResistance(iDamageType, 9999, 0);

	eImmunity = SetEffectSpellId(eImmunity,iSpellId);
	eImmunity = SupernaturalEffect(eImmunity);
	
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmunity, OBJECT_SELF);
	
	HkPostCast(oCaster);
}