//::///////////////////////////////////////////////
//:: Mindflayer Extract Brain
//:: x2_s1_suckbrain
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The Mindflayer's Extract Brain ability

	Since we can not simulate the When All 4 tentacles
	hit condition reliably, we use this approach for
	extract brain

	It is only triggered through the specialized
	mindflayer AI if the player is helpless.
	(see x2_ai_mflayer for details)

	If the player is helpless, the mindflayer will
	walk up and cast this spell, which has the Suck Brain
	special creature animation tied to it through spells.2da

	The spell first performs a melee touch attack. If that succeeds
	in <Hardcore difficulty, the player is awarded a Fortitude Save
	against DC 10+(HD/2).

	If the save fails, or the player is on a hardcore+ difficulty
	setting, the mindflayer will do d3()+2 points of permanent
	intelligence damage. Once a character's intelligence drops
	below 5, his enough of her brain has been extracted to kill her.

	As a little special condition, if the player is either diseased
	or poisoned, the mindflayer will also become disases or poisoned
	if by sucking the brain.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-01
//:://////////////////////////////////////////////
#include "_HkSpell"


//int    DURATION_TYPE_PERMANENT  = 2;

void DoSuckBrain(object oTarget,int iDamage)
{
	//scSpellMetaData = SCMeta_FT_suckbrain();
	effect eDrain = EffectAbilityDecrease(ABILITY_INTELLIGENCE,iDamage);
	eDrain = ExtraordinaryEffect(eDrain);
	// error with variable on this line
	HkApplyEffectToObject( DURATION_TYPE_PERMANENT, eDrain, oTarget);
}



void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;

	object oTarget = HkGetSpellTarget();
	effect eBlood = EffectVisualEffect(493);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT,eBlood, oTarget);
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{

		int bSave;
		int nDifficulty = GetGameDifficulty();
		// if we are on hardcore  difficulty, we get no save
		if (nDifficulty >= GAME_DIFFICULTY_NORMAL)
		{
			bSave = FALSE;
		}
		else
		{
			bSave = (HkSavingThrow(SAVING_THROW_FORT,oTarget,10+(GetHitDice(OBJECT_SELF)/2)) != 0);
		}
	
		// if we failed the save (or never got one)
		if (!bSave)
		{
				// int below 5? We are braindead
				FloatingTextStrRefOnCreature(85566,oTarget);
				if (GetAbilityScore(oTarget,ABILITY_INTELLIGENCE) <5)
				{
					effect eDeath = EffectDamage(GetCurrentHitPoints(oTarget)+1);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT,eBlood,oTarget);
					DelayCommand(1.5f,HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDeath,oTarget));
				}
				else
				{
					int iDamage = d3()+2;
					// Ok, since the engine prevents ability score damage from the same spell to stack,
					// we are using another "quirk" in the engine to  make it stack:
					// by DelayCommanding the spell the effect looses its SpellID information and stacks...
					DelayCommand(0.01f,DoSuckBrain(oTarget, iDamage));
					// if our target was poisoned or diseased, we inherit that
					if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_POISON ))
					{
						effect ePoison =  EffectPoison(POISON_PHASE_SPIDER_VENOM);
						HkApplyEffectToObject(DURATION_TYPE_PERMANENT,ePoison,OBJECT_SELF);
					}
	
					if (CSLGetHasEffectType( oTarget, EFFECT_TYPE_DISEASE ))
					{
						effect eDisease =  SupernaturalEffect(EffectDisease(DISEASE_SOLDIER_SHAKES));
						HkApplyEffectToObject(DURATION_TYPE_PERMANENT,eDisease,OBJECT_SELF);
	
					}
				}
	
	
		}
	}
}

