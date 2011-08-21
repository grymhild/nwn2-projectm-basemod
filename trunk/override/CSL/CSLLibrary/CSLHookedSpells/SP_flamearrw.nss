//::///////////////////////////////////////////////
//:: Flame Arrow
//:: NW_S0_FlmArrow
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Fires a stream of fiery arrows at the selected
	target that do 4d6 damage per arrow.  1 Arrow
	per 4 levels is created.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_flamearrw();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FLAME_ARROW;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	location lSourceLoc = GetLocation(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nMissiles = CSLGetMax(1, iSpellPower/4); // MIN OF 1 MISSLE

	object oTarget = HkGetSpellTarget();
	location lTargetLoc = GetLocation(oTarget);

	int iDamage = 0;
	int nCnt;
	float fTime;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	// int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDam;
	effect eHit = EffectVisualEffect( iHitEffect );

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		float fDelay = GetProjectileTravelTime(lSourceLoc, lTargetLoc, PROJECTILE_PATH_TYPE_DEFAULT);
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_FLAME_ARROW));
		int bMantle = HkHasSpellAbsorption(oTarget);
		int bResist = HkResistSpell(oCaster, oTarget, fDelay); // DO THIS ONCE OUTSIDE LOOP TO REMOVE THE MANTLE LEVELS & CHECK SR
		for (nCnt = 1; nCnt <= nMissiles; ++nCnt)
		{
			if (nCnt!=1 && !bMantle) bResist = HkResistSpell(oCaster, oTarget, fDelay); // DO THIS ON 2nd+ LOOP ONLY IF THEY HAVE NO MANTLE TO DO SR CHECK PER MISSLE
			fTime = (nCnt - 1) * 0.25;
			DelayCommand(fTime, SpawnSpellProjectile(oCaster, oTarget, lSourceLoc, lTargetLoc, SPELL_FLAME_ARROW, PROJECTILE_PATH_TYPE_DEFAULT));
			if (!bResist && !bMantle)
			{ // ONLY APPLY DAMAGE IF THEY HAVE NO MANTLE AND FAILED SR CHECK
				iDamage = HkApplyMetamagicVariableMods(d6(4), 24);
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType);
				eDam = HkEffectDamage(iDamage, iDamageType );
				DelayCommand(fDelay + fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
				DelayCommand(fDelay + fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget));
			}
		}
	}
	
	HkPostCast(oCaster);
}