//::///////////////////////////////////////////////
//:: Shadow Conjuration
//:: NW_S0_ShadConj.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If the opponent is clicked on Shadow Bolt is cast.
	If the caster clicks on himself he will cast
	Mage Armor and Mirror Image.  If they click on
	the ground they will summon a Shadow.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 25, 2001
//:: AFW-OEI 06/02/2006:
//:: Update creature blueprint
//:: Changed summon duration from hours to 3 + CL rounds

// JLR - OEI 08/24/05 -- Metamagic changes
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


void ShadowBolt (object oTarget, int iMetaMagic);

void main()
{
	//scSpellMetaData = SCMeta_SP_shadjuration();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SHADOW_CONJURATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_EVIL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NEGATIVE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_SHADOW, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iMetaMagic = HkGetMetaMagicFeat();
	object oTarget = HkGetSpellTarget();
	int nCast;
	int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration( OBJECT_SELF );
	float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS);
	float fSummonDuration = RoundsToSeconds(iSpellPower + 3);
	effect eVis;

	fDuration = HkApplyMetamagicDurationMods(fDuration);
	fSummonDuration = HkApplyMetamagicDurationMods(fSummonDuration);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_NEGATIVE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_NECROMANCY );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NEGATIVE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	if (GetIsObjectValid(oTarget))
	{
			if (oTarget == OBJECT_SELF)
			{
				nCast = 1;
			}
			else
			{
				nCast = 2;
			}
	}
	else
	{
			nCast = 3;
	}

	switch (nCast)
	{
			case 1:
			{
					//eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
					effect eAC = EffectACIncrease(4, AC_ARMOUR_ENCHANTMENT_BONUS);
					effect eMirror = EffectVisualEffect(VFX_DUR_SPELL_MAGE_ARMOR);
					effect eLink = EffectLinkEffects(eAC, eMirror);
					//eLink = EffectLinkEffects(eLink, eVis);
					HkApplyEffectToObject(iDurType, eLink, OBJECT_SELF, fDuration);
			}
				break;
			case 2:
			{
					if (!HkResistSpell(OBJECT_SELF, oTarget))
					{
						ShadowBolt(oTarget, iMetaMagic);
				}
			}
				break;
			case 3:
			{
					//eVis = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE);
					//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
					effect eSummon = EffectSummonCreature("csl_sum_shadow_shadow7", VFX_HIT_SPELL_SUMMON_CREATURE);
					HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fSummonDuration);
					//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
					//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, HkGetSpellTargetLocation());
			}
				break;
	}
	
	HkPostCast(oCaster);
}

void ShadowBolt (object oTarget, int iMetaMagic)
{
	int iDamage;
	int nBolts = HkGetSpellPower(OBJECT_SELF)/5;
	int nCnt;
	int iDC = HkGetSpellSaveDC();
	effect eVis2 = EffectVisualEffect(VFX_HIT_SPELL_EVIL);
	effect eDam;
	effect eBeam = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
	for (nCnt = 0; nCnt < nBolts; nCnt++)
	{
			int nDam = d6(2);
			//Enter Metamagic conditions
			iDamage = HkApplyMetamagicVariableMods(iDamage, 12);
			//if (ReflexSave(oTarget, iDC))
			//{
			//	iDamage = iDamage/2;
			//}
			iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_REFLEX, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget ), SAVING_THROW_TYPE_ALL, OBJECT_SELF );
			eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE);
			DelayCommand(IntToFloat(nCnt), HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
			DelayCommand(IntToFloat(nCnt), HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	}
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 3.5);
}

