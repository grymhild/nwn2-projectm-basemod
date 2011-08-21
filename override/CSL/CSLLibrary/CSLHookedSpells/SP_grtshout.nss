//::///////////////////////////////////////////////
//:: Shout, Greater
//:: NX_s0_shout.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	
	Components: V
	SoE: 30ft. cone-shaped burst
	Saving Throw: Fortitude for 1/2 damage and
	1/2 duration of deafness and negate stunning.
	
	Causes 10d6 sonic damage and Stunned status
	effect for 1 round and Deaf status effect for 4d6 rounds
	

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_SHOUT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = CSLGetMin(15, HkGetSpellPower(oCaster));
	int nDam;
	float fDuration;
	float fStun = HkApplyMetamagicDurationMods(6.0);
	
	
	//SONIC
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	effect eDeaf = EffectDeaf();
	effect eStun = EffectStunned();
	effect eImpact =  EffectVisualEffect(VFX_HIT_SPELL_GREATER_SHOUT);
	effect eLink;
	location lTarget = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, 1038));
			if (oTarget != oCaster)
			{
				nDam = HkApplyMetamagicVariableMods(d6(10), 60);
				if (GetHasSpellEffect(FEAT_LYRIC_THAUM_SONIC_MIGHT,oCaster))
				{
					nDam += d6(8);		
				}
				fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(d6(4)));
				if (HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), iSaveType, oCaster)) {
					nDam /= 2;
					fDuration /= 2.0;
				} else {
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, fStun);
				}
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeaf, oTarget, fDuration);
				eLink =  EffectLinkEffects(eImpact, HkEffectDamage(nDam, iDamageType));
				DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CONE_SONIC), oCaster, 2.0);
	
	HkPostCast(oCaster);
}

