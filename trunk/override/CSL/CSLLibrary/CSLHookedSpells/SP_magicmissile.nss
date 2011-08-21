//::///////////////////////////////////////////////
//:: Magic Missile
//:: NW_S0_MagMiss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A missile of magical energy darts forth from your
// fingertip and unerringly strikes its target. The
// missile deals 1d4+1 points of damage.
//
// For every two extra levels of experience past 1st, you
// gain an additional missile.
*/
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_magicmissile();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MAGIC_MISSILE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool=SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool=SPELL_SUBSCHOOL_NONE;
	if ( GetSpellId() == SPELL_SHADOW_CONJURATION_MAGIC_MISSILE || GetSpellId() == SPELL_MSE_MAGMISSILE )
	{
		iSpellSchool=SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool=SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	object oTarget = HkGetSpellTarget();
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_MAGIC_MISSILE, TRUE ));
		int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
		int nMissiles = CSLGetMin(5, (iSpellPower + 1)/2);
		effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
		location lSourceLoc = GetLocation(oCaster);
		location lTarget = GetLocation(oTarget);
		int nCnt;
		float fTravelTime;
		float fDelay = 0.0;
		int bMantle = HkHasSpellAbsorption(oTarget);
		int bResist = HkResistSpell(oCaster, oTarget, fDelay); // DO THIS ONCE OUTSIDE LOOP TO REMOVE THE MANTLE LEVELS & CHECK SR
		for (nCnt = 1; nCnt <= nMissiles; nCnt++) {
			fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, PROJECTILE_PATH_TYPE_DEFAULT );
			fDelay = CSLRandomBetweenFloat(0.1f, 0.5f) + (0.5f * IntToFloat(nCnt));
			if (nCnt!=1 && !bMantle) bResist = HkResistSpell(oCaster, oTarget, fDelay); // DO THIS ON 2nd+ LOOP ONLY IF THEY HAVE NO MANTLE TO DO SR CHECK PER MISSLE
			if (!bResist && !bMantle) { // ONLY APPLY DAMAGE IF THEY HAVE NO MANTLE AND FAILED SR CHECK
				int nDam = HkApplyMetamagicVariableMods(d4(1) + 1, 5);
				DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL), oTarget));
				DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
			}
			DelayCommand(fDelay, SpawnSpellProjectile(oCaster, oTarget, lSourceLoc, lTarget, SPELL_MAGIC_MISSILE, PROJECTILE_PATH_TYPE_DEFAULT));
		}
	}
	
	HkPostCast(oCaster);
}

