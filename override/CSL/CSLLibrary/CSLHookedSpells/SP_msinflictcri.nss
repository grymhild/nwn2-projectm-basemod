//::///////////////////////////////////////////////
//:: Mass Inflict Light Wounds (WAS: [Circle of Doom])
//:: [NW_S0_MaInfMod.nss]
//:://////////////////////////////////////////////
//:: All enemies of the caster take 4d8 damage +1
//:: per caster level (max 40).  Undead are healed
//:: for the same amount
//:://////////////////////////////////////////////
//:: Created By: Jesse Reynolds (JLR - OEI)
//:: Created On: August 01, 2005
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 25, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_msinflictcri();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MASS_INFLICT_CRITICAL_WOUNDS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFXSC_HIT_AOE_INFLICT;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_RESTORATIVE | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget;
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_INFLICT_5);
	effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_X);
	effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);
	effect eHeal;
	int iSpellPower = HkGetSpellPower( OBJECT_SELF, 40 ); // OldGetCasterLevel(OBJECT_SELF);
	
	int iMetaMagic = GetMetaMagicFeat();
	int iDamage;
	int iDC = HkGetSpellSaveDC();
	float fDelay;
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, HkGetSpellTargetLocation());
	//Get first target in the specified area
	oTarget =GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
			fDelay = CSLRandomBetweenFloat();
			//Roll damage
			iDamage = d8(4) + iSpellPower;
			//Make metamagic checks
			iDamage = HkApplyMetamagicVariableMods(iDamage, 32 + iSpellPower);

			//If the target is an allied undead it is healed
			if( CSLGetIsUndead( oTarget, TRUE ) )
			{
				if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
					//Set the heal effect
					eHeal = EffectHeal(iDamage);
					//Apply the impact VFX and healing effect
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
				}
				else
				{
					FloatingTextStrRefOnCreature(184683, OBJECT_SELF, FALSE);
					return;
				}
			}
			else
			{
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
					//Make an SR Check
					if (!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
					{
							//if (HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, iSaveType, OBJECT_SELF, fDelay))
							//{
							//	iDamage = iDamage/2;
							//}
							iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, iSaveType, oCaster );
							//Set Damage
							eDam = HkEffectDamage(iDamage, iDamageType);
							//Apply impact VFX and damage
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				}
			}
			//Get next target in the specified area
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	}
	
	HkPostCast(oCaster);
}

