/** @file
* @brief Include File for Wild Effects
*
* 
* 
*
* @ingroup scinclude
* @author 2Drunk, Brian T. Meyer and others
*/

#include "_HkSpell"

void SCFireworks(object oCaster)
{
	effect eVis1 = EffectVisualEffect(VFX_DUR_FIREWORKS);
	effect eVis2 = EffectVisualEffect(VFX_STREAMER_SPARKLER);
	effect eSound1 = EffectVisualEffect(VFX_DUR_FIREWORKS_BOOM_1);
	effect eSound2 = EffectVisualEffect(VFX_DUR_FIREWORKS_BOOM_2);
	effect eSound3 = EffectVisualEffect(VFX_DUR_FIREWORKS_BOOM_3);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis1,oCaster,8.0);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis2,oCaster,8.0);
	
	DelayCommand(2.0f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound1,oCaster,6.0));
	DelayCommand(2.5f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound2,oCaster,6.0));
	DelayCommand(3.0f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound3,oCaster,6.0));
	
	DelayCommand(3.2f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound1,oCaster,6.0));
	DelayCommand(3.8f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound2,oCaster,6.0));
	DelayCommand(3.5f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound3,oCaster,6.0));
	
	DelayCommand(4.3f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound1,oCaster,6.0));
	DelayCommand(4.8f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound2,oCaster,6.0));
	DelayCommand(4.6f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound3,oCaster,6.0));
	
	DelayCommand(5.7f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound1,oCaster,6.0));
	DelayCommand(5.0f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound2,oCaster,6.0));
	DelayCommand(5.4f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound3,oCaster,6.0));
	
	DelayCommand(6.3f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound1,oCaster,6.0));
	DelayCommand(6.9f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound2,oCaster,6.0));
	DelayCommand(6.2f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound3,oCaster,6.0));
	
	DelayCommand(7.3f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound1,oCaster,6.0));
	DelayCommand(7.6f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound2,oCaster,6.0));
	DelayCommand(7.1f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eSound3,oCaster,6.0));
	
}




void SCAOEKnockdown(object oCaster)
{
	float fRadius = 22.5; // 68 feet
	location lTarget = GetLocation(oCaster);
	effect eVis = EffectVisualEffect(VFX_DUR_AOE_KNOCKDOWN);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oCaster,RoundsToSeconds(1));

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,fRadius,lTarget,TRUE,OBJECT_TYPE_CREATURE);
	if(oTarget == oCaster)
	{
		oTarget = GetNextObjectInShape(SHAPE_SPHERE,fRadius,lTarget,TRUE,OBJECT_TYPE_CREATURE);
	}
	
	while(GetIsObjectValid(oTarget))
	{
		effect eKnock = EffectKnockdown();
		
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKnock,oTarget,6.0);
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE,fRadius,lTarget,TRUE,OBJECT_TYPE_CREATURE);
		if(oTarget == oCaster)
		{
			oTarget = GetNextObjectInShape(SHAPE_SPHERE,fRadius,lTarget,TRUE,OBJECT_TYPE_CREATURE);
		}
	}
}


void SCRandomLimb(object oTarget)
{
	
	int nTempSpellId = SURGE_TEMP_SPELLID_RANDOM_LIMB;
	
	int nBody;	
	int nRand = Random(8);
	
	switch(nRand)
	{
		case 0 : nBody = VFX_DUR_BEAR_MUZ; break;
		case 1 : nBody = VFX_DUR_CHICKEN_LEG; break;
		case 2 : nBody = VFX_DUR_F_HAND; break;
		case 3 : nBody = VFX_DUR_MIND_F_MOUTH; break;
		case 4 : nBody = VFX_DUR_SPIDER_LEG; break;
		case 5 : nBody = VFX_DUR_TENTICLE; break;
		case 6 : nBody = VFX_DUR_WING; break;
		case 7 : nBody = VFX_DUR_UMBER_ARM; break;
		default : break;
	}
	
	effect eVis = EffectVisualEffect(nBody);
	effect eChr = EffectAbilityDecrease(ABILITY_CHARISMA,1);
	effect eLink = EffectLinkEffects(eVis,eChr);
	eLink = SupernaturalEffect(eLink);
	//eLink = SetEffectSpellId(eLink,nSpellId);
		
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT,SetEffectSpellId(eLink,nTempSpellId),oTarget);
	SetLocalInt(oTarget,"nRandomLimbId",nTempSpellId);
	//DelayCommand(fDur,RemoveSupernaturalEffectWithSpellId(oTarget,nSpellId));
}


void SCShrieker(location lOriginalTarget, object oCaster, int iShieldSuccess)
{
	//location lTarget = GetLocation(oTarget);
	//object oOriginalTarget = oTarget;
	//float fRadius = 100.0; //this is a really big area
	float fRadius = 75.0; // shaz: now that they actually respond, i turned it down a bit
	
	object oPC = GetFirstPC();
	//SendMessageToPC("SCShrieker! 
	
	effect eVis = EffectVisualEffect(VFX_FNF_SHRIEKER);
	//effect eVis = EffectVisualEffect(VFX_FNF_FIREBALL);
	//JXApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,eVis,lOriginalTarget,RoundsToSeconds(1));
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lOriginalTarget);
	//DelayCommand(3.0,AssignCommand(oTarget,PlaySound("2d2f_shreak")));
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,fRadius,lOriginalTarget,FALSE,OBJECT_TYPE_CREATURE);
	
	if(iShieldSuccess != 0 && oTarget == oCaster)
	{
		GetNextObjectInShape(SHAPE_SPHERE,fRadius,lOriginalTarget,FALSE,OBJECT_TYPE_CREATURE);
	}	
		
	while(GetIsObjectValid(oTarget))
	{
		//this should alert the target that something happened , and they may come looking
		//SignalEvent(oTarget,EventSpellCastAt(oTarget,SPELL_MAGIC_MISSILE, TRUE));
		if(GetIsEnemy(oTarget, oCaster) && !GetIsInCombat(oTarget))
		{
			//AssignCommand(oTarget, SCAIDetermineCombatRound(oCaster));
			// Shaz: should we have them sprint to the sound or walk there? Walking seems to make more sense, and looks a little cooler. ;-)
			AssignCommand(oTarget, ActionMoveToLocation(lOriginalTarget, FALSE));
		}
	
		float fDist = GetDistanceBetweenLocations(lOriginalTarget,GetLocation(oTarget));
		if(fDist < 10.0)
		{
		float fDur = RoundsToSeconds(d3(1));
		effect eDeaf = EffectDeaf();
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oTarget,fDur);
		}
				
		oTarget = GetNextObjectInShape(SHAPE_SPHERE,fRadius,lOriginalTarget,FALSE,OBJECT_TYPE_CREATURE);
		if(iShieldSuccess != 0 && oTarget == oCaster)
		{
			GetNextObjectInShape(SHAPE_SPHERE,fRadius,lOriginalTarget,FALSE,OBJECT_TYPE_CREATURE);
		}
		
	}
}


void SCSmokeyEars(object oCaster, int iShieldSuccess)
{
	location lTarget = GetLocation(oCaster);
	float fDur = TurnsToSeconds(1);
	effect eVis = EffectVisualEffect(VFX_DUR_SMOKEY_EARS);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,FeetToMeters(60.0),lTarget,FALSE,OBJECT_TYPE_CREATURE);
	
	//:2d2f skip the caster if protected from surge
	if(iShieldSuccess != 0 && oTarget == oCaster)
	{
	oTarget = GetNextObjectInShape(SHAPE_SPHERE,FeetToMeters(60.0),lTarget,FALSE,OBJECT_TYPE_CREATURE);
	}
	
	while(GetIsObjectValid(oTarget))
	{	
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oTarget,fDur);
		
		oTarget = GetNextObjectInShape(SHAPE_SPHERE,FeetToMeters(60.0),lTarget,FALSE,OBJECT_TYPE_CREATURE);
	
		if(iShieldSuccess != 0 && oTarget == oCaster)
		{
			oTarget = GetNextObjectInShape(SHAPE_SPHERE,FeetToMeters(60.0),lTarget,FALSE,OBJECT_TYPE_CREATURE);
		}
	}

}