//::///////////////////////////////////////////////
//:: Delayed Blast Fireball: On Enter
//:: NW_S0_DelFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The caster creates a trapped area which detects
	the entrance of enemy creatures into 3 m area
	around the spell location.  When tripped it
	causes a fiery explosion that does 1d6 per
	caster level up to a max of 20d6 damage.
*/
//:://////////////////////////////////////////////
//:: Georg: Removed Spellhook, fixed damage cap
//:: Created By: Preston Watamaniuk
//:: Created On: July 27, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	// 10% chance of premature detonation on each creatures entry into the AOE
	if ( d10() != 10)
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_DELAYED_BLAST_FIREBALL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_EVOCATION;
	int iSpellSubSchool = SPELL_SUBSCHOOL_ELEMENTAL;
	if ( GetSpellId() == SPELL_SHADES_TARGET_CREATURE )
	{
		iSpellSchool = SPELL_SCHOOL_ILLUSION;
		iSpellSubSchool = SPELL_SUBSCHOOL_SHADOW;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, iSpellSchool, iSpellSubSchool );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Declare major variables
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	location lTarget = GetLocation(OBJECT_SELF);
	int iDamage;
	int iSpellPower = HkGetSpellPower( oCaster, 20 );
	int nFire = GetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL"); // make sure it only fires once
	float fRadius = HkApplySizeMods(RADIUS_SIZE_HUGE);
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iDescriptor = HkGetDescriptor(); // This is stored in the AOE tag of the AOE, and after that it's stored in a var on the AOE
	int iSaveType = SAVING_THROW_TYPE_FIRE;
	int iHitEffect = VFX_HIT_SPELL_FIRE;
	int iShapeEffect = VFX_FNF_FIREBALL;
	int iDamageType = CSLGetDamageTypeModifiedByDescriptor( DAMAGE_TYPE_FIRE, iDescriptor );
	if ( iDamageType != DAMAGE_TYPE_FIRE )
	{
		iHitEffect = CSLGetHitEffectByDamageType( iDamageType );
		iSaveType = CSLGetSaveTypeByDamageType( iDamageType );
		iShapeEffect = CSLGetAOEExplodeByDamageType( iDamageType, fRadius );
	}
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eDam;
	effect eExplode = EffectVisualEffect(iShapeEffect);
	effect eVis = EffectVisualEffect(iHitEffect);
	
	
	//Check the faction of the entering object to make sure the entering object is not in the casters faction
	if(nFire == 0)
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) )
		{
			SetLocalInt(OBJECT_SELF, "NW_SPELL_DELAY_BLAST_FIREBALL",TRUE);
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
			//Cycle through the targets in the explosion area
			oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
			while(GetIsObjectValid(oTarget))
			{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, oCaster))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DELAYED_BLAST_FIREBALL, TRUE));
					//Make SR check
					if (!HkResistSpell(oCaster, oTarget))
					{
						// get the damage
						iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
						//Change damage according to Reflex, Evasion and Improved Evasion
						iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), iSaveType, GetAreaOfEffectCreator());
						//Set up the damage effect
						eDam = EffectDamage(iDamage, iDamageType);
						if(iDamage > 0)
						{
							//Apply VFX impact and damage effect
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
							DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
						}
					}
				}
				//Get next target in the sequence
				oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
			}
			DestroyObject(OBJECT_SELF, 1.0);
		}
	}
}