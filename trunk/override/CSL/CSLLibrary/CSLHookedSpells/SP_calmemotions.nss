//::///////////////////////////////////////////////
//:: Calm Emotions
//:: SOZ UPDATE BTM
//:: NW_S0_CalmEmot.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: [Description of File]
//:://////////////////////////////////////////////
//:: Created By: [Your Name]
//:: Created On: [date]
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_Generic();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CALM_EMOTIONS;
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
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);

		
	
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eImpact = EffectVisualEffect(192);//VFX_FNF_LOS_NORMAL_20
    location lLocal = HkGetSpellTargetLocation();

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLocal);
    while(GetIsObjectValid(oTarget))
    {
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds(2));
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLocal);
    }
    
    HkPostCast(oCaster);
}