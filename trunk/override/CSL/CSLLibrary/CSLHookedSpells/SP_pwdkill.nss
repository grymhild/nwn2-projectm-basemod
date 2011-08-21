//::///////////////////////////////////////////////
//:: Power Word, Kill
//:: NW_S0_PWKill
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// When power word, kill is uttered, you can either
// target a single creature or let the spell affect a
// group.
// If power word, kill is targeted at a single creature,
// that creature dies if it has 100 or fewer hit points.
// If the power word, kill is cast as an area spell, it
// kills creatures in a 15-foot-radius sphere. It only
// kills creatures that have 20 or fewer hit points, and
// only up to a total of 200 hit points of such
// creatures. The spell affects creatures with the lowest.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Dec 18, 2000
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: Update Pass By: Preston W, On: Aug 3, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_SP_pwdkill();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POWER_WORD_KILL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DEATH|SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	object oTarget = HkGetSpellTarget();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int nDamageDealt = 0;
	int nHitpoints, nMin;
	object oWeakest;
	effect eDeath = EffectDeath();
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT);
	effect eWord =  EffectVisualEffect(VFX_HIT_AOE_ENCHANTMENT);
	float fDelay;
	int bKill;
	//Check for the single creature or area targeting of the spell
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_KILL));
			//Check the creatures HP
			if ( GetCurrentHitPoints(oTarget) <= 100 )
			{
				if(!HkResistSpell(OBJECT_SELF, oTarget))
				{
					//Apply the death effect and the VFX impact
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				}
			}
		}
	}
	else
	{
		//Apply the VFX impact
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWord, HkGetSpellTargetLocation());
		//Continue through the while loop while the damage deal is less than 200.
		while (nDamageDealt < 200)
		{
			//Set nMin higher than the highest HP amount allowed
			nMin = 25;
			oWeakest = OBJECT_INVALID;
			//Get the first target in the spell area
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
			while (GetIsObjectValid(oTarget))
			{
				//Make sure the target avoids all allies.
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					bKill = GetLocalInt(oTarget, "NW_SPELL_PW_KILL_" + GetTag(OBJECT_SELF));
					//Get the HP of the current target
					nHitpoints = GetCurrentHitPoints(oTarget);
					//Check if the currently selected target is lower in HP than the weakest stored creature
					if ((nHitpoints < nMin) && ((nHitpoints > 0) && (nHitpoints <= 20)) && bKill == FALSE)
					{
						nMin = nHitpoints;
						oWeakest = oTarget;
					}
				}
				//Get next target in the spell area
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
			}
			//If no weak targets are available then break out of the loop
			if (!GetIsObjectValid(oWeakest))
			{
				nDamageDealt = 250;
			}
			else
			{
				fDelay = CSLRandomBetweenFloat(0.75, 2.0);
				SetLocalInt(oWeakest, "NW_SPELL_PW_KILL_" + GetTag(OBJECT_SELF), TRUE);
				//Fire cast spell at event for the specified target
				SignalEvent(oWeakest, EventSpellCastAt(OBJECT_SELF, SPELL_POWER_WORD_KILL));
				if(!HkResistSpell(OBJECT_SELF, oWeakest, fDelay))
				{
					//Apply the VFX impact and death effect
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oWeakest));
					if(!GetIsImmune(oWeakest, IMMUNITY_TYPE_DEATH))
					{
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oWeakest));
					}
					//Add the creatures HP to the total
					nDamageDealt = nDamageDealt + nMin;
					string sTag = "NW_SPELL_PW_KILL_" + GetTag(OBJECT_SELF);
					DelayCommand(fDelay + 0.25, DeleteLocalInt(oWeakest, sTag));
				}
			}
		}
	}
	HkPostCast(oCaster);
}

