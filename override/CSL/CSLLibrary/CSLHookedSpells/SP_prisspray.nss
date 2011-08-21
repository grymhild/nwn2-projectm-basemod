//::///////////////////////////////////////////////
//:: Prismatic Spray
//:: [NW_S0_PrisSpray.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Sends out a prismatic cone that has a random
//:: effect for each target struck.
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Transmutation"


const int PS_EFFECT_FIRE        = 0;
const int PS_EFFECT_ACID        = 1;
const int PS_EFFECT_ELECTRICITY = 2;
const int PS_EFFECT_POISON      = 3;
const int PS_EFFECT_PARALYZE    = 4;
const int PS_EFFECT_CONFUSION   = 5;
const int PS_EFFECT_DEATH       = 6;
const int PS_EFFECT_STONE       = 7;
const int PS_EFFECT_COUNT       = 8;

//Set the delay to apply to effects based on the distance to the target
float GetDelayForTarget(object oTarget)
{
	return 1.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
}

void ApplyPrismaticEffect(int nEffect, object oTarget)
{
	effect  ePrism;
	effect  eVis;
	effect  eDur  = EffectVisualEffect( VFX_DUR_SPELL_PRISMATIC_SPRAY );
	effect  eLink;
	int iDamage = 0;
	int nVis = 0;
	int iSaveDC = HkGetSpellSaveDC();
	float fDelay = GetDelayForTarget(oTarget);

	switch(nEffect)
	{
		case PS_EFFECT_FIRE: //fire
		{
			iDamage = 20;
			nVis = VFX_HIT_SPELL_FIRE;
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iSaveDC, SAVING_THROW_TYPE_FIRE);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_FIRE), oTarget));
		}
		break;
		case PS_EFFECT_ACID: //Acid
		{
			iDamage = 40;
			nVis = VFX_HIT_SPELL_ACID;
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iSaveDC, SAVING_THROW_TYPE_ACID);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_ACID), oTarget));
		}
		break;
		case PS_EFFECT_ELECTRICITY: //Electricity
		{
			iDamage = 80;
			nVis = VFX_HIT_SPELL_LIGHTNING;
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iSaveDC, SAVING_THROW_TYPE_ELECTRICITY);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDamage, DAMAGE_TYPE_ELECTRICAL), oTarget));
		}
		break;
		case PS_EFFECT_POISON: //Poison
		{
			nVis = VFX_HIT_SPELL_POISON;
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectPoison(POISON_BEBILITH_VENOM), oTarget));
		}
		break;
		case PS_EFFECT_PARALYZE: //Paralyze
		{
			nVis = VFX_HIT_SPELL_ENCHANTMENT;
			if (HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC)==0)
			{
				eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_PARALYZED), EffectParalyze(iSaveDC, SAVING_THROW_FORT));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
			}
		}
		break;
		case PS_EFFECT_CONFUSION: //Confusion
		{
			nVis = VFX_HIT_SPELL_ENCHANTMENT;
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
			{
				eLink = EffectLinkEffects(EffectVisualEffect(VFX_DUR_SPELL_CONFUSION), EffectConfused());
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10)));
			}
		}
		break;
		case PS_EFFECT_DEATH: //Death
		{
			nVis = VFX_HIT_SPELL_NECROMANCY;
			if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
			{
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget));
			}
		}
		break;
		case PS_EFFECT_STONE: // Flesh to Stone
		{
			//nVis = VFX_HIT_SPELL_TRANSMUTATION; // DONE IN SCDoPetrification
			DelayCommand(fDelay, SCDoPetrification(HkGetSpellPower(OBJECT_SELF), OBJECT_SELF, oTarget, GetSpellId(), iSaveDC));
		}
		break;
	}
	if (nVis) DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVis), oTarget));
}

void main()
{
	//scSpellMetaData = SCMeta_SP_prisspray();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PRISMATIC_SPRAY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//if (SCStoneCasterInTown(oCaster)) return;

	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int nVisual, bTwoEffects;
	float fMaxDelay = 0.0f; // Used to determine length of Cone effect

	//Get first target in the spell area
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, HkGetSpellTargetLocation());
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			float fDelay = GetDelayForTarget( oTarget );
			fMaxDelay = CSLGetMaxf(fMaxDelay, fDelay);
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRISMATIC_SPRAY));
			if (oTarget!=OBJECT_SELF && !HkResistSpell(OBJECT_SELF, oTarget, fDelay))
			{
				if (GetHitDice(oTarget)<=8) //Blind the target if they are less than 9 HD
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(iSpellPower));
				}
				//Determine if 1 or 2 effects are going to be applied
				int nE1 = Random(PS_EFFECT_COUNT);
				ApplyPrismaticEffect(nE1, oTarget);
				if (d8()==1)  // 2 EFFECTS ARE APPLIED
				{
					int nE2 = nE1;
					while (nE2==nE1) nE2 = Random(PS_EFFECT_COUNT);
					ApplyPrismaticEffect(nE2, oTarget);
				}
			}
		}
		//Get next target in the spell area
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, HkGetSpellTargetLocation());
	}
	// Apply Cone visual fx
	fMaxDelay += 0.5f;
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CONE_COLORSPRAY), OBJECT_SELF, fMaxDelay);
	
	HkPostCast(oCaster);
}