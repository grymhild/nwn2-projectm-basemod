//::///////////////////////////////////////////////
//:: Elemental Storm
//:: cmi_s2_elemstorm
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: May 13, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"


// Needs Ranged Touch attack against targets

void main()
{	
	// testing things DISABLED
	//return;
	// end testing
	
	//scSpellMetaData = SCMeta_FT_elemarchstor();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = ELEM_ARCHER_ELEM_STORM;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
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
	int iDamageType = 0;	
	int iLevel = GetLevelByClass(CLASS_ELEM_ARCHER, oCaster);
	
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	if (CSLGetIsHoldingRangedWeapon(oCaster))
	{	
		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oCaster);

		int nTargets = 5;		
		if (GetHasFeat(FEAT_ELEM_ARCHER_IMP_ELEM_STORM))
		{
			nTargets = 10;
		}	
				
		int nElec=0;
		int nFire=0;
		int nCold=0;
		int nAcid=0;
		
		int nDamageBonus = iLevel+d6(2);
		if (GetHasFeat(FEAT_ELEM_ARCHER_IMP_ELEM_STORM))
		{
			nDamageBonus = iLevel+d6(4);
		}
		if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_AIR))
			nElec += nDamageBonus;
		else
		if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_EARTH))
			nAcid += nDamageBonus;
		else
		if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_FIRE))
			nFire += nDamageBonus;
		else
		if (GetHasFeat(FEAT_ELEM_ARCHER_PATH_WATER))
			nCold += nDamageBonus;				
		
		
		effect AttackEffect = TOBGenerateAttackEffect(oCaster, oWeapon, 0, 0, 0, nAcid,
		nCold, nElec, nFire, 0, 0, 0, 0, 0);
		//effect eDmg = EffectDamage(nDamageBonus, iDamageType); 
		//effect eLink = EffectLinkEffects(eDmg, AttackEffect);
		
		
		int nLauncherBaseItemType = GetBaseItemType( oWeapon );
		if ( nLauncherBaseItemType != BASE_ITEM_LONGBOW &&
			 nLauncherBaseItemType != BASE_ITEM_SHORTBOW )
		{
			nLauncherBaseItemType = BASE_ITEM_SHORTBOW;
		}		
		
    	//object oTarget;
		location lTarget;	    
		int i = 1;
	    float fDist = 0.0;
	    float fDelay = 0.0;
		float fTravelTime;
		location lCaster = GetLocation( oCaster );

		
		location spellTarget = HkGetSpellTargetLocation();
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, spellTarget, TRUE, OBJECT_TYPE_CREATURE);
		while (GetIsObjectValid(oTarget) && (i < nTargets))
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster) && oTarget != oCaster) //Additional target check to make sure that the caster cannot be harmed by this spell
			{
				lTarget = GetLocation( oTarget );
				if ( i == 1 )
				{
					fDelay = 0.0f;
				}
				else
				{
					fDelay += 0.1f;
				}
				
				fTravelTime = GetProjectileTravelTime( lCaster, lTarget, PROJECTILE_PATH_TYPE_HOMING );
				
				// Run Touch Attack routine
				
	            SignalEvent(oTarget, EventSpellCastAt(oCaster, ELEM_ARCHER_ELEM_STORM));
				DelayCommand( fDelay, SpawnItemProjectile(oCaster, oTarget, lCaster, lTarget, nLauncherBaseItemType, PROJECTILE_PATH_TYPE_HOMING, OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, DAMAGE_TYPE_SONIC) );
	            DelayCommand( fDelay + fTravelTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, AttackEffect, oTarget));
	
				i++;	
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, spellTarget, TRUE, OBJECT_TYPE_CREATURE);	
		}
	}
	
	HkPostCast(oCaster);
}