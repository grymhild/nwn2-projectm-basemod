//::///////////////////////////////////////////////
//:: Power Word, Thunder
//:: SG_S0_PWThunder.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Conjuration (Creation) [Sonic]
Level: Clr 6 (Talos), Drd 6, Sor/Wiz 6
Casting Time: 1 action
Close: 25 ft + 5 ft/2 levels
Area: See text
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

When uttered, the Power Word, Thunder quickly rises
to a tremendous pitch and washes outward as a tangible
boom of sound.  All creatures within 60 feet of the
caster with 30 or fewer hit points are immediately
deafened and dazed, with no saving throw.  Creatures
with between 30 and 60 hit points are deafened but
not dazed.  Creatures with more than 60 hit points
are unaffected.  Power Word, Thunder destroys all
magical silence in its area of effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: April 15, 2003
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Edited By: Karl Nickels (Syrus Greycloak)
//:: Edited On: August 24, 2004
//:://////////////////////////////////////////////
//:: NOTE:  Removed test for cleric if deity is Talos
//:://////////////////////////////////////////////
// 
//
//
// 
// void main()
// {
// 
//     object  oTarget;         //= HkGetSpellTarget();
//     location lTarget        = GetLocation(oCaster);
//     int     iDC;             //= HkGetSpellSaveDC(oCaster, oTarget);
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//
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
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration*10, SC_DURCATEGORY_MINUTES) );
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
    float   fDelay;
    float   fRadius         = FeetToMeters(60.0);
    int     iDurationType   = DURATION_TYPE_TEMPORARY;
    
    if( GetGameDifficulty() > GAME_DIFFICULTY_NORMAL )
    {
        iDurationType = DURATION_TYPE_PERMANENT;
    }
	
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eMind        = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDaze        = EffectDazed();
    effect eDur         = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDazeLink    = EffectLinkEffects(eMind, eDaze);
    eDazeLink           = EffectLinkEffects(eDazeLink, eDur);
    effect eVis         = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eDeaf        = EffectDeaf();
    effect eWord        = EffectVisualEffect(VFX_FNF_SOUND_BURST);
    effect eWord1       = EffectVisualEffect(VFX_FNF_PWSTUN);
    effect eWordLink    = EffectLinkEffects(eWord,eWord1);
    effect eSilence;

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);
	
   	AssignCommand(oCaster, PlaySound(CSLPickOne("as_wt_thunderds4","as_wt_thunderds3"),TRUE));
	
    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eWordLink, oCaster);
    object oTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);

    while(GetIsObjectValid(oTarget))
    {
        if(GetObjectType(oTarget)==OBJECT_TYPE_AREA_OF_EFFECT)
        {
            if( CSLGetAreaOfEffectSpellIdGroup(oTarget, SPELL_SILENCE, SPELL_SILENCE_AOE, SPELL_SILENCE_FRIEND, SPELL_SILENCE_HOSTILE ) )
            {
                DestroyObject(oTarget);
            }
        }
        else if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && GetCurrentHitPoints(oTarget)<=60)
        {

            SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_POWER_WORD_THUNDER));
            fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
            if(!HkResistSpell(oCaster, oTarget))
            {
                
                CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, EFFECT_TYPE_SILENCE );
                
                if(!CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ))
                {
                    if(GetCurrentHitPoints(oTarget)<30)
                    {
                        if(iDurationType==DURATION_TYPE_PERMANENT)
                        {
                            DelayCommand(fDelay,HkApplyEffectToObject(iDurationType, eDazeLink, oTarget));
                        }
                        else
                        {
                            DelayCommand(fDelay,HkApplyEffectToObject(iDurationType, eDazeLink, oTarget, fDuration));
                        }
                    }
                    DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));

                    if( iDurationType==DURATION_TYPE_PERMANENT )
                    {
                        DelayCommand(fDelay,HkApplyEffectToObject(iDurationType, eDeaf, oTarget));
                    }
                    else
                    {
                        DelayCommand(fDelay,HkApplyEffectToObject(iDurationType, eDeaf, oTarget, fDuration));
                    }
                }
            }
        }
        oTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT);
    }

    HkPostCast(oCaster);
}