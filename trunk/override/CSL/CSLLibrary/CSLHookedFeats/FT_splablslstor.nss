//::///////////////////////////////////////////////
//:: Storm Avatar
//:: nw_s0_stormlordstormavatar.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	You become empowered by the swift strength and destructive
	fury of a fierce storm, lightning crackling from your eyes for the
	duration of the spell.  Wind under your feet enables you to travel
	at 200% normal speed (effects do not stack with haste, expeditious retreat
	and similar spells) and prevents you from being knocked down by any force
	shot of death.  Missile Weapons fired at you are deflected harmlesly.  Finally
	all melee attacks you make do an additional 3d6 points of electrical damage.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_FT_splablslstor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_STORMLORD_STORM_AVATAR;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	int iCasterLevel = HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); //GetTotalLevels(oCaster, TRUE);
	float fDuration = RoundsToSeconds(2*iCasterLevel);
	CSLUnstackSpellEffects(oCaster, SPELL_STORM_AVATAR, "Storm Avatar");
	object oMyWeapon = CSLGetTargetedOrEquippedMeleeWeapon();
	if (GetIsObjectValid(oMyWeapon))
	{
		int iDamage = IP_CONST_DAMAGEBONUS_2d6;
		if (iCasterLevel > 25)
		{
			iDamage = IP_CONST_DAMAGEBONUS_2d10;
		}
		else if (iCasterLevel > 21)
		{
			iDamage = IP_CONST_DAMAGEBONUS_2d8;
		}
		itemproperty ipElectrify = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_ELECTRICAL, iDamage);
		CSLSafeAddItemProperty(oMyWeapon, ipElectrify, fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE); // FIX: should work with shock weapons too
	}
	if (GetIsObjectValid(oCaster))
	{
		effect eLink = EffectVisualEffect(VFX_SPELL_DUR_STORM_AVATAR);
		eLink = EffectLinkEffects(eLink, EffectMovementSpeedIncrease(200));
		eLink = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
		eLink = EffectLinkEffects(eLink, EffectConcealment(50, MISS_CHANCE_TYPE_VS_RANGED));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	}
	
	HkPostCast(oCaster);
}

