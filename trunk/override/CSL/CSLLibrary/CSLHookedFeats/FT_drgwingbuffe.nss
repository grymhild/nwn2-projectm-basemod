//::///////////////////////////////////////////////
//:: Dragon Wing Buffet
//:: NW_S1_DragWBuffet
//:://////////////////////////////////////////////
/*
	Applies Dragon Wing Buffet effects to creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Constant Gaw - 8/9/06
//:: Modified By: Brian Fox - 8/21/06
//:://////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Monster"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_EXTRAORDINARY | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//Declare major variables
	int iAge = GetHitDice(OBJECT_SELF);
	int iDC;
	float fDelay;
	float fRandomDuration;
	object oTarget;
	effect eVis, eBreath;
	//Use the HD of the creature to determine save DC
	if (iAge <= 6) //Wyrmling
	{
			iDC = 15;
	}
	else if (iAge >= 7 && iAge <= 9) //Very Young
	{
			iDC = 18;
	}
	else if (iAge >= 10 && iAge <= 12) //Young
	{
			iDC = 19;
	}
	else if (iAge >= 13 && iAge <= 15) //Juvenile
	{
			iDC = 22;
	}
	else if (iAge >= 16 && iAge <= 18) //Young Adult
	{
			iDC = 24;
	}
	else if (iAge >= 19 && iAge <= 22) //Adult
	{
			iDC = 25;
	}
	else if (iAge >= 23 && iAge <= 24) //Mature Adult
	{
			iDC = 28;
	}
	else if (iAge >= 25 && iAge <= 27) //Old
	{
			iDC = 30;
	}
	else if (iAge >= 28 && iAge <= 30) //Very Old
	{
			iDC = 33;
	}
	else if (iAge >= 31 && iAge <= 33) //Ancient
	{
			iDC = 35;
	}
	else if (iAge >= 34 && iAge <= 37) //Wyrm
	{
			iDC = 38;
	}
	else if (iAge > 37) //Great Wyrm
	{
			iDC = 40;
	}
	
	location lSelf = GetLocation(OBJECT_SELF);

	effect eWingBuffet = EffectNWN2SpecialEffectFile("fx_reddr_wbuffet.sef");
	effect eShake = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	
	SCPlayDragonBattleCry();
	PlayCustomAnimation(OBJECT_SELF, "*specialattack01", 0, 1.0f);
	DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWingBuffet, OBJECT_SELF, 3.0f));
	DelayCommand(1.0f, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eShake, lSelf));
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, HkGetSpellTargetLocation(), TRUE);
	//oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, lSelf, TRUE);
	while(GetIsObjectValid(oTarget))
	{
			if(oTarget != OBJECT_SELF && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{
				//Fire cast spell at event for the specified target
 //           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_FIRE));
				//Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.

				if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, SAVING_THROW_TYPE_NONE))
				{
					//Set Damage and VFX
					effect eKnockdown = EffectKnockdown();
					
					//eVis = EffectNWN2SpecialEffectFile("sp_sonic_hit.sef");
					eVis = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
					//Determine effect delay
					fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					fRandomDuration = CSLRandomBetweenFloat(3.0, 10.0);
					//Apply the VFX impact and effects
					
					DelayCommand(0.5 + fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fRandomDuration));
					DelayCommand(0.5 + fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0f));
					//DelayCommand(0.5 + fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(1.5 + fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, 1.0f));
					//DelayCommand(1.5 + fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
					{
						CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN", fRandomDuration, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
					}
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, HkGetSpellTargetLocation(), TRUE);
		//oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GINORMOUS, lSelf, TRUE);
	}
}

// Old variant:

//::///////////////////////////////////////////////
//:: Dragon Wing Buffet
//:: NW_S1_WingBlast
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The dragon will launch into the air, knockdown
	all opponents who fail a Reflex Save and then
	land on one of those opponents doing damage
	up to a maximum of the Dragons HD + 10.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 4, 2002
//:://////////////////////////////////////////////
/*
void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//Declare major variables
	effect eAppear;
	effect eKnockDown = EffectKnockdown();
	int nHP;
	int nCurrent = 0;
	object oVict;
	int iDamage = GetHitDice(OBJECT_SELF);
	int iDC = iDamage;
	iDamage = Random(iDamage) + 11;
	effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING);
	effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
	//Get first target in spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(OBJECT_SELF));
	while(GetIsObjectValid(oTarget))
	{
			if(!GetIsReactionTypeFriendly(oTarget))
			{
					if(GetCreatureSize(oTarget) != CREATURE_SIZE_HUGE)
					{
							if(!ReflexSave(oTarget, iDC))
							{
								DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockDown, oTarget, 6.0);
							}
					}
				//Get next target in spell area
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(OBJECT_SELF));
			}
	}
	location lLocal;
	lLocal = GetLocation(OBJECT_SELF);
	//Apply the VFX impact and effects
	eAppear = EffectDisappearAppear(lLocal);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAppear, OBJECT_SELF, 6.0);

}
*/