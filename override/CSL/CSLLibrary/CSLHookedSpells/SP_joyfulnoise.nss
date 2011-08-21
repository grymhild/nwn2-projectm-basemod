//::///////////////////////////////////////////////
//:: Joyful Noise
//:: NW_S0_JoyFlNois.nss
//:://////////////////////////////////////////////
/*
	Caster's Party (within range) gains Immunity to
	the Silence spell effect.
*/


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_joyfulnoise();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_JOYFUL_NOISE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ABJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	// start duration adjustemnet

	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	// lasting inspiration makes it last a really long time, not even enabled yet.
	if(GetHasFeat(FEAT_EPIC_LASTING_INSPIRATION)) iDuration *= 10;
	
	// Choose how generous here
	//float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES); // 1 minute per level
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);  // 6 seconds per level
	//Enter Metamagic conditions
	fDuration = HkApplyMetamagicDurationMods(fDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	// lingering song makes last 5 more rounds
	if(GetHasFeat(FEAT_LINGERING_SONG)) fDuration += RoundsToSeconds(5);
	// end duration adjustment
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);

	// original duration adjustment
	//Check to see if the caster has Lasting Impression or lingering song and increase duration.
	//int iDuration = 10;
	//if(GetHasFeat(FEAT_EPIC_LASTING_INSPIRATION)) iDuration *= 10;
	//if(GetHasFeat(FEAT_LINGERING_SONG)) iDuration += 5;
	

	effect eLink = EffectLinkEffects(EffectImmunity(IMMUNITY_TYPE_SILENCE), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
	effect eImpact = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
	eLink = ExtraordinaryEffect(eLink);
	
	
	
	
	// btm, making this work on just the caster
	object oTarget = HkGetSpellTarget();
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	int bSingle = GetIsObjectValid(oTarget);
	if (oTarget==OBJECT_SELF)
	{ // SINGLE TARGET
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	}
	else if (bSingle)
	{ // SINGLE TARGET not the caster
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	}
	else
	{
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
		while(GetIsObjectValid(oTarget))
		{
			if(!GetHasFeatEffect(GetSpellFeatId(), oTarget) )
			{
				if (!CSLGetHasEffectType( oTarget, EFFECT_TYPE_SILENCE ) && !CSLGetHasEffectType( oTarget, EFFECT_TYPE_DEAF ))
				{
					if(oTarget==OBJECT_SELF)
					{
						CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
					}
					else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
					{
						CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
					}
				}
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
		}
	}
	
	HkPostCast(oCaster);
}

