//::///////////////////////////////////////////////
//:: Improved Grenade weapons script
//:: x2_s3_bomb
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	More powerful versions of the standard grenade
	weapons.
	They do 10d6 points of damage and create an
	persistant AOE effect for a 5 rounds


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-08-18
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_SCInclude_Trap"

void main()
{
	//scSpellMetaData = SCMeta_FT_bomb();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MISCELLANEOUS | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	float fDuration = RoundsToSeconds(5);
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	
	if (iSpellId == 745)  // acid bomb
	{
		SCDoGrenade(d6(10),1, VFX_IMP_ACID_L, VFX_FNF_LOS_NORMAL_30,DAMAGE_TYPE_ACID,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_PER_FOGACID, "", "", "", sAOETag), HkGetSpellTargetLocation(), fDuration );
	}
	else if (iSpellId == 744)
	{
		SCDoGrenade(d6(10),1, VFX_IMP_FLAME_M, VFX_FNF_FIREBALL,DAMAGE_TYPE_FIRE,RADIUS_SIZE_HUGE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_PER_FOGFIRE, "", "", "", sAOETag), HkGetSpellTargetLocation(), fDuration);
	}
	
	HkPostCast(oCaster);
}