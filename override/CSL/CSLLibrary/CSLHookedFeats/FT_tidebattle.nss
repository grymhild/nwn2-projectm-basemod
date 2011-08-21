//::///////////////////////////////////////////////
//:: Tide of Battle
//:: x2_s0_TideBattle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Uses spell effect to cause d100 damage to
	all enemies and friends around pc, including pc.
	(Area effect always centered on PC)
	Minimum 30 points of damage will be done to each target
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////
//:: Updated by: Andrew Nobbs
//:: Updated on: March 28, 2003

#include "_HkSpell"
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_tidebattle();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	



	//Declare major variables
	object oTarget;
	//effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD); // no longer using NWN1 VFX
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_DEATH_WARD ); // uses NWN2 VFX
	effect eVis2 = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
	effect eDamage;
	effect eLink;
	int iDamage;

	//Apply Spell Effects
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(OBJECT_SELF));

	//ApplyDamage and Effects to all targets in area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	float fDelay;
	while(GetIsObjectValid(oTarget))
	{
		fDelay = CSLRandomBetweenFloat();
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
		iDamage = d100();
		if (iDamage < 30)
		{
			iDamage = 30;
		}
		//Set damage type and amount
		eDamage = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
		//Link visual and damage effects
		eLink = EffectLinkEffects(eVis, eDamage);
		//Apply effects to oTarget
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
		
		//Get next target in shape
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
	}
	HkPostCast(oCaster);
}