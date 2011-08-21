//::///////////////////////////////////////////////
//:: Orb of Acid.
//:: NX2_S0_OrbAcid.nss
//:://////////////////////////////////////////////
/*
	An orb of acid about 3 inches across
	shoots from your palm at its target,
	dealing 1d6 points of acid damage
	per caster level (maximum 15d6). You
	must succeed on a ranged touch attack
	to hit your target.
	A creature struck by the orb takes
	damage and becomes sickened by the
	acid's noxious fumes for 1 round. A
	successful Fortitude save negates the
	sickened effect but does not reduce the
	damage.

	Fort Save failure = "sick" for one round
*/
//:://////////////////////////////////////////////
//:: Created By: Justin Reynard (JWR-OEI)
//:: Created On: Sept 3, 2008
//:://////////////////////////////////////////////
//#include "NW_I0_SPELLS"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower(oCaster,15);
	object oTarget = HkGetSpellTarget();
	int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);
	int iDamage = 0;

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	int iShapeEffect = HkGetShapeEffect( VFX_HIT_AOE_POISON, SC_SHAPE_AOE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iShapeEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ORB_OF_ACID));
		int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS)
		{
			// Orb spells are not resisted!!
			iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), iSpellPower*6 );
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, OBJECT_SELF );


			// Savint throw for "sickened" effect
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
			{
				// failed saving throw, uh oh! SICK!
				effect eDamageDown = EffectDamageDecrease(2);
				effect eThrow = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
				effect eAttackDown = EffectAttackDecrease(2);
				// not linking because I think immunity to one could limit all
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamageDown, oTarget, RoundsToSeconds(1));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eThrow, oTarget, RoundsToSeconds(1));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttackDown, oTarget, RoundsToSeconds(1));
			}
			effect eDam = HkEffectDamage(iDamage, iDamageType, DAMAGE_POWER_NORMAL);
			// visual!!!!
			//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
			//effect eLink = EffectLinkEffects(eFireDamage, eVis);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		}
	}
	HkPostCast(oCaster);
}