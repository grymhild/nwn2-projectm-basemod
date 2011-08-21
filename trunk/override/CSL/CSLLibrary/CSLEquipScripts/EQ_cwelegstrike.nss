#include "_HkSpell"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"


/*----  Kaedrin PRC Content ---------*/


void main()
{	
	//scSpellMetaData = SCMeta_FT_cwelegstrike();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELLABILITY_CHAMPWILD_ELEGANT_STRIKE;
	/*
	object oCaster = OBJECT_SELF;
	
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
	*/
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
	

		object oPC = OBJECT_SELF;
		
    	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);			
		int bElegantStrikeValid = isValidElegantStrikeWeapon(oWeapon);
		int bHasElegantStrike = GetHasSpellEffect(iSpellId,oPC);
		
		if (bElegantStrikeValid)
		{

			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );
		// RemoveMethod = SC_REMOVE_FIRSTONLYCREATOR = 1, SC_REMOVE_ONLYCREATOR = 2, SC_REMOVE_FIRSTALLCREATORS = 3, SC_REMOVE_ALLCREATORS = 4
		//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCreatorXXX, oTargetXXX, iSpellId );		
			int nBoost = GetAbilityModifier(ABILITY_DEXTERITY);
			nBoost = CSLGetDamageBonusConstantFromNumber(nBoost, TRUE);
			
			effect eDmg = EffectDamageIncrease(nBoost);
			
			eDmg = SetEffectSpellId(eDmg,iSpellId);
			eDmg = SupernaturalEffect(eDmg);
					
			if (!bHasElegantStrike)
			{
				SendMessageToPC(oPC,"Elegant Strike enabled.");			
			}
			DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDmg, oPC, HoursToSeconds(48), iSpellId ));			
		}
		else
		{
	    	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );
			if (bHasElegantStrike)
			{
				SendMessageToPC(oPC,"Elegant Strike disabled, you must wield a longsword, rapier, scimitar, or silver sword");
			}
		}		
}