//::///////////////////////////////////////////////
//:: Stormsingers Greater Thunderstrike
//:: cmi_s2_gthndstrk
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 16, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


//Based on Lightning Bolt by OEI

#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
//#include "ginc_debug"
#include "_SCInclude_Class"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = STORMSINGER_GTR_THUNDERSTRIKE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	

	int nBaseDamage = GetSkillRank(SKILL_PERFORM);
	

	if (nBaseDamage < 17) //Short circuit
	{
		SendMessageToPC(OBJECT_SELF, "Insufficient Perform skill, you need 17 or more to use this ability.");
		return;
	}
	if (!GetHasFeat(257))
	{
		SpeakString("No uses of the Bard Song ability are available");
		return;
	}
	else
	{
		DecrementRemainingFeatUses(OBJECT_SELF, 257);
		DecrementRemainingFeatUses(OBJECT_SELF, 257);		
	}
		
	nBaseDamage += 2; //Stormpower
	
	int iDC = 10 + GetLevelByClass(CLASS_STORMSINGER) + GetAbilityModifier(ABILITY_CHARISMA);
	iDC += CSLGetDCBonusByLevel(OBJECT_SELF);	
			
    int iDamage;
    //Set the lightning stream to start at the caster's hands
    object oTarget = HkGetSpellTarget();
    location lTarget = GetLocation(oTarget);
	location lTarget2 = HkGetSpellTargetLocation();
	
	//string sTarget2 = "wp_lbolttrgt2";
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ELECTRICITY );
	int iBeamEffect = HkGetShapeEffect( VFX_BEAM_LIGHTNING, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(iHitEffect); // used for both impact AND the hit effect
    effect eDamage;


	
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget2);

	
	// If you target a location, this will spawn in an invisible creature to act as the endpoint on the beam, then delete itself
	object oPoint = CreateObject(OBJECT_TYPE_CREATURE, "c_attachspellnode" , lTarget2);
	SetScriptHidden(oPoint, TRUE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPoint);
	DestroyObject(oPoint, 2.0);
	
	//CreateObject(OBJECT_TYPE_WAYPOINT, sTarget2, lTarget2);
	//object oPoint = GetObjectByTag(sTarget2);
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oPoint, 1.0);
	//PrettyDebug("Lightning bolt!  Woo Hoo!");
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
		//PrettyDebug("investigating target " + GetName(oTarget));
         while (GetIsObjectValid(oTarget))
        {
           //Exclude the caster from the damage effects
           if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
           {
                if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            	{
                   //Fire cast spell at event for the specified target
					//PrettyDebug("Signaling Lightning Bolt on " + GetName(oTarget));
                   SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, STORMSINGER_GTR_THUNDERSTRIKE));
                   //Make an SR check
                   if (!HkResistSpell(OBJECT_SELF, oTarget))
        	       {
                        //Roll damage
                        iDamage =  d20();
						if (iDamage == 20)
						{
							iDamage = 40 + (nBaseDamage * 2);
						}
						else
						{
							iDamage = iDamage + nBaseDamage;
						}	
                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC,iSaveType);
						
						//Set damage effect
                        eDamage = EffectDamage(iDamage, iDamageType);
                        if(iDamage > 0)
                        {
                            fDelay = CSLGetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            //Apply VFX impcat, damage effect and lightning effect
                            DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                            DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
					  		if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC))
							{
								effect eDmg2 = EffectDamage(d6(2), iDamageType);
								DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg2,oTarget));
								if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEAFNESS))
									DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_PERMANENT,EffectDeaf(),oTarget));

							}					
                        }			
                    }
                    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLightning,oTarget,1.0);
                    //Set the currect target as the holder of the lightning effect
                    oNextTarget = oTarget;
                    eLightning = EffectBeam(iBeamEffect, oNextTarget, BODY_NODE_CHEST);
                }
           }
           //Get the next object in the lightning cylinder
           oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget2, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        }
        nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    }
    
    HkPostCast(oCaster);
}

