//::///////////////////////////////////////////////
//:: Darkness: On Enter
//:: NW_S0_DarknessA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
/*
	Creates a globe of darkness around those in the area
	of effect.
	
	Darkness
	Evocation [Darkness]
	Level:	Brd 2, Clr 2, Sor/Wiz 2
	Components:	V, M/DF
	Casting Time:	1 standard action
	Range:	Touch
	Target:	Object touched
	Duration:	10 min./level (D)
	Saving Throw:	None
	Spell Resistance:	No
	This spell causes an object to radiate shadowy illumination out to a
	20-foot radius. All creatures in the area gain concealment (20% miss
	chance). Even creatures that can normally see in such conditions (such
	as with darkvision or low-light vision) have the miss chance in an area
	shrouded in magical darkness.
	
	Normal lights (torches, candles, lanterns, and so forth) are incapable
	of brightening the area, as are light spells of lower level. Higher
	level light spells are not affected by darkness.
	
	If darkness is cast on a small object that is then placed inside or
	under a lightproof covering, the spell’s effect is blocked until the
	covering is removed.
	
	Darkness counters or dispels any light spell of equal or lower spell
	level.
	
	Arcane Material Component A bit of bat fur and either a drop of pitch
	or a piece of coal.

*/
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Light"


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_DARKNESS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	if ( GetSpellId() == SPELLABILITY_AS_DARKNESS )
	{
		iSpellId = SPELLABILITY_AS_DARKNESS;
	}
	else if ( GetSpellId() == SPELL_ASN_Darkness ||  GetSpellId() == SPELL_ASN_Spellbook_2  )
	{
		iSpellId = SPELL_ASN_Darkness;
		iClass = CLASS_TYPE_ASSASSIN;
	}
	else if ( GetSpellId() == SPELL_BG_Darkness )
	{
		iSpellId = SPELL_BG_Darkness;
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	else if ( GetSpellId() == SPELL_SHADOW_CONJURATION_DARKNESS )
	{
		iSpellId = SPELL_SHADOW_CONJURATION_DARKNESS;
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = 2;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_DARKNESS, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	
	if ( GetIsObjectValid(oTarget) )
	{
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator() ) )
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), TRUE ));
		}
		else
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		}
		
		if(!CSLEnviroGetHasHigherLevelDarknessEffect(iSpellLevel, oTarget))
		{
			if ( CSLEnviroRemoveLowerLevelLightEffect(iSpellLevel, oTarget) )
			{
				SendMessageToPC( oTarget, "The Light Was Extinguished By Darkness");
			}
	
			// This spell should not use spell resistance or affect mantles.
			if ( !CSLGetHasEffectSpellIdGroup( oTarget, EFFECT_TYPE_ULTRAVISION, SPELL_BLINDSIGHT, SPELL_TRUE_SEEING ) && GetTag(GetItemInSlot(INVENTORY_SLOT_HEAD, oTarget)) != "X0_ARMHE017") //Helm of Darkness
			{
				effect eMissChance = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
				eMissChance = EffectLinkEffects(eMissChance, EffectConcealment(20, MISS_CHANCE_TYPE_NORMAL));
				eMissChance = EffectLinkEffects(eMissChance, EffectEffectIcon(47));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMissChance, oTarget, RoundsToSeconds(20));
				
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_EVIL), oTarget);
			}
		}
	}
}