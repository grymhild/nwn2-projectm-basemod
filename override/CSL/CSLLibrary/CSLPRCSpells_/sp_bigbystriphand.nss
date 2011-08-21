//::///////////////////////////////////////////////
//:: Name 	Bibgy's Tripping Hand
//:: FileName sp_bigby_trip.nss
//:://////////////////////////////////////////////
/**@file Bigby's Tripping Hand
Evocation[Force]
Level: Duskblade 1, sorcerer/wizard 1
Components: V,S,M
Casting Time: 1 standard action
Range: Medium
Target: One creature
Duration: Intantaneous
Saving Throw: Reflex negates
Spell Resistance: Yes

The large hand sweeps at the target creature's legs in
a tripping maneuver. This trip attempt does not provoke
attacks of opportunity. Its attack bonus equals your
caster level + your key ability modifier + 2 for the
hand's Strength score (14). The hand has a bonus of +1
on the trip attempt for every three caster levels, to a
maximum of +5 at 15th level.

Material component: Three glass beads
**/

int EvalSizeBonus(object oSubject);
//#include "prc_alterations"
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BIGBYS_TRIPPING_HAND; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//


	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nClassType = HkGetSpellClass();
	int nDisplayFeedback;

	// Let the AI know
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_BIGBYS_TRIPPING_HAND, oCaster);

	/*If your attack succeeds, make a Strength check opposed by the
	defender's Dexterity or Strength check (whichever ability score
	has the higher modifier). A combatant gets a +4 bonus for every
	size category he is larger than Medium or a -4 penalty for every
	size category he is smaller than Medium. The defender gets a +4
	bonus on his check if he has more than two legs or is otherwise
	more stable than a normal humanoid. If you win, you trip the
	defender.
	*/
	int nAbility = CSLGetAbilityScoreByClass(oCaster,nClassType);

	int nAttackBonus = (2 + nCasterLvl + GetAbilityModifier(nAbility, oCaster));
	int nTripBonus = CSLGetMin(5,(nCasterLvl/3));

	int iAttackRoll = GetAttackRoll(oTarget, OBJECT_INVALID, OBJECT_INVALID, 0, nAttackBonus,0,nDisplayFeedback, 0.0, SC_TOUCHSPELL_MELEE);
	if (iAttackRoll > 0)
	{
		//SR
		if(!HkResistSpell(oCaster, oTarget ))
		{
			//save
			if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, HkGetSpellSaveDC(oCaster,oTarget), SAVING_THROW_TYPE_SPELL))
			{
				int nOpposing = d20() + (max(GetAbilityModifier(ABILITY_STRENGTH, oTarget), GetAbilityModifier(ABILITY_DEXTERITY, oTarget))) + EvalSizeBonus(oTarget);
				int nCheck 	= d20() + 2 + nTripBonus;

				if(nCheck > nOpposing)
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 6.0f);
				}
			}
		}
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

int EvalSizeBonus(object oSubject)
{
	int nSize = CSLGetSizeCategory(oSubject);
	int nBonus;

	//Eval size

	if(nSize == CREATURE_SIZE_LARGE)
	{
		nBonus = 4;
	}
	else if(nSize == CREATURE_SIZE_HUGE)
	{
		nBonus = 8;
	}
	else if(nSize == CREATURE_SIZE_GARGANTUAN)
	{
		nBonus = 12;
	}
	else if(nSize == CREATURE_SIZE_COLOSSAL)
	{
		nBonus = 16;
	}
	else if(nSize == CREATURE_SIZE_SMALL)
	{
		nBonus = -4;
	}
	else if(nSize == CREATURE_SIZE_TINY)
	{
		nBonus = -8;
	}
	else if(nSize == CREATURE_SIZE_DIMINUTIVE)
	{
		nBonus = -12;
	}
	else if (nSize == CREATURE_SIZE_FINE)
	{
		nBonus = -16;
	}
	else
	{
		nBonus = 0;
	}

	return nBonus;
}
