//::///////////////////////////////////////////////
//:: Armor of Frost (and all other Frost Mage abilities)
//:: cmi_s2_armorfrost
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 26, 2008
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/



#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_armorfrost();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_ARMOR_FROST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes =  SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_COLD, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, SPELLABILITY_ARMOR_FROST );
	
	int nClassLevel = GetLevelByClass(CLASS_FROST_MAGE);
	int nFrostAC = ( (nClassLevel - 1) / 3) + 1;
	
	if (GetHasFeat(490, OBJECT_SELF))
	{
		nFrostAC++;
	}
	

	if ( CSLGetPreferenceSwitch("FrostMageArmorStacks",FALSE) )
	{
		int nAC = 0;
		
		object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
		
		//Amulet based AC
		if (GetItemHasItemProperty(oAmuletOld, ITEM_PROPERTY_AC_BONUS))
		{
			itemproperty ipLoop=GetFirstItemProperty(oAmuletOld);
			while (GetIsItemPropertyValid(ipLoop))
			{
			
				//SendMessageToPC(OBJECT_SELF, "InLoop");
			  	if (GetItemPropertyType(ipLoop)==ITEM_PROPERTY_AC_BONUS)
				{
				  nAC = GetItemPropertyParam1Value(ipLoop);
				}
			
			   	ipLoop=GetNextItemProperty(oAmuletOld);
			}		
		}
		//Spell based AC
		int nEffAC;
		int nType;
		effect eEffect = GetFirstEffect(OBJECT_SELF);
		while(GetIsEffectValid(eEffect))
		{
			nType = GetEffectType(eEffect);
			if(nType == EFFECT_TYPE_AC_INCREASE)
			{
				if (GetEffectInteger(eEffect, 0) == 1)
				{
					nEffAC = GetEffectInteger(eEffect, 1);
				}
			}
			eEffect = GetNextEffect(OBJECT_SELF);
		}	
		
		//Final AC	
		if (nEffAC > nAC)
		{
			nAC = nEffAC;
		}
		nAC += nFrostAC;	
	}
	
	effect eLink = EffectACIncrease(nFrostAC, AC_NATURAL_BONUS);
	
	if (nClassLevel == 10) //Cold Immun, Fire Vuln
	{
		effect eImmune = EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0);
		effect eVuln = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50);	
		eLink = EffectLinkEffects(eLink, eImmune);
		eLink = EffectLinkEffects(eLink, eVuln);
	}
	else
	if (nClassLevel > 1) //Cold Resist
	{
		effect eDamRes = EffectDamageResistance(DAMAGE_TYPE_COLD, 10);
		eLink = EffectLinkEffects(eLink, eDamRes);
	}
	
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF, 0.0f, iSpellId));
	
	HkPostCast(oCaster);
}      

