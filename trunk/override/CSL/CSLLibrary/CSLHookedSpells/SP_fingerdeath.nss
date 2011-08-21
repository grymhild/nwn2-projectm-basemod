//::///////////////////////////////////////////////
//:: Finger of Death
//:: NW_S0_FingDeath
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You can slay any one living creature within range.
// The victim is entitled to a Fortitude saving throw to
// survive the attack. If he succeeds, he instead
// sustains 3d6 points of damage +1 point per caster
// level.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 17, 2000
//:://////////////////////////////////////////////
//:: Updated By: Georg Z, On: Aug 21, 2003 - no longer affects placeables
// BMA-OEI 11/9/06: Allow casting on neutral creatures
	
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_fingerdeath();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FINGER_OF_DEATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DEATH|SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	
	int iDamage;
	//NEGATIVE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_DEATH );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FINGER_OF_DEATH );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eDam;
	effect eVis = EffectVisualEffect( iHitEffect );

	// BMA-OEI 11/9/06: Allow casting on neutral creatures
	//if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE,OBJECT_SELF))
	if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF))
	{
		//GZ: I still signal this event for scripting purposes, even if a placeable
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FINGER_OF_DEATH));
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
		{

			//Make SR check
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				
				int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, HkGetSpellSaveDC(oCaster, oTarget), iSaveType, oCaster );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
				}
				else if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE ) // partial damage is full hit point damage
				{
					//Roll damage
					iDamage = HkApplyMetamagicVariableMods(d6(3), 6 * 3)+ iSpellPower;
					//Set damage effect
					eDam = HkEffectDamage(iDamage, iDamageType);
					//Apply damage effect and VFX impact
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);	
				}
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget); // play the impact effect regardless of save
			}
		}
	}
	
	HkPostCast(oCaster);
}

