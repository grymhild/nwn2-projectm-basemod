//::///////////////////////////////////////////////
//:: Embrace the Wild
//:: cmi_s0_embracewild
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Embrace the Wild
//:: Transmutation
//:: Level: Druid 2, Ranger 1
//:: Components: V
//:: Range: Personal
//:: Target: Self
//:: Duration: 10 minutes/level
//:: Upon casting the spell, you gain the senses of animal creatures. You gain
//:: low-light vision and blind-fighting. You also gain a +2 bonus on Listen and
//:: Spot checks.
//:: 
//:: While picturing a certain kind of animal in your mind, you cry out in
//:: imitation of its most common call. Immediately thereafter, you perceive
//:: your surroundings as the animal you imagined would.
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EMBRACE_WILD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE; // SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = HkGetSpellTarget();	
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES)*10 ); 

	effect eSkill1 = EffectSkillIncrease(SKILL_SPOT, 2);
	effect eSkill2 = EffectSkillIncrease(SKILL_CRAFT_WEAPON, 2);
	effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
	effect eLink = EffectLinkEffects(eSkill1, eSkill2);
	eLink = EffectLinkEffects(eLink, eVis);
	itemproperty iBonusFeat1 = ItemPropertyBonusFeat(386); //BlindFight
	//itemproperty iBonusFeat2 = ItemPropertyBonusFeat(IPRP_FEAT_LOWLIGHTVISION);
	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oCaster);
	if (oArmorNew == OBJECT_INVALID)
	{
		oArmorNew = CreateItemOnObject("x2_it_emptyskin", oCaster, 1, "", FALSE);
		AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat1,oArmorNew,fDuration);
		//AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat2,oArmorNew,fDuration);
		ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);
		DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));
	}
	else
	{
		CSLSafeAddItemProperty(oArmorNew, iBonusFeat1, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
		//CSLSafeAddItemProperty(oArmorNew, iBonusFeat2, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
	}

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	
	HkPostCast(oCaster);
}