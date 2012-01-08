//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "elu_fam_ancom_i"

void main()
{
	//scSpellMetaData = SCMeta_FT_summfamiliar();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )	
		return;	

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oMyPet = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF);
	if (GetIsObjectValid(oMyPet))
	{
		SendMessageToPC(oCaster, "Familiar is already summoned.");
		HkPostCast(oCaster);
		return;
	}
	
	string sOverrideFamiliarResRef = GetFamiliarOverrideResRef(oCaster);
	if (sOverrideFamiliarResRef == "")
		//Yep thats it
		SummonFamiliar();
	else	
		SummonFamiliar(oCaster, sOverrideFamiliarResRef);	

	HkPostCast(oCaster);
}

