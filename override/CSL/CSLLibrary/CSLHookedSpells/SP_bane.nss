//::///////////////////////////////////////////////
//:: Bane
//:: X0_S0_Bane.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All enemies within 30ft of the caster gain a
	-1 attack penalty and a -1 save penalty vs fear
	effects
	
	SRD:
		
	Bane fills your enemies with fear and doubt. Each affected creature takes a -1 penalty on attack rolls and a -1 penalty on saving throws against fear effects.

	Bane counters and dispels bless.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 24, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_bane();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BANE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iImpactSEF = VFXSC_HIT_BANE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND|SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration(oCaster) ));
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_BANE);
	eLink = EffectLinkEffects(eLink, EffectAttackDecrease(1));
	eLink = EffectLinkEffects(eLink, EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR));
	location lLoc = HkGetSpellTargetLocation();
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
	while(GetIsObjectValid(oTarget)) {
		if (CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster)) 
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
			if (!HkResistSpell(oCaster, oTarget))
			{
				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_BLESS);
				int nWillResult = WillSave(oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS);
				if (!nWillResult)
				{
					DelayCommand(CSLRandomBetweenFloat(0.4, 1.1), HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration));
				} else if (nWillResult==2) { // * target will immune
					SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
	}
	
	HkPostCast(oCaster);
}

