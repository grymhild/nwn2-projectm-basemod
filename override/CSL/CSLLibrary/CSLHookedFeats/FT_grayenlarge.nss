//::///////////////////////////////////////////////
//:: Enlarge Person (Duergar Racial Ability)
//:: NW_S2_EnlrgePer.nss
//:://////////////////////////////////////////////
/*
	Target creature increases in size 50%.  Gains
	+2 Strength, -2 Dexterity, -1 to Attack and
	-1 AC penalties.  Melee weapons gain +3 Dmg.
*/

// JLR-OEI 03/16/06: For GDD Update



// JLR - OEI 08/23/05 -- Permanency & Metamagic changes
#include "_HkSpell"



/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_grayenlarge();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
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
	

// End of Spell Cast Hook


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iCasterLevel = HkGetSpellPower(oCaster,3,CLASS_TYPE_RACIAL); // GetTotalLevels(OBJECT_SELF, TRUE) * 2; //HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	//if(iCasterLevel < 3)
	//{
	//	iCasterLevel = 3;
	//}
	float fDuration = TurnsToSeconds(iCasterLevel);

	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// JBH - 08/11/05 - OEI
	// Currently, if there are any size enlarging spells on the character
	// casting another should fail
	if ( CSLGetHasSizeIncreaseEffect( oTarget ) == TRUE )
	{
		// TODO: fizzle effect?
		FloatingTextStrRefOnCreature( 3734, oTarget );  //"Failed"
		return;
	}

	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, GetSpellId());
	CSLRemovePermanencySpells(oTarget);

	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENLARGE_PERSON);

	effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 2);
	effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 2);
	effect eAtk = EffectAttackDecrease(1, ATTACK_BONUS_MISC);
	effect eAC = EffectACDecrease(1, AC_DODGE_BONUS);
	effect eDmg = EffectDamageIncrease(3, DAMAGE_TYPE_MAGICAL );   // Should be Melee-only!
	effect eScale = EffectSetScale(1.5);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
	effect eLink = EffectLinkEffects(eStr, eDex);
	eLink = EffectLinkEffects(eLink, eAtk);
	eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, eDmg);
	eLink = EffectLinkEffects(eLink, eScale);
	eLink = EffectLinkEffects(eLink, eDur);

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	// Delay increasing size for 2 seconds to let enough particles spawn from the
	// hit fx to obscure the pop in size.
	DelayCommand(1.5, HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration));
	
	HkPostCast(oCaster);
}