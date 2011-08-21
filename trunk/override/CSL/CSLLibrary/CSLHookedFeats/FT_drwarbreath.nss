//::///////////////////////////////////////////////
//:: Dragon Warrior, Dragon Breath
//:: cmi_s2_dragbrth
//:: Purpose:
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 3, 2009
//:://////////////////////////////////////////////
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook"
//#include "cmi_ginc_chars"


#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{	
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = 1;
	int iAttributes = 0 ;
	
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	int nDragonDis = GetLocalInt(OBJECT_SELF, "DragonDisciple");
	if (nDragonDis == 0)
	{
		SetupDragonDis();
		nDragonDis = GetLocalInt(OBJECT_SELF, "DragonDisciple");
	}

	int nResistType = SAVING_THROW_TYPE_FIRE;
	int nDamageType = DAMAGE_TYPE_FIRE;
	int nHitEffect = VFX_HIT_SPELL_FIRE;
	int nConeEffect = VFX_DUR_CONE_FIRE;

	if (nDragonDis == 2)
	{
		nDamageType = DAMAGE_TYPE_ACID;
		nResistType = SAVING_THROW_TYPE_ACID;
		nHitEffect = VFX_HIT_SPELL_ACID;
		nConeEffect = VFX_DUR_CONE_ACID;
	}
	else
	if (nDragonDis == 3)
	{
		nDamageType = DAMAGE_TYPE_ELECTRICAL;
		nResistType = SAVING_THROW_TYPE_ELECTRICITY;
		nHitEffect = VFX_HIT_SPELL_LIGHTNING;
		nConeEffect = VFX_DUR_CONE_LIGHTNING;
	}
	else
	if (nDragonDis == 4)
	{
		nDamageType = DAMAGE_TYPE_COLD;
		nResistType = SAVING_THROW_TYPE_COLD;
		nHitEffect = VFX_HIT_SPELL_ICE;
		nConeEffect = VFX_DUR_CONE_ICE;
	}

	object oTarget;

	// Determine breath damage
	int nLevel = GetLevelByClass( CLASS_DRAGON_WARRIOR, OBJECT_SELF);

	// Determine Save DC
	int nSaveDC = 10 + nLevel + GetAbilityModifier( ABILITY_CONSTITUTION, OBJECT_SELF);
		
	int nPersonalDamage;		// Damage actually applied (after reflex saves)
	float fDelay;
	float fMaxDelay = 0.0f;		// Used to determine the duration of the flame cone
	effect eDmg;
	effect eVis = EffectVisualEffect( nHitEffect );		// Visual effect from taking damage from spell
	effect eBreath = EffectVisualEffect( nConeEffect );	// Visual effect of caster breathing <- PLACEHOLDER EFFECT!
	int nDamage;
	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_COLOSSAL, HkGetSpellTargetLocation(), TRUE,
									OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	while(GetIsObjectValid(oTarget))
	{
		nDamage = d8(nLevel);	// Possible max damage (before reflex saves)

		nPersonalDamage = nDamage;
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));

			//Determine effect delay
			fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
			fDelay += 2.0f;
			if( fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}

			// Make SR check, and adjust damage based on Reflex save.
			//if((!HkResistSpell(OBJECT_SELF, oTarget, fDelay)) && (oTarget != OBJECT_SELF))
			if (oTarget != OBJECT_SELF)
			{

				nPersonalDamage = GetReflexAdjustedDamage( nPersonalDamage, oTarget, nSaveDC, nResistType );
				eDmg = EffectDamage(nPersonalDamage, nDamageType);
				if (nPersonalDamage > 0)
				{
					//Apply the VFX impact and effects
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				}
			}
		}
		//Get next target in spell area
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, RADIUS_SIZE_COLOSSAL, HkGetSpellTargetLocation(), TRUE,
										OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
		// Show that cone of fire!
		fMaxDelay += 0.5f;
		HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBreath, OBJECT_SELF, fMaxDelay);
}