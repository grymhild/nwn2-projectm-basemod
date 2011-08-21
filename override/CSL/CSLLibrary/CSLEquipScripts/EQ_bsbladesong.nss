//::///////////////////////////////////////////////
//:: Bladesong Style
//:: cmi_s2_bladesong
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Jan 19, 2008
//:://////////////////////////////////////////////

#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"
#include "_SCInclude_Class"

/*----  Kaedrin PRC Content ---------*/


/*
void ApplyACBuff(object oPC, int iSpellId)
{
		int iLevel = GetLevelByClass(CLASS_BLADESINGER,oPC);
		int nAC = iLevel;	
		int nInt = GetAbilityScore(oPC, ABILITY_INTELLIGENCE);	
		int nIntBonus = 0;
					
		if (nInt > 11)
			nIntBonus = (nInt - 10)/2;
					
		if (iLevel > nIntBonus)
			nAC = nIntBonus;

		if (nAC == 0)
			return;
				
		effect eAC = SupernaturalEffect(EffectACIncrease(nAC, AC_DODGE_BONUS));				
		eAC = SetEffectSpellId(eAC,iSpellId);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, 6.0f);		
		
}
*/

/*
void Bladesong(object oPC, int iSpellId, int bInitial, int nRandom)
{
	int bBladesongStyleValid = IsBladesingerValid();
	int bHasBladesongStyle = GetHasSpellEffect(iSpellId,oPC);
	
	RemoveSpellEffects(iSpellId, oPC, oPC);
	
	if (bBladesongStyleValid)
	{		

		if (!bHasBladesongStyle)	
			//SendMessageToPC(oPC,"Bladesong Style enabled." + IntToString(nRandom));
			SendMessageToPC(oPC,"Bladesong Style enabled.");			
		ApplyACBuff(oPC, iSpellId);								
	}
	else
	{
		if (bHasBladesongStyle)
			SendMessageToPC(oPC,"Bladesong Style disabled, it is only valid when wielding a longsword or rapier in one hand (and nothing in the other) and wearing light or no armor.");			
	}
	if (bInitial)
		DelayCommand(6.0f, Bladesong(oPC, iSpellId, TRUE, nRandom));	
}
*/

void ApplyACBuff()
{
		int iLevel = GetLevelByClass(CLASS_BLADESINGER,OBJECT_SELF);
		int nAC;	
		int nInt = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE);	
		int nIntBonus = 0;
					
		if (nInt > 11)
			nIntBonus = (nInt - 10)/2;
			
		nAC = nIntBonus;
		
		int nIB = GetLevelByClass(CLASS_TYPE_INVISIBLE_BLADE);
		int nDuel = GetLevelByClass(CLASS_TYPE_DUELIST);
		if (nIB > nDuel)
			nDuel = nIB;
		if (iLevel > nDuel)
		{
			iLevel = iLevel - nDuel;
		}
		else
			return;
			
		if (nIntBonus > iLevel)
			nAC = iLevel;

		if (nAC == 0)
			return;
				
		effect eAC = SupernaturalEffect(EffectACIncrease(nAC, AC_DODGE_BONUS));				
		eAC = SetEffectSpellId(eAC,BLADESINGER_BLADESONG_STYLE);
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, OBJECT_SELF, HoursToSeconds(48), BLADESINGER_BLADESONG_STYLE ));		
		
}

void Bladesong( object oPC )
{
	int bBladesongStyleValid = IsBladesingerValid();
	int bHasBladesongStyle = GetHasSpellEffect(BLADESINGER_BLADESONG_STYLE,oPC);
	
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, BLADESINGER_BLADESONG_STYLE );
	
	if (bBladesongStyleValid)
	{		

		if (!bHasBladesongStyle)
		{
			//SendMessageToPC(oPC,"Bladesong Style enabled." + IntToString(nRandom));
			SendMessageToPC(oPC,"Bladesong Style enabled.");			
		}
		DelayCommand(0.1f, ApplyACBuff() );
	}
	else
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, BLADESINGER_SONG_FURY );
		if (bHasBladesongStyle)
		{
			SendMessageToPC(oPC,"Bladesong Style disabled, it is only valid when wielding a longsword or rapier in one hand (and nothing in the other) and wearing light or no armor.");
		}
	}
}

void main()
{	
	//scSpellMetaData = SCMeta_FT_bsbladesong();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = BLADESINGER_BLADESONG_STYLE;
	object oCaster = OBJECT_SELF;
	/*
	
	
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	/*
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	*/
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	
	DelayCommand(0.1f, Bladesong( oCaster ) );
}