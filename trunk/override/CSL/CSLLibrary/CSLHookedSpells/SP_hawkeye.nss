//::///////////////////////////////////////////////
//:: Hawkeye
//:: cmi_s0_hawkeye
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: January 23, 2010
//:://////////////////////////////////////////////
//:: Hawkeye
//:: Transmutation
//:: Level: Druid 1, Ranger 1
//:: Components: V
//:: Range: Personal
//:: Target: You
//:: Duration: 10 minute/level
//:: You gain a +5 bonus on Spot checks and a +1 attack bonus with ranged
//:: weapons.
//:: 
//:: By crying out like a hawk, you improve your eyesight. Distant objects
//:: and creatures seem closer and more distinct.
//:://////////////////////////////////////////////


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HAWKEYE;
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
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_TENMINUTES) );

	object oTarget = HkGetSpellTarget();

	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTarget);
	if (GetIsObjectValid(oWeapon) && GetWeaponRanged(oWeapon))
	{
		effect eSkill = EffectSkillIncrease(SKILL_SPOT, 5);
		effect eAB = EffectAttackIncrease(1);
		effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
		effect eLink = EffectLinkEffects(eSkill, eAB);
		eLink = EffectLinkEffects(eLink, eVis);

		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
	}
	
	HkPostCast(oCaster);
}