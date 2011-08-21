//:://///////////////////////////////////////////////
//:: Vitriolic Sphere
//:: nw_s0_vitsphere.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/10/05
//::////////////////////////////////////////////////
/*
		5.1.5.4.6 Vitriolic Sphere (B)
		E-mail from WotC, up-coming Complete Arcane
		School:        Conjuration (Creation) [Acid]
		Components:  Verbal, Somatic
		Range:      Long
		Target:        10 ft. radius burst
		Duration:   Instantaneous
		Saving Throw:   Reflex half
		Spell Resist:   Yes

		You conjure a sphere of sizzling emerald acid that streams towards the
		target and explodes. Everything within the area of affect is drenched
		with a potent acid that deals 1d4 points of acid damage per caster level
		(maximum 15d4). Any creature who fails their Reflex save is subject to
		continuing acid damage in subsequent rounds. On the second round, the
		acid deals 6d4 damage (Reflex half); on the third round, it deals 3d4
		damage (Reflex half); and on the fourth round it deals no more damage.
		Once an affected creature succeeds on a Reflex save, it suffers no more
		continuing damage.

		[Art] An emerald acid ball needs to fly to the target and explode. If
		it could sizzle and sound like Alien type of acid burning in the area
		that would be great.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void DamageVictim(int iDice, int iDamageType, object oVictim, object oCaster, int nSpellSaveDC, int iMetaMagic = -1, int iRound = 0)
{
	iRound++;
	if ( iRound == 2 )
	{
		iDice = 6;
	}
	else if ( iRound > 2 )
	{
		iDice = 3;
	}
	
	if ( iMetaMagic == -1 ) iMetaMagic = GetMetaMagicFeat();
	
	if ( CSLGetDelayedSpellEffectsExpired(SPELL_VITRIOLIC_SPHERE, oVictim, oCaster) ) return; // IF SPELL EFFECT IS GONE, DON'T CONTINUE DOING DAMAGE
	SignalEvent(oVictim, EventSpellCastAt(oCaster, SPELL_VITRIOLIC_SPHERE));
	int iDamage = HkApplyMetamagicVariableMods(d4(iDice), iDice * 4, iMetaMagic );
	
	int iSaveType = CSLGetSaveTypeByDamageType(iDamageType);
	// A successful saving throw results in half damage
	//int iSave = SAVING_THROW_CHECK_FAILED;
	//if (bFirstPass)  // ONLY GET TO EVADE ON FIRST HIT, AFTER THAT THEY SOAKING IN IT
	//{
	
	
	int iSave = ReflexSave( oVictim, nSpellSaveDC, iSaveType, oCaster );
	
	if ( iSave==SAVING_THROW_CHECK_IMMUNE )
	{
		return;
	}

	iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_REFLEX, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oVictim, nSpellSaveDC, iSaveType, oCaster, iSave );
	
	if (iDamage)
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(CSLGetHitEffectByDamageType(iDamageType)), oVictim);
		DelayCommand(0.0f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, iDamageType), oVictim));
	}
	if (iSave==SAVING_THROW_CHECK_SUCCEEDED || iDice==3) return; // ANY CREATURE WHO FAILS THEIR REFLEX SAVE IS SUBJECT TO CONTINUING ACID DAMAGE IN SUBSEQUENT ROUNDS
	// after first pass drops to 3 dice per
	
	DelayCommand(6.0, DamageVictim(iDice, iDamageType, oVictim, oCaster, nSpellSaveDC, iMetaMagic, iRound ));
}

void main()
{
	//scSpellMetaData = SCMeta_SP_vitriolicsph();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VITRIOLIC_SPHERE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION|SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lTarget = HkGetSpellTargetLocation();
	int nSpellSaveDC = HkGetSpellSaveDC();
	int iDice = HkGetSpellPower( oCaster, 15 ); // OldGetCasterLevel(oCaster);
	
		
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_ACID );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	int iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_MEDIUM_ACID, SC_SHAPE_AOEEXPLODE, oCaster, fRadius ); 
	int iContinuousDamageEffect = HkGetShapeEffect( VFX_DUR_SPELL_MELFS_ACID_ARROW, SC_SHAPE_CONTDAMAGE );
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_ACID );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ACID );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iShapeEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	effect eDur = ExtraordinaryEffect( EffectVisualEffect( iContinuousDamageEffect ) );
	
	object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
	while ( GetIsObjectValid( oVictim  ) )
	{
		if (CSLSpellsIsTarget( oVictim, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oVictim, 15.0f ); // 2.5 ROUNDS
			float fDelay = CSLGetMinf(1.0f, 0.15f * GetDistanceBetweenLocations(lTarget, GetLocation(oVictim)));
			DamageVictim(iDice, iDamageType, oVictim, oCaster, nSpellSaveDC); // -1 forces it to do the metamagic on the first go thru
		}
		oVictim = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE);
	}
	
	HkPostCast(oCaster);
}

