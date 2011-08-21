//::///////////////////////////////////////////////
//:: Glyph of Warding Heartbet
//:: x2_o0_glyphhb
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Default Glyph of warding damage script

	This spellscript is fired when someone triggers
	a player cast Glyph of Warding


	Check x2_o0_hhb.nss and the Glyph of Warding
	placeable object for details

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

#include "_HkSpell"

void DoDamage(int iDamage, object oTarget)
{
	effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
	effect eDam = EffectDamage(iDamage, DAMAGE_TYPE_SONIC);
	if(iDamage > 0)
	{
			//Apply VFX impact and damage effect
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
			DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	}
}

void main()
{
	int iAttributes =106881;
	//Declare major variables
	object oTarget = GetLocalObject(OBJECT_SELF,"X2_GLYPH_LAST_ENTER");
	location lTarget = GetLocation(OBJECT_SELF);
	effect eDur = EffectVisualEffect(445);
	int iDamage;
	int iCasterLevel =   GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_LEVEL");
	int iMetaMagic = GetLocalInt(OBJECT_SELF,"X2_PLC_GLYPH_CASTER_METAMAGIC");
	object oCreator = GetLocalObject(OBJECT_SELF,"X2_PLC_GLYPH_CASTER") ;


	if ( GetLocalInt (OBJECT_SELF,"X2_PLC_GLYPH_PLAYERCREATED") == 0 )
	{
			oCreator = OBJECT_SELF;
	}

	if (!GetIsObjectValid(oCreator))
	{
			DestroyObject(OBJECT_SELF);
			return;
	}

	int iDice = iCasterLevel /2;

	if (iDice > 5)
			iDice = 5;
	else if (iDice <1 )
			iDice = 1;

	effect eDam;
	effect eExplode = EffectVisualEffect(459);

	//Check the faction of the entering object to make sure the entering object is not in the casters faction

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	//Cycle through the targets in the explosion area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while(GetIsObjectValid(oTarget))
	{
				if (CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_STANDARDHOSTILE,oCreator))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(oCreator, GetSpellId()));
					//Make SR check
					if (!HkResistSpell(oCreator, oTarget))
					{
						iDamage = HkApplyMetamagicVariableMods(d8(iDice), 8 * 5);
						//Change damage according to Reflex, Evasion and Improved Evasion
						iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_SONIC, oCreator);


						//----------------------------------------------------------
						// Have the creator do the damage so he gets feedback strings
						//----------------------------------------------------------
						if (oCreator != OBJECT_SELF)
						{
							AssignCommand(oCreator, DoDamage(iDamage,oTarget));
						}
						else
						{
							DoDamage(iDamage,oTarget);
						}

					}
				}
				//Get next target in the sequence
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
}