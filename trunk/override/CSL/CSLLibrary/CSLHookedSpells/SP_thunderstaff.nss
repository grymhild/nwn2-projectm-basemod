//::///////////////////////////////////////////////
//:: Thunder Staff
//:: sg_s0_thndrstf.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Evocation [Force]
Level: Sor/Wiz4
Components: V, S
Casting Time: 1 action
Range: 40ft long cone (Short)
Area: Cone
Duration: Instantaneous
Saving Throw: Fortitude Partial (see text)
Spell Resistance: Yes

You rap your staff on the ground and produce a thundering
cone of force.  All creatures must roll a successful
Fortitude save or be stunned for 1d3 rounds, deafened for
1d3+1 rounds, and hurled 4d4+4 ft away from the caster,
sustaining 1 hp of damage for every two feet thrown. On
a successful save, creatures are not stunned and are only
thrown half the distance.
Creatures of size Large and Huge who make their saves
are deafened but not thrown, and sustain no damage.  If the
saving throw is failed, such creatures are hurled 2d4+2 ft,
suffer 1 hp per 2ft in damage, and are deafened and stunned.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: November 17, 2004
//:://////////////////////////////////////////////
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FORCE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    //int     iDieType        = 0;
    //int     iNumDice        = 0;
    //int     iBonus          = 0;
    int     iDamage         = 0;

    float   fDist           = FeetToMeters(40.0);
    float   fDelay;
    int     iSaveResult;
    float   fStunDuration;
    float   fDeafDuration;
    int     iFeetHurled;
    float   fDistHurled;
    float   fAngle;
    float   fFacing;
    location lHurledToLocation;
    int     iGiantSize;
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
  
    effect eDamage;
    effect eDamageLink;
    effect eLink;

	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fDist, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    while(GetIsObjectValid(oTarget))
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_THUNDER_STAFF));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
            if(!HkResistSpell(oCaster, oTarget, fDelay) && (oTarget != oCaster))
            {
                fStunDuration = HkApplyDurationCategory( HkApplyMetamagicVariableMods( d3(), 3 ), SC_DURCATEGORY_HOURS);
                
                fDeafDuration = HkApplyDurationCategory( HkApplyMetamagicVariableMods( d3(), 3 )+1, SC_DURCATEGORY_HOURS);
                

                iFeetHurled = HkApplyMetamagicVariableMods( d4(4), 4 * 4 )+4;
                fDistHurled = FeetToMeters(iFeetHurled*1.0);
                
                if(GetCreatureSize(oTarget)>CREATURE_SIZE_MEDIUM)
                {
                    iGiantSize=TRUE;
                }
                else
                {
                    iGiantSize=FALSE;
                }
                if(iGiantSize)
                {
                    iFeetHurled = HkApplyMetamagicVariableMods( d2(4), 2 * 4 )+2;
                }
                
                int iDC = HkGetSpellSaveDC(oCaster, oTarget);
                if(HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_NONE, oCaster, fDelay))
                {
                    if(iGiantSize)
                    {
                        iFeetHurled=0;
                    }
                    else
                    {
                        iFeetHurled/=2;
                    }
                }
                iDamage=iFeetHurled/2;
                eDamageLink = EffectLinkEffects( EffectVisualEffect(VFX_COM_HIT_SONIC), HkEffectDamage(iDamage) );
                eLink = EffectLinkEffects(eDamageLink, EffectVisualEffect(VFX_IMP_STUN) );

                if(iFeetHurled>0)
                {
                    fDistHurled = FeetToMeters(iFeetHurled*1.0);
                    fAngle = CSLGetAngleBetweenLocations(GetLocation(oCaster), GetLocation(oTarget));
                    fFacing = GetFacing(oTarget);
                    lHurledToLocation = CSLGenerateNewLocation(oTarget, fDistHurled, fAngle, fFacing);
                }
                
                if(!iSaveResult)
                {
                    DelayCommand(fDelay, AssignCommand(oTarget, ClearAllActions()));
                    DelayCommand(fDelay+0.1, AssignCommand(oTarget, ActionJumpToLocation(lHurledToLocation)));
                    DelayCommand(fDelay+0.2, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectStunned(), oTarget, fStunDuration));
                    DelayCommand(fDelay+0.3, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, fDeafDuration));
                    if(!iGiantSize)
                    {
						if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
						{
							DelayCommand(fDelay+0.4, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 3.0f ));
							CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN", fDelay+3.4f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
						}
                    }
                    DelayCommand(fDelay+0.4, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                }
                else
                {
                    if(!iGiantSize)
                    {
                        eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M));
                        DelayCommand(fDelay, AssignCommand(oTarget, ClearAllActions()));
                        DelayCommand(fDelay+0.1, AssignCommand(oTarget, ActionJumpToLocation(lHurledToLocation)));
                        DelayCommand(fDelay+0.2, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, fDeafDuration));
                        DelayCommand(fDelay+0.3, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
                        if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
						{
							DelayCommand(fDelay+0.3, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 3.0f ));
							CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN", fDelay+3.3f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
                        }
                    }
                    else
                    {
                        DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oTarget));
                        DelayCommand(fDelay+0.1, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, fDeafDuration));
                    }
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fDist, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    HkPostCast(oCaster);
}


