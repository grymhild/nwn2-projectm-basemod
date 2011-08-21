//::///////////////////////////////////////////////
//:: Hellball
//:: nx_s2_hellball
//:: Copyright (c) 2007 Obsidian Entertainment, Inc.
//:://////////////////////////////////////////////
/*
	Type of Feat: Epic
	Prerequisites: 21st level, Spellcraft 30, the ability to cast 9th level spells.
	Specifics: The character can cast the Epic Spell Hellball.
	
	Classes: Druid, Duskblade, Wizard, Sorcerer, Spirit Shaman, Warlock
	Spellcraft Required: 30
	Caster Level: Epic
	Innate Level: Epic
	School: Evocation
	Descriptor(s): Fire, Acid, Electrical, Sonic
	Components: Verbal, Somatic
	Range: Long
	Area of Effect / Target: Huge
	Duration: Instant
	Save: Reflex ½ (DC +5)
	Spell Resistance: Yes
	
	You unleash a massive blast of energy that detonates upon all in the area of effect,
	dealing 10d6 fire damage, 10d6 acid damage, 10d6 electrical damage, and 10d6 sonic damage.
	The Hellball ignores Evasion and Improved Evasion.


	Use: Selected.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Woo
//:: Created On: 04/10/2007
//:://////////////////////////////////////////////
//:: AFW-OEI 06/25/2007: Reduce DC from +15 to +5.
//:: RPGplayer1 03/25/2008: Uses epic spell save workaround


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



//#include "nx1_inc_epicsave"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_HELLBALL;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE|SCMETA_DESCRIPTOR_ELECTRICAL|SCMETA_DESCRIPTOR_SONIC|SCMETA_DESCRIPTOR_ACID, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	float fDelay;
	int nTotalDamage;
	int nSpellDC = HkGetSpellSaveDC() + 5; // Epic Spells are DC +5
	int iDC = HkGetSpellSaveDC()+5;
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NONE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	//effect eExplode = EffectVisualEffect(VFX_HIT_HELLBALL_AOE);
	effect eHitVFX = EffectVisualEffect(VFX_HIT_HELLBALL);
	//effect eVisAcid = EffectVisualEffect(VFX_HIT_SPELL_ACID);
	//effect eVisElectrical = EffectVisualEffect(VFX_HIT_SPELL_LIGHTNING);
	//effect eVisFire = EffectVisualEffect(VFX_HIT_SPELL_FIRE);
	//effect eVisSonic = EffectVisualEffect(VFX_HIT_SPELL_SONIC);

	int nDamageAcid, nDamageElectrical, nDamageFire, nDamageSonic;
	effect eDamAcid, eDamElectrical, eDamFire, eDamSonic;

	location lTarget = HkGetSpellTargetLocation();

	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	while (GetIsObjectValid(oTarget))
	{
		
		if ( GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT )
		{
			CSLEnviroIgniteAOE( 20, oTarget );
		}
		else if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId, TRUE ));
			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20 + 0.5f;
			
			//Roll damage for each target
			nDamageAcid = d6(10);
			nDamageElectrical = d6(10);
			nDamageFire = d6(10);
			nDamageSonic = d6(10);
			
			// No Evasion for Hellball
			if (HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellDC, SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay) > 0)
			{
				nDamageAcid /= 2;
				nDamageElectrical /= 2;
				nDamageFire /= 2;
				nDamageSonic /= 2;
			}
			
			nTotalDamage = nDamageAcid + nDamageElectrical +nDamageFire + nDamageSonic;
			
			//Set the damage effects
			eDamAcid = EffectDamage(nDamageAcid, DAMAGE_TYPE_ACID);
			eDamElectrical = EffectDamage(nDamageElectrical, DAMAGE_TYPE_ELECTRICAL);
			eDamFire = EffectDamage(nDamageFire, DAMAGE_TYPE_FIRE);
			eDamSonic = EffectDamage(nDamageSonic, DAMAGE_TYPE_SONIC);
			
			if(nTotalDamage > 0)
			{
				// Apply effects to the currently selected target.
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamAcid, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamElectrical, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamFire, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamSonic, oTarget));
			
				//These visual effects are applied to the target object, not the location as above.
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHitVFX, oTarget));
				//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisAcid, oTarget));
				//DelayCommand(fDelay + 0.2f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisElectrical, oTarget));
				//DelayCommand(fDelay + 0.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisFire, oTarget));
				//DelayCommand(fDelay + 0.7f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisSonic, oTarget));
			}
			CSLEnviroIgniteTarget( iDC, oTarget ); // tests for if the given target can be ignited
		}
		else if ( GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE )
		{
			CSLEnviroBurningStart( 20, oTarget );
		}
		
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_AREA_OF_EFFECT);
	}
	HkPostCast(oCaster);
}

