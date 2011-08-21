//::///////////////////////////////////////////////
//:: Invocation: Devil's Sight
//:: NW_S0_IDvlSight.nss
//:://////////////////////////////////////////////
/*
	Caster gains Darkvision/Ultravision for 24 hours.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"





void main()
{
	//scSpellMetaData = SCMeta_IN_devilsight();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK );

	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(iSpellPower));
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_TRUE_SEEING);
	int nBoost = CSLGetMin(30, 15 + iSpellPower / 4);
	eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SPOT, nBoost));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_SEARCH, nBoost));
	//eLink = EffectLinkEffects(eLink, EffectUltravision());
	//eLink = EffectLinkEffects(eLink, EffectSeeInvisible());
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	CSLUnstackSpellEffects(oCaster, SPELL_TRUE_SEEING);
	
	// ?? this is nonsense
	// CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_DARKNESS);
	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_TREMENDOUS);
	
	location lTarget = GetLocation(oCaster);
	int nNumTargets = iSpellPower/5;
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget) && (nNumTargets > 0))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALL, oCaster))
		{
			if ( CSLGetIsInvisible( oTarget ) )
			{
				DelayCommand( CSLRandomBetweenFloat(1.0f,6.0f), ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_SMALL_MAGIC), GetLocation(oTarget) ) );
			}
			nNumTargets--;
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		
	}
	//return;

	/*

	object oCaster = OBJECT_SELF;
	int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
	effect eVis = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
	effect eDark = EffectDarkVision();
	effect eUltra = EffectUltravision();   // In NWN2 Ultravision = Darkvision + ignore concealment due to darkness.
	effect eLink = EffectLinkEffects(eDark, eUltra);
	eLink = EffectLinkEffects(eLink, eVis);
	CSLUnstackSpellEffects(oCaster, GetSpellId());
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	*/
	
	HkPostCast(oCaster);
}

