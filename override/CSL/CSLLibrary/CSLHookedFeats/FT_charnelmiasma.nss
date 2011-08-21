//::///////////////////////////////////////////////
//:: Charnel Miasma
//:: cmi_s2_charnelmiasma
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 12, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"


int GetDeathReserveLevel()
{

	if (GetHasSpell(190))
		return 9;
	if (GetHasSpell(29))
		return 8;
	if (GetHasSpell(366))
		return 7;
	if (GetHasSpell(30))
		return 6;
	if (GetHasSpell(164))
		return 5;
	if (GetHasSpell(127))
		return 4;
	if (GetHasSpell(38))
		return 3;												
	if (GetHasSpell(866))
		return 2;
		
	return 0;
}

void main()
{	
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
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
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int nDamageDice = 0;
	
	nDamageDice = GetDeathReserveLevel();
		 
	if (nDamageDice == 0)
	{
		SendMessageToPC(OBJECT_SELF,"You do not have any valid spells left that can trigger this ability.");	
	}
	else
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{		

		}	
	}			


	HkPostCast(oCaster);
}