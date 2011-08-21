//::///////////////////////////////////////////////
//:: Bombardment
//:: X0_S0_Bombard
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Rocks fall from sky
// 1d8 damage/level to a max of 10d8
// Reflex save for half
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_bombardment();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BOMBARDMENT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	
	int iCasterLevel = CSLGetMin(20, HkGetSpellPower(oCaster));
	int iDamage;
	int nOrgDam;
	float fDelay;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_COLOSSAL);
	
	
	effect eVis = EffectVisualEffect(VFX_HIT_AOE_FIRE);
	effect eDam;
	effect eKnockdown =  EffectKnockdown();
	location lSourceLoc = GetLocation(oCaster);
	location lTarget = HkGetSpellTargetLocation();
	int nCounter = 0;
	int nPathType = PROJECTILE_PATH_TYPE_DEFAULT;

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
			//if (!HkResistSpell(oCaster, oTarget, fDelay))
			//{
				float fTravelTime = GetProjectileTravelTime( lSourceLoc, lTarget, nPathType );
				fDelay = CSLRandomBetweenFloat(0.1f, 0.5f) + (0.5f * IntToFloat(nCounter));
				nCounter++;
				nOrgDam = HkApplyMetamagicVariableMods(d8(iCasterLevel), (8 * iCasterLevel));
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,nOrgDam, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_ALL);
				DelayCommand(fDelay, SpawnSpellProjectile(oCaster, oTarget, lSourceLoc, lTarget, SPELL_BOMBARDMENT, nPathType));
				DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				if (iDamage > 0)
				{
					eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING);
					DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					if (iDamage==nOrgDam || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
					{
						DelayCommand(fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, 12.0f));
						if ( !GetIsImmune( oTarget, IMMUNITY_TYPE_KNOCKDOWN ) )
						{
							CSLIncrementLocalInt_Timed(oTarget, "CSL_KNOCKDOWN",  12.0f, 1); // so i can track the fact they are knocked down and for how long, no other way to determine
						}
					}
				}
			//}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	HkPostCast(oCaster);
}

