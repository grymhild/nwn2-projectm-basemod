//::///////////////////////////////////////////////
//:: Orb of Acid, Lesser.
//:: NX2_S0_OrbAcidLess.nss
//:://////////////////////////////////////////////
/*
	An orb of acid about 2 inches across
	shoots from your palm at its target,
	dealing 1d8 points of acid damage. You
	must succeed on a ranged touch attack
	to hit your target.
	For every two caster levels beyond
	1st, your orb deals an additional 1d8
	points of damage: 2d8 at 3rd level,
	3d8 at 5th level, 4d8 at 7th level, and
	the maximum of 5d8 at 9th level or
	higher.

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
	int iSpellId = SPELL_LESSER_ORB_OF_ACID;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_POISON;
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
	int iSpellPower = ( 1 + HkGetSpellPower(oCaster,10) )/2; // max of 5 at level 9, albeit power boosts can adjust this cap
	object oTarget = HkGetSpellTarget();
	int nCasterLevel = HkGetCasterLevel(OBJECT_SELF);
	int iDamage = 0;
	
		
		//ACID
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	// calculate base damage
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_ORB_OF_ACID));
		int iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS)
		{
			// Orb spells are not resisted!!
			iDamage = HkApplyMetamagicVariableMods( d8(iSpellPower), iSpellPower*8 );
			iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, OBJECT_SELF );
			
			// Saving throw for "sickened" effect
			/*if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
			{
				// failed saving throw, uh oh! SICK!
				effect eDamageDown = EffectDamageDecrease(2);
				effect eThrow = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
				effect eAttackDown = EffectAttackDecrease(2);
				// not linking because I think immunity to one could limit all
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDamageDown, oTarget, RoundsToSeconds(1));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eThrow, oTarget, RoundsToSeconds(1));
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttackDown, oTarget, RoundsToSeconds(1));
			}*/


			effect eDam = HkEffectDamage(iDamage, iDamageType, DAMAGE_POWER_NORMAL);
			// visual!!!!
			//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
			//effect eLink = EffectLinkEffects(eFireDamage, eVis);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);




		}

	}
	HkPostCast(oCaster);
}

