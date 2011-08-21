//::///////////////////////////////////////////////
//:: x0_s3_spellstaff
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Sets Things up so next spell can be scribed as a scroll
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "_HkSpell"
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	int iSpellId = SPELL_SCRIBESPELL;
	
	//object oItem = GetItemPossessedBy(OBJECT_SELF, "x0_spellstaff");
	object oCaster = OBJECT_SELF;
	
	SendMessageToPC(oCaster, "Quickly cast the spell you wish to scribe");
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(2, SC_DURCATEGORY_MINUTES) );
	
	effect eDurVis = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurVis, oCaster, fDuration);
	
	//string sTag = GetTag(oItem);
	// SetLocalInt(oItem, "X0_L_SPELL1", SPELL_PREMONITION);
	// SetLocalInt(oItem, "X0_L_SPELL2", SPELL_MAGE_ARMOR);
	//  SetLocalInt(oItem, "X0_L_SPELL3", SPELL_HASTE);
/*
	int nSpell1 = GetCampaignInt("dbItems", "X0_L_spellstaff_SPELL1");
	int nSpell2 = GetCampaignInt("dbItems", "X0_L_spellstaff_SPELL2");
	int nSpell3 = GetCampaignInt("dbItems", "X0_L_spellstaff_SPELL3");
	AssignCommand(oPC, ClearAllActions());
	AssignCommand(oPC, ActionCastSpellAtObject(nSpell1, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	AssignCommand(oPC, ActionCastSpellAtObject(nSpell2, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	AssignCommand(oPC, ActionCastSpellAtObject(nSpell3, OBJECT_SELF, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
	AssignCommand(oPC, ActionDoCommand(SetCommandable(TRUE, oPC)));
	AssignCommand(oPC, SetCommandable(FALSE, oPC));
*/

}