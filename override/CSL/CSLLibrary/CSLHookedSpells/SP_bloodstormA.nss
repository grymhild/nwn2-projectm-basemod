//::///////////////////////////////////////////////
//:: Bloodstorm - On Enter
//:: sg_s0_bldstma.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Evocation [Fear]
	Level: Sor/Wiz 3
	Components: V,S,M
	Casting Time: 1 Full Round
	Range: Medium (100 ft + 10 ft/level
	Area: Column 25 ft wide and 40 ft high
	Duration: 1 round/level
	Saving Throw: See Text
	Spell Resistance: Yes

	Bloodstorm summons a whirlwind of blood that
	envelops the entire area of effect and has
	several effects on those caught within it.
	First, those in the area of effect must make
	Reflex saving throws or be blinded by the
	swirling blood while they remain in the
	whirlwind and for 2d6 rounds thereafter.
	Second, all combatants withing the bloodstorm
	fight at -4 to their attack rolls, and ranged
	attacks that pass through the whirlwind also
	suffer this attack penalty (can't do). Third,
	the blood is slightly acidic and causes 1d4
	points of damage per round. Finally, victims
	must make a Will save or become frightened if
	8HD or above and panicked if less than 8HD.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 15, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	location lTarget 		= GetLocation(OBJECT_SELF);
	int 	iDC; 			//= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	int iDuration = HkApplyMetamagicVariableMods( d6(2), 12 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 4;
	int 	iNumDice 		= 1;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	float 	fRadius 		= FeetToMeters(25.0f/2);

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVisFright = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
	effect eBlind = EffectBlindness();
	effect eAttPenalty = EffectAttackDecrease(4);
	effect eRangePenalty = EffectConcealment(75, MISS_CHANCE_TYPE_VS_RANGED);
	eAttPenalty = EffectLinkEffects(eAttPenalty, eRangePenalty);
	effect eBloodDmg; // damage effect for the acidic blood. must define after amount is known
	effect eFrightened = EffectFrightened();
	effect eLink = EffectLinkEffects(eFrightened, eVisFright);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if ( GetIsObjectValid(oTarget) && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster ) )
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster,SPELL_BLOODSTORM));
		HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eAttPenalty, oTarget);
		if(!HkResistSpell(oCaster, oTarget))
		{
			iDC = HkGetSpellSaveDC(oCaster, oTarget);
			if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC) && !GetLocalInt(oTarget, "BSTM_IS_BLIND"))
			{
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oTarget);
				SetLocalInt(oTarget,"BSTM_IS_BLIND",TRUE);
			}

			iDamage = HkApplyMetamagicVariableMods( CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;
			eBloodDmg = EffectDamage(iDamage);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBloodDmg, oTarget);
			
			
			if ( !HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_FEAR, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER ) )
			{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFrightened, oTarget, fDuration);
				SetLocalInt(oTarget,"BSTM_IS_FRIGHT",TRUE);
				if(GetHitDice(oTarget) <= 8)
				{
					AssignCommand(oTarget, ClearAllActions(TRUE));
					AssignCommand(oTarget, ActionMoveAwayFromLocation(lTarget, TRUE, FeetToMeters(400.0f)));
					SetLocalInt(oTarget,"BSTM_IS_PANIC",TRUE);
				}
			}
		}
	}

}
