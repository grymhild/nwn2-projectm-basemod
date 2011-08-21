//::///////////////////////////////////////////////
//:: Chain Missle
//:: SP_Chainmissle
//:: Copyright (c) 2008 Btian Meyer
//:://////////////////////////////////////////////
/*
 Up to 10 missiles, each doing 1d6 damage to all
 targets in area.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Evocation"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_missstormles();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CHAIN_MISSLE;
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
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_VAST);
	
	object oTarget = HkGetSpellTarget();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MAGIC_MISSILE, TRUE ));
		int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
		int nMissiles = CSLGetMin(10, (iSpellPower)/2);
		effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
		location lSourceLoc = GetLocation(oCaster);
		location lTarget = GetLocation(oTarget);
		int nCnt;
		float fTravelTime;
		float fSecondaryTravelTime;
		float fDelay = 0.0;
		int bMantle = HkHasSpellAbsorption(oTarget);
		int bResist = HkResistSpell(oCaster, oTarget, fDelay); // DO THIS ONCE OUTSIDE LOOP TO REMOVE THE MANTLE LEVELS & CHECK SR
		int numSecondaryMissles = 0;
		
		
		
		//int bhit = false;
		for (nCnt = 1; nCnt <= nMissiles; nCnt++)
		{
			fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, PROJECTILE_PATH_TYPE_DEFAULT );
			fDelay = CSLRandomBetweenFloat(0.1f, 0.5f) + (0.5f * IntToFloat(nCnt));
			if (nCnt!=1 && !bMantle) bResist = HkResistSpell(oCaster, oTarget, fDelay); // DO THIS ON 2nd+ LOOP ONLY IF THEY HAVE NO MANTLE TO DO SR CHECK PER MISSLE
			if (!bResist && !bMantle) { // ONLY APPLY DAMAGE IF THEY HAVE NO MANTLE AND FAILED SR CHECK
				int nDam = HkApplyMetamagicVariableMods(d4(1) + 1, 5);
				DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget));
				DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
				numSecondaryMissles = numSecondaryMissles + 1;
			}
			DelayCommand(fDelay, SpawnSpellProjectile(oCaster, oTarget, lSourceLoc, lTarget, SPELL_MAGIC_MISSILE, PROJECTILE_PATH_TYPE_DEFAULT));
		}
		
		if (DEBUGGING >= 7) { CSLDebug( "Number of Missles is "+IntToString( numSecondaryMissles ), oCaster ); }
		
		
		lTarget = CSLGetOffsetLocation(lTarget, 0.0f, 0.0f, 0.75f);
		
		
		object oSecondaryTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE );
		while ( GetIsObjectValid(oSecondaryTarget) )
		{
			if ( numSecondaryMissles > 0 && oSecondaryTarget != oTarget && CSLSpellsIsTarget(oSecondaryTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				fSecondaryTravelTime = GetProjectileTravelTime( lTarget, GetLocation(oSecondaryTarget), PROJECTILE_PATH_TYPE_DEFAULT );
				fDelay = CSLRandomBetweenFloat(0.2f, 0.5f) + (0.5f * IntToFloat(numSecondaryMissles));
				if ( !HkResistSpell(oCaster, oSecondaryTarget, fDelay) )
				{
					int nDam = HkApplyMetamagicVariableMods(d4(1) + 1, 5);
					DelayCommand(fDelay + fSecondaryTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oSecondaryTarget));
					DelayCommand(fDelay + fSecondaryTravelTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oSecondaryTarget));
				}
				DelayCommand(fDelay + fTravelTime, SpawnSpellProjectile(oTarget, oSecondaryTarget, lTarget, GetLocation(oSecondaryTarget), SPELL_MAGIC_MISSILE, PROJECTILE_PATH_TYPE_DEFAULT));
				numSecondaryMissles = numSecondaryMissles - 1;
				if (DEBUGGING >= 7) { CSLDebug( "Number of Missles is "+IntToString( numSecondaryMissles ), oCaster ); }

	
			}
			oSecondaryTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE );
		}
		
		
	}
	
	HkPostCast(oCaster);
}
