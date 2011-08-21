// combat ai for quelzarn
//
// .. I'm not using a spellscript here because Quelzarn are often walkrate=immobile
// .. and immobile creatures can't cast spells. Unfortunately, death animations
// .. don't play if 1) custom animations are played in combat AND 2) the creature dies
// .. from a single hit AND 3) the creature is immobile.
//
// .. The creature never uses its bite weapon because 1) it's immobile AND
// .. 2) the model doesn't have any attack animations.

//#include "nw_i0_spells"
//#include "ginc_ai"
#include "_CSLCore_Info"
#include "_SCInclude_AI"
#include "_HkSpell"

// play attack animation and associated sound effects
// .. for some strange reason PlaySound won't work here without using AssignCommand
void AnimationAttack(object oTarget)
{
	string sSFX;
	if (d2() == 1)
		sSFX = "c_quelzarn_atk" + IntToString(d3());
	else
		sSFX = "c_quelzarn_bat" + IntToString(d2());
	AssignCommand(OBJECT_SELF, PlaySound(sSFX));
	SetFacingPoint(GetPosition(oTarget));
	PlayCustomAnimation(OBJECT_SELF, "una_taunt", 0);
}

// hit the target and nearby objects with a freezing blast of water
void BreathWeaponImpact(object oTarget, object oBreathTarget)
{
	// face target
	SetFacingPoint(GetPosition(oTarget));
	
	// vfx at target location
	// .. the temporary object is needed because this vfx fails if applied at a location
	effect eEffect = EffectNWN2SpecialEffectFile("fx_water_breath.sef", oBreathTarget);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, OBJECT_SELF, 2.0);
	DestroyObject(oBreathTarget, 2.5);
	object oSplash = CreateObject(OBJECT_TYPE_PLACED_EFFECT, "n2_fx_splash2", GetLocation(oBreathTarget));
	DestroyObject(oSplash, 2.0);
	
	// damage all creatures within the target radius
	// .. used a sphere instead of spellcone because the creature is so tall
	int nDC = 10 + GetHitDice(OBJECT_SELF);
	location lTarget = GetLocation(oTarget);
	object oCreature = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while (GetIsObjectValid(oCreature))
    {
        if (CSLSpellsIsTarget(oCreature, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oCreature != OBJECT_SELF)
    	{
			float fDelay = GetDistanceBetween(OBJECT_SELF, oCreature)/20;
			if (!HkResistSpell(OBJECT_SELF, oCreature, fDelay))
			{
				int nDamage = GetReflexAdjustedDamage(d8(2), oCreature, nDC, SAVING_THROW_TYPE_COLD);
				if(nDamage > 0)
				{
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_COLD), oCreature));
					DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_drown_hit.sef"), oCreature));		
				}
			}
        }
		oCreature = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}

// paralyze the target
void FascinateImpact(object oTarget)
{
	// face target
	SetFacingPoint(GetPosition(oTarget));

	int nSaveDC = 12;
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_MONSTER));
        if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
            if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC))
            {
			    effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_WILL);
				effect eHit = EffectVisualEffect(VFX_DUR_SPELL_HOLD_MONSTER);
				eParal = EffectLinkEffects(eParal, eHit);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget, RoundsToSeconds(9));
            }
        }
	}
}

// attack the target with our breath weapon
void UseBreathWeapon(object oTarget)
{
	AnimationAttack(oTarget);
	object oBreathTarget = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_secretobject", GetLocation(oTarget));
	DelayCommand(0.5, BreathWeaponImpact(oTarget, oBreathTarget));
}	

// attack the target with fascinate
void UseFascinate(object oTarget)
{
	AnimationAttack(oTarget);
	if (GetHasSpell(SPELL_HOLD_MONSTER))
	{
		if (!CSLGetIsIncapacitated(oTarget,TRUE,TRUE))
		{
			DecrementRemainingSpellUses(OBJECT_SELF, SPELL_HOLD_MONSTER);
			DelayCommand(0.5, FascinateImpact(oTarget));
		}
	}
}

void main()
{
    object oTarget = GetCreatureOverrideAIScriptTarget();
    object oCreature = OBJECT_SELF;
    ClearCreatureOverrideAIScriptTarget();
		
	// find a valid target
	if (!GetIsObjectValid(oTarget))
	{
        oTarget = SCAcquireTarget();
		if (!GetIsObjectValid(oTarget))
		{
			oTarget = SCGetNearestSeenOrHeardEnemyNotDead();
    	}
    	if (GetIsObjectValid(oTarget) == FALSE)
		{
			oTarget = GetLastAttacker();
		}
	}
	
    // make sure the target is hostile
    if (GetIsObjectValid(oTarget))
    {
        if (!GetIsEnemy(oTarget, oCreature) || GetIsDead(oTarget))
        {
            return;
        }
    }
	
    // make sure the AI isn't already running
    if (GetLocalInt(oCreature, "HF_AI_RUNNING"))
    {
        return;
    }
    SetLocalInt(oCreature, "HF_AI_RUNNING", 1);
		
	// attack with breath weapon every second round
	if (GetLocalInt(oCreature, "HF_COMBAT_STATE") == 0)
	{
		SetLocalInt(oCreature, "HF_COMBAT_STATE", 1);
		UseBreathWeapon(oTarget);
	}
	else
	{
		SetLocalInt(oCreature, "HF_COMBAT_STATE", 0);
		UseFascinate(oTarget);
	}
	
	// done; fall through to main AI	
	SetLocalInt(oCreature, "HF_AI_RUNNING", 0);
}