//::///////////////////////////////////////////////
//:: x2_s0_cureother
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Cure Critical Wounds on Others - causes 5 points
	of damage to the spell caster as well.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void main()
{
	//scSpellMetaData = SCMeta_FT_crcriticalwo();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_TURNABLE;
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
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int nHeal;
	int iDamage = d8(4);
	int iMetaMagic = GetMetaMagicFeat();
	effect eVis = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
	effect eVis2 = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
	effect eHeal, eDam;

	int nExtraDamage = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF); // * figure out the bonus damage
	if (nExtraDamage > 20)
	{
			nExtraDamage = 20;
	}
	// * if low or normal difficulty is treated as MAXIMIZED
	if(GetIsPC(oTarget) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
	{
			iDamage = 32 + nExtraDamage;
	}
	else
	{
			iDamage = iDamage + nExtraDamage;
	}
	

	//Make metamagic checks
	if (iMetaMagic == METAMAGIC_MAXIMIZE)
	{
			iDamage = 8 + nExtraDamage;
			// * if low or normal difficulty then MAXMIZED is doubled.
			if(GetIsPC(OBJECT_SELF) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
			{
				iDamage = iDamage + nExtraDamage;
			}
	}
	if (iMetaMagic == METAMAGIC_EMPOWER || GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
	{
			iDamage = iDamage + (iDamage/2);
	}


	if ( !CSLGetIsUndead( oTarget, TRUE ) )
	{
			if (oTarget != OBJECT_SELF)
			{
				//Figure out the amount of damage to heal
				nHeal = iDamage;
				//Set the heal effect
				eHeal = EffectHeal(nHeal);
				//Apply heal effect and VFX impact
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);

				//Apply Damage Effect to the Caster
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(5), OBJECT_SELF);
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 31, FALSE));
			}

	}
	//Check that the target is undead
	else
	{
			int iTouch = CSLTouchAttackMelee(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 31));
					if (!HkResistSpell(OBJECT_SELF, oTarget))
					{
							eDam = EffectDamage(iDamage,DAMAGE_TYPE_NEGATIVE);
							//Apply the VFX impact and effects
							DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					}
				}
				//Apply Damage Effect to the Caster
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(5), OBJECT_SELF);
			}
	}
	
	HkPostCast(oCaster);
}

