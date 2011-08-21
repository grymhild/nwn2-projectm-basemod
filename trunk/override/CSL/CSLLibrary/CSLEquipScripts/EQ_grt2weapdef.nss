//::///////////////////////////////////////////////
//:: Greater Two Weapon Defense
//:: cmi_s2_gtr2wpndef
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 17, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"

void applyGtr2WpnDefense( object oPC )
{
		int iSpellId = SPELLABILITY_Gtr_2Wpn_Defense;
	
		if (GetHasSpellEffect(iSpellId,OBJECT_SELF))
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
		}
		effect eAC = EffectACIncrease(1);
		eAC = EffectLinkEffects(eAC, EffectSkillIncrease(SKILL_PARRY, 2));
		eAC = SupernaturalEffect(eAC);
		eAC = SetEffectSpellId(eAC, iSpellId);
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAC, OBJECT_SELF);	
}

void main()
{	
	//scSpellMetaData = SCMeta_Generic();
	//scSpellMetaData.sSpellName="Gtr_2Wpn_Defense";
	//scSpellMetaData.iCurrentSpell=SPELLABILITY_Gtr_2Wpn_Defense;
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELLABILITY_Gtr_2Wpn_Defense;
	/*
	object oCaster = OBJECT_SELF;
	
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
	*/
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int bIsValid = IsTwoWeaponValid(OBJECT_SELF);
	
	if (bIsValid)
	{
		//if (GetHasSpellEffect(iSpellId,OBJECT_SELF))
	//	{
	//		return;
	//		//RemoveSpellEffects(iSpellId, OBJECT_SELF, OBJECT_SELF);
	//	}	
		 
		float fDelay = CSLRandomBetweenFloat(0.1f, 0.3f );
		DelayCommand( fDelay, applyGtr2WpnDefense( OBJECT_SELF ) );

	}
	else
	{
		if ( CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId ) )
		{
			SendMessageToPC(OBJECT_SELF, "Greater Two-Weapon Defense disabled.");
		}		
	}
}      