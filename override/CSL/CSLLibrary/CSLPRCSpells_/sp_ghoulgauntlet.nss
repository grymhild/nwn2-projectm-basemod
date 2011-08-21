/*
	sp_ghlgaunt

	Ghoul Gauntlet
	Necromancy [Death, Evil]
	Level: Sorcerer/Wizard 6
	Components: V,S
	Casting Time: 1 Standard Action
	Range: Touch
	Target: 1 Living Creature
	Duration: Instantaneous
	Saving Throw: Fortitude Negates
	Spell Resistance: Yes


	Your touch gradually transforms a living victim into
	a ravening, flesh-eating ghoul. The transformation
	process begins at the limb or extremity (usually the
	hand or arm) touched. The victim takes 3d6 points of
	damage per round while the body slowly dies as it is
	transformed into a ghoul's cold undying flesh. When
	the victim reaches 0 hit points, she becomes a ghoul,
	body and mind.

	If the victim fails her initial saving throw, cure
	disease, dispel magic, heal, limited wish, miracle,
	mordenkainen's disjunction, remove curse, wish, or
	greater restoration negates the gradual change.
	Healing spells may temporarily prolong the process
	by increasing the victims HP, but the transformation
	continues unabated.

	The ghoul that you create remains under your control
	indefinitely. No matter how many ghouls you generate
	with this spell, however, you can control only 2 HD
	worth of undead creatures per caster level (this
	includes undead from all sources under your control).
	If you exceed this number, all the newly created
	creatures fall under your control, and any excess
	undead from previous castings become uncontrolled
	(you choose which creatures are released). If you are
	a cleric, any undead you might command by virtue of
	your power to command or rebuke undead do not count
	towards the limit.

	By: Tenjac
	Created: 11/07/05 (Nov 7, 2005?)
	Modified: Jul 2, 2006

	Cleaned up a bit

	To Tenjac:
		converted to holding the charge
		eliminated a lot of white space
		made SummonGhoul() *slightly* more efficient
			(won't set string sGhoul multiple times any more)
		eliminated nHP argument for Gauntlet()
			(GetCurrentHitPoints() is called anyway, makes no difference)
		moved HAS_GAUNTLET local int setting
			(only needs to be set once, right?)
		HAS_GAUNTLET local int is deleted when ghoul is summoned
			(in case you cast this spell on something ressable, eg. PC
				sounds silly, but there it is)
		eliminated excess variables, put some code inline
*/
//#include "prc_sp_func"

#include "_SCInclude_Summon"
#include "_CSLCore_Combat"

void SummonGhoul(int nHD, object oTarget, object oCaster, location lCorpse, int nCasterLevel)
{
	string sGhoul;
	int nGhoulHD;
	if(nHD > 14)//Ghoul King if 15 or better
	{
		sGhoul = "csl_sum_undead_ghoul4";
		nGhoulHD = 16;
	}
	else if(nHD > 11)//Ghoul Ravager if 12 - 14
	{
		sGhoul = "csl_sum_undead_ghoul3";
		nGhoulHD = 9;
	}
	else if(nHD > 8)//Ghoul Lord if levels 9 - 11
	{
		sGhoul = "csl_sum_undead_ghoul2";
		nGhoulHD = 6;
	}
	else if(nHD > 5)//Ghast if levels 6 - 8
	{
		sGhoul = "csl_sum_undead_ghast1";
		nGhoulHD = 4;
	}
	else
	{
		sGhoul = "csl_sum_undead_ghoul1";
		nGhoulHD = 2;
	}


	CSLMultiSummonStacking( oCaster, CSLGetPreferenceInteger("MaxNormalSummons") );
	effect eSummon = EffectSummonCreature(sGhoul, VFX_FNF_SUMMON_UNDEAD);
	//Check for controlled undead and limit
	if(CSLGetPreferenceSwitch(PRC_PNP_ANIMATE_DEAD))
	{
		int nMaxHD = nCasterLevel*4;
		//note GG says 2, animate dead is 4
		//not sure what the "correct" solution is
		//using 4x here otherwise casting order starts to matter
		int nTotalHD = CSLGetControlledUndeadTotalHD();
		if((nTotalHD+nHD)<=nMaxHD)
		{
			//eSummon = ExtraordinaryEffect(eSummon); //still goes away on rest, use supernatural instead
			eSummon = SupernaturalEffect(eSummon);
			HkApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eSummon, HkGetSpellTargetLocation());
		}
		else
		{
			FloatingTextStringOnCreature("You cannot create more undead at this time.", OBJECT_SELF);
		}
		FloatingTextStringOnCreature("Currently have "+IntToString(nTotalHD+nHD)+"HD out of "+IntToString(nMaxHD)+"HD.", OBJECT_SELF);
	}
	else if(!GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster)))
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), HoursToSeconds(24));
}

void Gauntlet(object oTarget, object oCaster, int nHD, int nCasterLevel)
{
	//deal damage
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(d6(3), DAMAGE_TYPE_MAGICAL), oTarget);
	//if target still has HP, run again on next round. Avoids use of loop.
	if(GetCurrentHitPoints(oTarget) > 1)
		DelayCommand(6.0f, Gauntlet(oTarget, oCaster, nHD, nCasterLevel));
	else
	{
		DeleteLocalInt(oTarget, "HAS_GAUNTLET");
		//Get location of corpse
		location lCorpse = GetLocation(oTarget);
		//Apply VFX
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_SMOKE), lCorpse);
		//Summon a ghoul henchman
		SummonGhoul(nHD, oTarget, oCaster, lCorpse, nCasterLevel);
	}
}

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	

	return iTouch; 	//return TRUE if spell charges should be decremented
}
*/


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GHOUL_GAUNTLET; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 

	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_GHOUL_GAUNTLET, oCaster);
	if(GetLocalInt(oTarget, "HAS_GAUNTLET"))
	{
		// Gotta be a living critter
		if ( CSLGetIsLiving(oTarget) )
		{
			int iTouch = CSLTouchAttackMelee(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				//Spell Resistance
				if (!HkResistSpell(oCaster, oTarget ))
				{
					int nDC = HkGetSpellSaveDC(oCaster,oTarget);
					//Saving Throw
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
					{
						if(!GetPlotFlag(oTarget))
						{
							SetLocalInt(oTarget, "HAS_GAUNTLET", 1);
							//ApplyTouchAttackDamage(oCaster, oTarget, iTouch, 0, DAMAGE_TYPE_NEGATIVE);
							int iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, 0, SC_TOUCHSPELL_MELEE, oCaster );
							if ( iDamage > 0 )
							{
								HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
							}
							
							Gauntlet(oTarget, oCaster, GetHitDice(oTarget), nCasterLevel);
						}
					}
				}
			}
		}
	}
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}