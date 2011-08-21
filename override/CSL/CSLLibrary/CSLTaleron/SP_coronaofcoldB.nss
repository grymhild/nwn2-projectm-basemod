//::///////////////////////////////////////////////
//:: Body of the Sun
//:: nw_s0_bodysun.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	By drawing on the power of the sun, you cause your body to emanate fire.
	Fire extends 5 feet in all directions from your body, illuminating the
	area and dealing 1d4 points of fire damage per two caster levels (maximum 5d4)
	to adjacent enemies every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 18, 2006
//:://////////////////////////////////////////////
//:: AFW-OEI 07/06/2007: Do random damage to each target.
//#include "nwn2_inc_spells"
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_metmag"


#include "_HkSpell"

void main()
{	
	
	/*
		Spellcast Hook Code
		Added 2003-07-07 by Georg Zoeller
		If you want to make changes to all spells,
		check x2_inc_spellhook.nss to find out more

	*/
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object	oTarget;
	object	oCreator		=	GetAreaOfEffectCreator();
	int		nCasterLevel	=	HkGetCasterLevel(oCreator);
	int		nDamValue;
	int		nMax;
	effect	eFireDamage;
	effect	eFireHit		=	EffectVisualEffect(VFX_COM_HIT_FROST);
	effect	eSTR			= 	EffectAbilityDecrease(ABILITY_STRENGTH,2);
	effect	eDEX			= 	EffectAbilityDecrease(ABILITY_DEXTERITY,2);
	effect eMove			= 	EffectMovementSpeedDecrease(50);
	effect	eLink			= 	EffectLinkEffects(eSTR,eDEX);
			eLink			=	EffectLinkEffects(eLink,eMove);


//If the caster is dead, kill the AOE

	if (!GetIsObjectValid(oCreator))
	{
		DestroyObject(OBJECT_SELF);
	}

//Find our first target
	oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);

//This loop validates target, makes it save, burns it, then finds the next target and repeats
	while(GetIsObjectValid(oTarget))
	{
		if (oTarget != oCreator)
		{


			if (!HkResistSpell(oCreator, oTarget))
			{
				//Determine damage
				nDamValue		=	d12(1);
				nDamValue		=	HkApplyMetamagicVariableMods(nDamValue,12);

				//Adjust damage via Reflex Save or Evasion or Improved Evasion

		if (HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_COLD,oCreator)) nDamValue = 0;

				if (nDamValue > 0)
				{

					eFireDamage	=	EffectDamage(nDamValue, DAMAGE_TYPE_COLD);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFireDamage, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFireHit, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,6.0);
				}
			}
		}

		oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE);
	}
}

