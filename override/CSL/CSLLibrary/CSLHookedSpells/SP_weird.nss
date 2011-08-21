//::///////////////////////////////////////////////
//:: Weird
//:: NW_S0_Weird
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All enemies in LOS of the spell must make 2 saves or die.
	Even IF the fortitude save is succesful, they will still take
	3d6 damage.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_weird();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_WEIRD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_NECROMANCY;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FEAR|SCMETA_DESCRIPTOR_MIND|SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_PHANTASM, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDamage = HkGetSpellPower( oCaster ); // OldGetCasterLevel(OBJECT_SELF);
	float fDelay;
		
	
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eVis = EffectVisualEffect(iHitEffect);
	effect eDeath = EffectDeath(FALSE,TRUE,TRUE, TRUE);
	eDeath = EffectLinkEffects(eDeath, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY));


	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_WEIRD), HkGetSpellTargetLocation());
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation(), TRUE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
		{
			fDelay = CSLRandomBetweenFloat(3.0, 4.0);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_WEIRD, TRUE ));
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{
				if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR) && !GetHasFeat(FEAT_IMMUNITY_PHANTASMS, oTarget))
				{
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC()+3, SAVING_THROW_TYPE_MIND_SPELLS, oCaster))
					{
						int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster );
						
						if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
						{
							if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
							{
								HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
							}
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oTarget);
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, iDamageType), oTarget);
						}
					} // Will save
				}
			}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation(), TRUE);
	}
	HkPostCast(oCaster);
}

