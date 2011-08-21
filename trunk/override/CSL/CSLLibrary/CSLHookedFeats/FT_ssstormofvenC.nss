//::///////////////////////////////////////////////
//:: Storm of Vengeance: Heartbeat
//:: NW_S0_StormVenC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates an AOE that decimates the enemies of
    the cleric over a 30ft radius around the caster
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 8, 2001
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/



#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_FT_ssstormofven(); //STORMSINGER_STORM_VENGEANCE;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
    //Declare major variables
    effect eAcid = EffectDamage(d6(3), DAMAGE_TYPE_ACID);
    effect eElec = EffectDamage(d6(6), DAMAGE_TYPE_ELECTRICAL);
    effect eStun = EffectStunned();
    effect eVisAcid = EffectVisualEffect(VFX_HIT_SPELL_ACID);
    effect eVisElec = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
	effect eDur = EffectVisualEffect( VFX_DUR_STUN );
	eStun = EffectLinkEffects( eStun, eDur );
	
	int iDC = 10 + GetLevelByClass(CLASS_STORMSINGER, oCaster) + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	iDC += CSLGetDCBonusByLevel( oCaster );	
	
    float fDelay;
    //Get first target in spell area
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt( oCaster, STORMSINGER_STORM_VENGEANCE));
            //Make an SR Check
            fDelay = CSLRandomBetweenFloat(0.5, 2.0);
            {
                //Make a saving throw check
                // * if the saving throw is made they still suffer acid damage.
                // * if they fail the saving throw, they suffer Electrical damage too
                if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, SAVING_THROW_TYPE_ELECTRICITY, GetAreaOfEffectCreator(), fDelay))
                {
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                    if (d2()==1)
                    {
                        DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                    }
                }
                else
                {
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eAcid, oTarget));
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElec, oTarget));
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eElec, oTarget));
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(2)));
                }
            }
         }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    }
}