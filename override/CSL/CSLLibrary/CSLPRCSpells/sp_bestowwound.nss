//::///////////////////////////////////////////////
//:: Name 	Bestow Wound
//:: FileName sp_bestow_wnd.nss
//:://////////////////////////////////////////////
/**@file Bestow Wound
Transmutation
Level: Sor/Wiz 1
Components: V, S, M
Casting Time: 1 action
Range: Touch
Target: Living creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

If the caster is wounded, she can cast this spell and
touch a living creature. The creature takes the caster's
wounds as damage, either 1 point of damage per caster
level or the amount needed to bring the caster up to her
maximum hit points, whichever is less. The caster heals
that much damage, as if a cure spell had been cast on her.

Material Component: A small eye agate worth at least 10 gp.

Author: 	Tenjac
Created: 	02/05/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"



#include "_HkSpell"

void main()
{	
	

	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BESTOW_WOUND; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//define vars
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nCasterMaxHP = GetMaxHitPoints(oCaster);
	int nCasterCurrentHP = GetCurrentHitPoints(oCaster);
	int nDam = CSLGetMin((nCasterMaxHP - nCasterCurrentHP), nCasterLvl);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_BESTOW_WOUND, oCaster);

	//Check Spell Resistance
	if (HkResistSpell(oCaster, oTarget ))
	{
		return;
	}

	//Resolve Spell if failed save
	if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
	{
		//Target effects
		effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
		effect eVisDam = EffectVisualEffect(VFX_IMP_HARM);
		effect eLink = EffectLinkEffects(eDam, eVisDam);

		//Caster effects
		effect eHeal = EffectHeal(nDam);
		effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
		effect eHealLink = EffectLinkEffects(eHeal, eVisHeal);

		//Apply to Target
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

		//Apply to Caster
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHealLink, oCaster);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}


/*

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object 	oPC 			= OBJECT_SELF;
int 	nPCMaxHP 		= GetMaxHitPoints(oPC);
int 	nPCCurrentHP	= GetCurrentHitPoints(oPC);
int		nPCCasterLevel = HkGetCasterLevel(oPC);
object 	oTarget 		= GetSpellTargetObject();
int 		nDamage			= nPCMaxHP - nPCCurrentHP;



if (nDamage > nPCCasterLevel)nDamage = nPCCasterLevel;

effect eDamage 		= EffectDamage(nDamage,DAMAGE_TYPE_MAGICAL);
int nGold = GetGold(oPC);

if (nGold < 10)
{
SendMessageToPC(oPC,"You don't have the material components needed for this spell");
return;
}

TakeGoldFromCreature(10,oPC,TRUE,TRUE);


if (GetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT || GetRacialType(oTarget) ==RACIAL_TYPE_UNDEAD)
{
SendMessageToPC(oPC,"Target must be a living creature");
return;
}



effect	eHeal			= EffectHeal(nDamage);
effect eDur = EffectVisualEffect( VFX_DUR_REGENERATE );
effect eLink = EffectLinkEffects(eHeal, eDur);


if (!HkResistSpell(oPC, oTarget) && !HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_DEATH,OBJECT_SELF))
	{
	HkApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oPC);
	}
}
*/