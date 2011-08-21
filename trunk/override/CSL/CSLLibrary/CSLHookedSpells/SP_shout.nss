//::///////////////////////////////////////////////
//:: Shout
//:: NX_s0_shout.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Components: V
	SoE: 30ft. cone-shaped burst
	Saving Throw: Fortitude for 1/2 damage and no deafness
	
	Causes 5d6 sonic damage and Deaf status effect for 2d6 rounds.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void ShoutDamage( object oTarget, object oCaster, int iDamageType )
{
	int nDam = HkApplyMetamagicVariableMods( d6(5), 30);
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(d6(2)));
	
	if (GetHasSpellEffect(FEAT_LYRIC_THAUM_SONIC_MIGHT,oCaster))
	{
		nDam += d6(4);			
	}
				
	if ( HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_SONIC, oCaster))
	{
		nDam = nDam/2;
	}
	else
	{
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oTarget, fDuration);
	}
	effect eLink = EffectLinkEffects( EffectVisualEffect(VFX_HIT_SPELL_SHOUT), HkEffectDamage(nDam, iDamageType));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

}

void main()
{
	//scSpellMetaData = SCMeta_SP_shout();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHOUT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nDam;
	float fDuration;
	//effect eDeaf = EffectDeaf();
	//effect eDam;
	//effect eImpact;
	//effect eLink;
	
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
	location lTarget = HkGetSpellTargetLocation();
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
			if (oTarget!=oCaster)
			{
				AssignCommand(oTarget, ShoutDamage( oTarget, oCaster, iDamageType ) );
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CONE_SONIC), oCaster, 2.0);
	
	HkPostCast(oCaster);
}

