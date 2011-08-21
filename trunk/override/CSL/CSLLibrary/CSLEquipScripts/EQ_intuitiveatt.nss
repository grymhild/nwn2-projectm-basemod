//::///////////////////////////////////////////////
//:: Intuitive Attack
//:: cmi_s2_intuitatk
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Jan 11, 2009
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
		object oPC = OBJECT_SELF;
		int iSpellId = SPELLABILITY_INTUITIVE_ATTACK;
		int nIntuiteAttackValid = IsIntuitiveAttackValid();
		int bHasIntuitiveAttack = GetHasSpellEffect(iSpellId,oPC);

		if (nIntuiteAttackValid)
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId );

			int nBoost = 0;
			int nStr = GetAbilityModifier(ABILITY_STRENGTH);
			int nWis = GetAbilityModifier(ABILITY_WISDOM);

			if (GetHasFeat(FEAT_WEAPON_FINESSE, oPC)) //Weapon Finesse
			{
				int nDex = GetAbilityModifier(ABILITY_DEXTERITY);
				if (nDex > nStr)
				{
					nBoost = nWis - nDex;
				}
				else
				{
					nBoost = nWis - nStr;
				}
			}
			else
			{
				nBoost = nWis - nStr;
			}
			
			if (GetHasFeat(FEAT_ZEN_ARCHERY, oPC))
			{
			    object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
				if	(GetIsObjectValid(oWeapon) && GetWeaponRanged(oWeapon))
				{
					SendMessageToPC(oPC,"Intuitive Attack does not stack with Zen Archery.");
					return;
				}
			}
			
			if (!(nBoost > 0))
			{
				return; //No bonus
			}
			
			
			int nCap = CSLGetPreferenceInteger( "CapIntuitiveIfNotPureMonk", 0 ); // GetLocalInt(GetModule(), "CapIntuitiveIfNotPureMonk");
			if (nCap > 0)
			{
				if ( (nBoost > nCap) && (GetHitDice(oPC) != GetLevelByClass(CLASS_TYPE_MONK, oPC)) )
				{
					nBoost = nCap;
				}
			}
			
			
			//Return Codes
			//0 FALSE
			//1 Character Bonus
			//2 Mainhand Only
			//3 Offhand Only
			if (nIntuiteAttackValid == 1)
			{

				effect eAB = EffectAttackIncrease(nBoost);
				eAB = SetEffectSpellId(eAB,iSpellId);
				eAB = SupernaturalEffect(eAB);

				if (!bHasIntuitiveAttack)
				{
					SendMessageToPC(oPC,"Intuitive Attack enabled.");
				}
				DelayCommand(0.1f, HkSafeApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAB, oPC, HoursToSeconds(48), iSpellId));
			}
			else
			if (nIntuiteAttackValid == 2)
			{
				if (!bHasIntuitiveAttack)
				{
					SendMessageToPC(oPC,"Intuitive Attack enabled.");
				}
				object oMain = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
				itemproperty ipAB = ItemPropertyAttackBonus(nBoost);
				CSLSafeAddItemProperty(oMain, ipAB, HoursToSeconds(48),SC_IP_ADDPROP_POLICY_KEEP_EXISTING ,FALSE,FALSE);
			}
			else //3
			{
				if (!bHasIntuitiveAttack)
				{
					SendMessageToPC(oPC,"Intuitive Attack enabled.");
				}
				object oOffhand = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
				itemproperty ipAB = ItemPropertyAttackBonus(nBoost);
				CSLSafeAddItemProperty(oOffhand, ipAB, HoursToSeconds(48),SC_IP_ADDPROP_POLICY_KEEP_EXISTING ,FALSE,FALSE);
			}
		}
		else
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oPC, oPC, iSpellId ); // RemoveSpellEffects(iSpellId, oPC, oPC);
			if (bHasIntuitiveAttack)
			{
				SendMessageToPC(oPC,"Intuitive Attack disabled, you must wield a simple or natural weapon.");
			}
		}
}