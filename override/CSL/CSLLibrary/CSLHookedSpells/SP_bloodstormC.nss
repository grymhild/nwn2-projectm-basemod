//::///////////////////////////////////////////////
//:: Bloodstorm - Heartbeat
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
//#include "sg_i0_spconst"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE );

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

/*
	object oTarget 		= GetExitingObject();
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	float 	fDuration 		= HkGetSpellDuration(SGMaximizeOrEmpower(6,2,iMetamagic));

	//--------------------------------------------------------------------------
	// Spellcast Hook Code
	// Added 2003-06-20 by Georg
	// If you want to make changes to all spells, check x2_inc_spellhook.nss to
	// find out more
	//--------------------------------------------------------------------------
	if (!X2PreSpellCastCode())
	{
		return;
	}
		

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	//int 	iDieType 		= 4;
	//int 	iNumDice 		= 1;
	//int 	iBonus 		= 0;
	//int 	iDamage 		= 0;

	//float 	fRadius 		= FeetToMeters(25.0f/2);
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	if(SGCheckMetamagic(iMetamagic,METAMAGIC_EXTEND)) fDuration *=2;
	//iDamage=SGMaximizeOrEmpower(iDieType,iNumDice,iMetamagic,iBonus);

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis 	= EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	effect eBlind = EffectBlindness();
	effect eEffect;

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(!GetIsObjectValid(oCaster)) {
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_BLOODSTORM );
	} else {
		// MUST USE THE FOLLOWING LOOP AS WE DON'T WANT TO REMOVE THE FEAR EFFECTS
		// WHICH WOULD HAPPEN IF WE USED RemoveSpellEffects(iSpellId, oCaster, oTarget)
		eEffect = GetFirstEffect(oTarget);
		while(GetIsEffectValid(eEffect)) {
			if(GetEffectType(eEffect)==EFFECT_TYPE_BLINDNESS && GetEffectSpellId(eEffect)==SPELL_BLOODSTORM &&
				GetEffectCreator(eEffect)==oCaster) {
				SGRemoveEffect(eEffect, oTarget);
			} else if(GetEffectType(eEffect)==EFFECT_TYPE_ATTACK_DECREASE && GetEffectSpellId(eEffect)==SPELL_BLOODSTORM &&
				GetEffectCreator(eEffect)==oCaster) {
				SGRemoveEffect(eEffect, oTarget);
			}
			eEffect = GetNextEffect(oTarget);
		}
		if(GetLocalInt(oTarget, "BSTM_IS_BLIND")) {
			// If already blinded, target is blinded for 2d6 rounds after leaving the Bloodstorm
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, fDuration);
		}
	}
	DeleteLocalInt(oTarget, "BSTM_IS_BLIND");

	SGClearSpellInfo(oCaster);
*/
}
