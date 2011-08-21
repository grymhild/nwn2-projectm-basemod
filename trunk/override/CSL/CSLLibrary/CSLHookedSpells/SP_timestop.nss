//::///////////////////////////////////////////////
//:: Time Stop
//:: SOZ UPDATE BTM
//:: NW_S0_TimeStop.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All persons in the Area are frozen in time
    except the caster.
	
    Reeron modified on 12-23-07
    Now lasts for correct 1d4 +1 rounds instead of 9 seconds fixed duration.
    
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
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
	int iSpellId = SPELL_TIME_STOP;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
   	location lTarget = HkGetSpellTargetLocation();
	//effect eVis = EffectVisualEffect(VFX_FNF_TIME_STOP);
    effect eCut = EffectCutsceneParalyze();
    //effect eVis2 = EffectVisualEffect( VFX_DUR_SPELL_RAY_ENFEEBLE );
    effect eSanc = EffectSanctuary(99);
    effect eSanc2 = EffectSanctuary(98);
    object oTarget;
    effect eTime = EffectTimeStop();
    int iRoll = 1 + d4();

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, iSpellId, FALSE));

    //Apply the VFX impact and effects
    DelayCommand(0.75, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTime, OBJECT_SELF, RoundsToSeconds(iRoll)));
    //ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lTarget, RoundsToSeconds(iRoll));
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 36.576, lTarget, TRUE, OBJECT_TYPE_CREATURE);	
    while (GetIsObjectValid(oTarget))
        {
        if (oTarget != OBJECT_SELF)
            {
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCut, oTarget, 1.0f);
            //HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanc, oTarget, 1.0f);
            HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSanc2, oTarget, 1.0f);
            }
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 36.576, lTarget, TRUE, OBJECT_TYPE_CREATURE);
         }
    SendMessageToPC(OBJECT_SELF, "Time stopped for " + IntToString(iRoll) + " rounds");

	//ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
	
	HkPostCast(oCaster);
}

