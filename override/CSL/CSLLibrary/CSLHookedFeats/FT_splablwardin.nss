//::///////////////////////////////////////////////
//:: Warding of the Spirits
//:: nx_s2_wardspirits.nss
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	A spirit shaman can perform a special rite
	once per day to ward herself and her companions
	against hostile spirits.  The warding lasts for
	10 minutes per level and grants a +2 deflection
	bonus to AC and a +2 resistance bonus on saves
	against attacks made by spirits to all party
	members.  This effect does not stack with the
	shaman's Blessing of the Spirits.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo (AFW-OEI)
//:: Created On: 03/15/2007
//:://////////////////////////////////////////////

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_splablwardin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	//Declare major variables
	int bPCOnly     = FALSE;
	int nShamanLvl  = GetLevelByClass(CLASS_TYPE_SPIRIT_SHAMAN, OBJECT_SELF);
	float fDuration = TurnsToSeconds(10*nShamanLvl);    // 10 minutes per shaman level
	object oLeader  = GetFactionLeader(OBJECT_SELF);
	object oTarget  = GetFirstFactionMember(oLeader, bPCOnly);

	while (GetIsObjectValid(oTarget))
	{
			// Does not stack with itself or with Warding of the Spirits
			if (CSLPCIsClose(OBJECT_SELF, oTarget, 10) &&
				!GetHasSpellEffect(SPELLABILITY_BLESSING_OF_THE_SPIRITS, oTarget) &&
				!GetHasSpellEffect(SPELLABILITY_WARDING_OF_THE_SPIRITS, oTarget) )
			{
				effect eAC   = EffectACIncrease(2, AC_DEFLECTION_BONUS, AC_VS_DAMAGE_TYPE_ALL, TRUE);
				effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL, TRUE);
			
				effect eLink = EffectLinkEffects(eAC, eSave);
			
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WARDING_OF_THE_SPIRITS, FALSE));
			
				//Apply the VFX impact and effects
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELLABILITY_WARDING_OF_THE_SPIRITS );
			}
			
			oTarget = GetNextFactionMember(oLeader, bPCOnly);
	}
	
	HkPostCast(oCaster);
}

