/*
	nw_s0_healharm

	Heal/Harm in the one script

	By: Flaming_Sword
	Created: Jun 14, 2006
	Modified: Jun 30, 2006

	Consolidation of heal/harm scripts
	Mass Heal vfx on target looks like heal
	added greater harm, mass harm
*/
#include "_HkSpell"
#include "_CSLCore_Combat"


//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent, int bIsHeal, int iSpellId)
{
	
	return iTouch; 	//return TRUE if spell charges should be decremented
}
*/



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_HARM; // put spell constant here
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
	CSLDebug("nw_s0_healharm running "+IntToString(GetIsPC(OBJECT_SELF)));
	
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	int bIsHeal = IsHeal(iSpellId); //whether it is a heal or harm spell
	
	CSLDebug("nw_s0_healharm running "+IntToString(GetIsPC(OBJECT_SELF)));
	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	int nMetaMagic = HkGetMetaMagicFeat();
	int nHealVFX, nHurtVFX, nEnergyType, nDice, iBlastFaith, nHeal;
	float fRadius;
	string nSwitch;
	int nCap = 150;
	int iAdjustedDamage;
	if(bIsHeal)
	{
		nHealVFX = VFX_IMP_HEALING_X;
		nHurtVFX = VFX_IMP_SUNSTRIKE;
		nEnergyType = DAMAGE_TYPE_POSITIVE;
		//nSwitch = PRC_BIOWARE_HEAL;
		fRadius = RADIUS_SIZE_COLOSSAL;
		if(iSpellId == SPELL_MASS_HEAL)
		{
			nSwitch = PRC_BIOWARE_MASS_HEAL;
			nCap = 250;
		}
	}
	else
	{
		nHealVFX = VFX_IMP_HEALING_G;
		nHurtVFX = 246;
		nEnergyType = DAMAGE_TYPE_NEGATIVE;
		nSwitch = PRC_BIOWARE_HARM;
		fRadius = RADIUS_SIZE_HUGE;
	}
	int iHeal;
	int iAttackRoll = 1;
	if((iSpellId == SPELL_MASS_HARM) || (iSpellId == SPELL_GREATER_HARM))
	{
		nDice = (nCasterLevel > 20) ? 20 : nCasterLevel;
		nHeal = HkApplyMetamagicVariableMods( d12(nDice), 12 * nDice);
		//if(nMetaMagic & METAMAGIC_MAXIMIZE || BlastInfidelOrFaithHeal(oCaster, oTarget, nEnergyType, TRUE))
		//	nHeal = 12 * nDice; //in case higher level spell slots are available
	}
	else
	{
		nHeal = 10 * nCasterLevel;
	}
	
	if ( CSLGetPreferenceSwitch("PNPHeal") )
	{
		nHeal = CSLGetMin( nHeal, nCap);
	}
	
	int bMass = IsMassHealHarm(iSpellId);
	location lLoc;
	if(bMass)
	{
		lLoc = (iSpellId == SPELL_MASS_HARM) ? GetLocation(oCaster) : HkGetSpellTargetLocation();
		oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(bIsHeal ? VFX_FNF_LOS_HOLY_30 : VFX_FNF_LOS_EVIL_20), lLoc);
	}
	float fDelay = 0.0;
	while(GetIsObjectValid(oTarget))
	{
		if(bMass) fDelay = CSLRandomBetweenFloat();
		iHeal = GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
				((!bIsHeal && CSLGetIsUndead( oTarget )) ||
				(bIsHeal &&  !CSLGetIsUndead( oTarget ) ));
		if(iHeal && (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) || (GetIsDead(oTarget) && (GetCurrentHitPoints(oTarget) > -10))))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oTarget));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nHealVFX), oTarget));
			// Code for FB to remove damage that would be caused at end of Frenzy
			SetLocalInt(oTarget, "PC_Damage", 0);
		}
		else if((GetObjectType(oTarget) != OBJECT_TYPE_CREATURE && !bIsHeal) ||
				(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && !iHeal))
		{
			if(!GetIsReactionTypeFriendly(oTarget) && oTarget != oCaster)
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId));
				int iTouch = CSLTouchAttackMelee(oTarget);
				if (iTouch != TOUCH_ATTACK_RESULT_MISS )
				{
					if (!HkResistSpell(oCaster, oTarget))
					{
						int nModify = d4();
						iBlastFaith = BlastInfidelOrFaithHeal(oCaster, oTarget, nEnergyType, TRUE);
						if(nMetaMagic & METAMAGIC_MAXIMIZE || iBlastFaith)
						{
							nModify = 1;
						}
						if((iSpellId == SPELL_MASS_HARM) || (iSpellId == SPELL_GREATER_HARM))
						{
							nHeal = d12(nDice);
							if(nMetaMagic & METAMAGIC_MAXIMIZE || iBlastFaith)
								nHeal = 12 * nDice;
						}
						else
						{
							nHeal = 10 * nCasterLevel;
						}
						if(nHeal > nCap && !CSLGetPreferenceSwitch(nSwitch))
						{
							nHeal = nCap;
						}	
						
						
						nHeal = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORFULLDAMAGE, nHeal, oTarget, HkGetSpellSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_ALL, oCaster, SAVING_THROW_RESULT_ROLL );
					
						/*
						if(HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(oTarget, OBJECT_SELF)))
						{
							nHeal /= 2;
							if (GetHasMettle(oTarget, SAVING_THROW_WILL)) // Ignores partial effects
								nHeal = 0;
						}
						*/
						int nHP = GetCurrentHitPoints(oTarget);
						if (nHeal > nHP - nModify)
						{
							nHeal = nHP - nModify;
						}
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nHeal, nEnergyType), oTarget));
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nHurtVFX), oTarget));
					}
				}
			}
		}
		if(!bMass) break;
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
	}
	//Spell Removal Check
	SpellRemovalCheck(OBJECT_SELF, oTarget);
	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}