//::///////////////////////////////////////////////
//:: Keen Edge
//:: X2_S0_KeenEdge
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Adds the keen property to one melee weapon,
	increasing its critical threat range.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System


// JLR - OEI 08/24/05 -- Metamagic changes


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void  AddKeenEffectToWeapon(object oMyWeapon, float fDuration)
{
	CSLSafeAddItemProperty(oMyWeapon,ItemPropertyKeen(), fDuration, SC_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
	return;
}

void main()
{
	//scSpellMetaData = SCMeta_SP_keenedge();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_KEEN_EDGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	




	//Declare major variables
	//effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
	effect eDur = EffectVisualEffect( VFX_DUR_SPELL_KEEN_EDGE );
	float fDuration = TurnsToSeconds(10 * HkGetSpellDuration(OBJECT_SELF));

	object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();

	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if(GetIsObjectValid(oMyWeapon) )
	{
			SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

		// AFW-OEI 10/24/2006: Use new engine function.
		int nWeaponType = GetWeaponType(oMyWeapon);
			if (nWeaponType == WEAPON_TYPE_PIERCING ||
			nWeaponType == WEAPON_TYPE_SLASHING ||
			nWeaponType == WEAPON_TYPE_PIERCING_AND_SLASHING)
			{
				if (fDuration>0.0)
				{
					//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
					HkApplyEffectToObject(iDurType, eDur, GetItemPossessor(oMyWeapon), fDuration);
					AddKeenEffectToWeapon(oMyWeapon, fDuration);
				}
				return;
			}
			else
			{
			FloatingTextStrRefOnCreature(83621, OBJECT_SELF); // not a slashing weapon
			return;
			}
		}
		else

		{
			FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
			return;
	}


	HkPostCast(oCaster);
}

