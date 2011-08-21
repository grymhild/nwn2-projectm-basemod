//::///////////////////////////////////////////////
//:: Crossbow Sniper
//:: cmi_s2_xbowsniper
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Feb 11, 2008
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"

void ApplyXbowBuff(object oPC, int iSpellId)
{
		int iBonus = GetAbilityModifier(ABILITY_DEXTERITY,oPC);
		
		
		if ( CSLGetPreferenceSwitch("CrossbowSniper50PercentDexCap",FALSE) )
		{
			iBonus = iBonus/2;
		}
		
		if ( iBonus < 1 )
		{
			return;
		}
		
		iBonus = CSLGetDamageBonusConstantFromNumber( iBonus );
		
		if (iBonus == -1)
		{
			return;
		}		
		effect eDam = SupernaturalEffect(EffectDamageIncrease(iBonus,DAMAGE_TYPE_PIERCING));				
		eDam = SetEffectSpellId(eDam,iSpellId);
		DelayCommand(0.1f, HkSafeApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDam, oPC, HoursToSeconds(24), iSpellId ));	
		
}

void XbowSniper(object oPC, int iSpellId, int bInitial)
{
	int bXbowSniperValid = IsXbowSniperValid();
	int bHasXbowSniper = GetHasSpellEffect(iSpellId,oPC);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );
	
	if (bXbowSniperValid)
	{		

		if (!bHasXbowSniper)
		{
			SendMessageToPC(oPC,"Crossbow Sniper enabled.");
		}
		ApplyXbowBuff(oPC, iSpellId);								
	}
	else
	{
		if (bHasXbowSniper)
		{
			SendMessageToPC(oPC,"Crossbow Sniper disabled, it is only valid when wielding a light or heavy crossbow which you have the weapon focus feat with.");			
		}
	}
	if (bInitial)
	{
		DelayCommand(6.0f, XbowSniper(oPC, iSpellId, TRUE));
	}
}

void main()
{	
	//scSpellMetaData = SCMeta_FT_crossbowsnip();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELLABILITY_Crossbow_Sniper;
	/*
	object oCaster = OBJECT_SELF;
	
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_Tif URNABLE;

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
	

	
	//int iSupported = IsModuleSupported (OBJECT_SELF);
	//if (!iSupported)
	//	SetLocalInt(OBJECT_SELF,"XbowSniper",0);
	
	object oPC = OBJECT_SELF;
	if (GetLocalInt(OBJECT_SELF,"XbowSniper") )
	{
		XbowSniper(oPC,iSpellId, FALSE);
	}
	else
	{	
		XbowSniper(oPC,iSpellId, TRUE);
		SetLocalInt(OBJECT_SELF,"XbowSniper",1);
	}
					
		
}