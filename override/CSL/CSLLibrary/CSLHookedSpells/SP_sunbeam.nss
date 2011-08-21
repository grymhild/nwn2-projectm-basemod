//::///////////////////////////////////////////////
//:: Sunbeam
//:: s_Sunbeam.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures in the beam are struck blind and suffer 4d6 points of damage. (A successful
//:: Reflex save negates the blindness and reduces the damage by half.) Creatures to whom sunlight
//:: is harmful or unnatural suffer double damage.
//::
//:: Undead creatures caught within the ray are dealt 1d6 points of damage per caster level
//:: (maximum 20d6), or half damage if a Reflex save is successful. In addition, the ray results in
//:: the total destruction of undead creatures specifically affected by sunlight if they fail their saves.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_sunbeam();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SUNBEAM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DIVINE|SCMETA_DESCRIPTOR_LIGHT, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lTarget = HkGetSpellTargetLocation();
	int iSpellPower = HkGetSpellPower( oCaster, 20 ); // OldGetCasterLevel(oCaster);

	

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iImpactEffect = HkGetShapeEffect( VFX_FNF_SUNBEAM, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_HOLY );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NONE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget );
	
	//Declare major variables
	effect eVis = EffectVisualEffect( iHitEffect );
	
	
	effect eBlind = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	eBlind = EffectLinkEffects(eBlind, EffectBlindness());

	//Get the first target in the spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			float fDelay = CSLRandomBetweenFloat(1.0, 2.0);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
			if (!HkResistSpell(oCaster, oTarget, 1.0))
			{
				int iDice = 4;
				if ( CSLGetIsUndead( oTarget )  )
				{
					iDice = iSpellPower;
				}
				else if ( CSLGetIsLightSensitiveCreature(oTarget) )
				{
					iDice = 8;
				}
				int nOrgDam = HkApplyMetamagicVariableMods(d6(iDice), 6 * iDice);
				int iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nOrgDam, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DIVINE);
				if (iDamage)
				{
					if (iDamage==nOrgDam || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
					{
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, 18.0));
						if ( CSLGetIsSunDamagedCreature( oTarget ) )
						{
							iDamage = GetCurrentHitPoints(oTarget);
						}
					}
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_DIVINE), oTarget));
				}
			}
		}
		//Get the next target in the spell area
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	}
	HkPostCast(oCaster);
}