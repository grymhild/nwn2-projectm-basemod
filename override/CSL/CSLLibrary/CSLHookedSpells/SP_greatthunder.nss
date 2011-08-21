//::///////////////////////////////////////////////
//:: Great Thunderclap
//:: SOZ UPDATE BTM
//:: X2_S0_GrtThdclp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a loud noise equivalent to a peal of
// thunder and its acommpanying shock wave. The
// spell has three effects. First, all creatures
// in the area must make Will saves to avoid being
// stunned for 1 round. Second, the creatures must
// make Fortitude saves or be deafened for 1 minute.
// Third, they must make Reflex saves or fall prone.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 20, 2002
//:: Updated On: Oct 20, 2003 - some nice Vfx:)
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLR_GREAT_THUNDERCLAP;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = -1;
	
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
	
	
    int iDamage = 0;
    int iDC = HkGetSpellSaveDC();
    float fDelay;
    float fRadius = HkApplySizeMods(RADIUS_SIZE_GARGANTUAN);
    
    effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
    effect eVis  = EffectVisualEffect(VFX_IMP_SONIC);
    effect eVis2 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eVis3 = EffectVisualEffect(VFX_IMP_STUN);
    effect eDeaf = EffectDeaf();
    effect eKnock = EffectKnockdown();
    effect eStun = EffectStunned();
    effect eShake = EffectVisualEffect(356);

    location lTarget = HkGetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, 2.0f);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));

            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, RoundsToSeconds(10)));
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            }
            if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1)));
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            if(!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, SAVING_THROW_TYPE_SONIC))
            {
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 6.0f));
                if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
				{
					CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  fDelay+6.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
				}
                DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis3, oTarget,4.0f));
            }
        }

       oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    
    HkPostCast(oCaster);
}