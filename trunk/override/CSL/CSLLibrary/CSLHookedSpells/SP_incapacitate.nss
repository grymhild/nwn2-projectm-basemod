//::///////////////////////////////////////////////
//:: Incapacitate
//:: sg_s0_incap.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	This spell reduces a creature to 1d4 hp, reduces
	all ability scores to 3 and makes the target immune
	to normal or magical healing short of Heal and
	Greater Restoration.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 28, 2003
//:://////////////////////////////////////////////
//:: Copied from the Condemned spell script with changes
//:: made for the ability change and Heal & Gr Restoration
//:: spells

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	//int iDieType = 4;
	//int iNumDice = 0;
	//int iBonus = 0;
	//int iDamage;

	int iSTR = GetAbilityScore(oTarget,ABILITY_STRENGTH)-3;
	int iDEX = GetAbilityScore(oTarget,ABILITY_DEXTERITY)-3;
	int iCON = GetAbilityScore(oTarget,ABILITY_CONSTITUTION)-3;
	int iINT = GetAbilityScore(oTarget,ABILITY_INTELLIGENCE)-3;
	int iWIS = GetAbilityScore(oTarget,ABILITY_WISDOM)-3;
	int iCHA = GetAbilityScore(oTarget,ABILITY_CHARISMA)-3;
	//int iHeal; // = GetMaxHitPoints(oTarget)-GetCurrentHitPoints(oTarget);
	int iRoll;
	//int	iHealHarmCap = CSLGetPreferenceInteger("PNPHealHarmCap",150); // GetLocalInt(GetModule(),"SG_USE_35_HEALHARM");
	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	int iSpellPower = HkGetSpellPower( oCaster, 15 ); // capping the spell level
	int iDamage = 10*iSpellPower;
	
	// prevent damage from exceeding their total hit points, target always gets 1d4 hitpoints left regardless
	if ( iDamage > GetCurrentHitPoints(oTarget) )
	{
		iDamage = GetCurrentHitPoints(oTarget)-d4();
	}
	
	//int iHeal = iDamage; // the caster heals by this amount of damage
	// This is complete nonsense, it's always 0, need to figure it out and hook it in with the other regular heal/harm scripts
	//iRoll=4-HkApplyMetamagicVariableMods( d4(iNumDice), 4 * iNumDice );
	//if(iRoll<1) iRoll=1;
/*
	if(iUse35Rules)
	{
		iDamage = 10*iSpellPower;
		if(iDamage>150) iDamage = 150;
		iHeal = 10*iSpellPower;
		if(iHeal>150) iHeal = 150;
	}
	else
	{
		iDamage -= iRoll;
		iHeal -= iRoll;
	}
	*/
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eCurse = EffectCurse(iSTR,iDEX,iCON,iINT,iWIS,iCHA);

	effect eCastVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
	effect eImp1 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
	effect eImp2 = EffectVisualEffect(VFX_IMP_DOOM);
	effect eImpLink = EffectLinkEffects(eImp1,eImp2);
	effect eVisDur = EffectVisualEffect(VFX_DUR_PROTECTION_EVIL_MINOR);
	effect eCurseLink = EffectLinkEffects(eVisDur,eCurse);
	effect eVis = EffectVisualEffect(246);
	effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
	effect eHeal =EffectHeal(iDamage);
	effect eDam; //=EffectDamage(iDamage);

		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INCAPACITATE));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT,eCastVis,oCaster);
	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if(!HkResistSpell(oCaster,oTarget))
		{
			if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
			{
				if(CSLGetIsUndead(oTarget))
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
				}
				else
				{
					eImpLink=EffectLinkEffects(eVis,eImpLink);
				}
				HkApplyEffectToObject(DURATION_TYPE_INSTANT,eImpLink,oTarget);
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT,eCurseLink,oTarget);
				int z=0;
				for(z=0; z<=1500; z++)
				{
					z=z; // do nothing;
				}
				if(iDamage>=GetCurrentHitPoints(oTarget)) iDamage=GetCurrentHitPoints(oTarget)-1;
				eDam = HkEffectDamage(iDamage);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}
	}

	//check & adjust alignments
	int iCasterAlignment=GetAlignmentGoodEvil(oCaster);
	int iTargetAlignment=GetAlignmentGoodEvil(oTarget);
	
	if((iCasterAlignment==ALIGNMENT_GOOD) && iTargetAlignment!=ALIGNMENT_EVIL)
	{
		AdjustAlignment(oCaster,ALIGNMENT_EVIL,5);
	}

	HkPostCast(oCaster);
}