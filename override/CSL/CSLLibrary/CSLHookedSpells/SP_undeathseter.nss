//::///////////////////////////////////////////////
//:: Undeath's Eternal Foe
//:: x0_s0_udetfoe.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Grants many protections against undead
	to allies in a small area
	of effect (everyone gets negative energy protection)
	immunity to poison and disease too
	+4 AC bonus to all creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



void GrantProtection(object oTarget)
{
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ABJURATION);
	effect eVis = EffectVisualEffect(VFX_HIT_SPELL_HOLY);//Holy effect for consistancy
	effect eNeg = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 9999,0);
	effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
	effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
	effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
	effect eDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);
	//effect eAC = EffectACIncrease(4);
	effect eIcon = EffectVisualEffect(VFX_DUR_SPELL_UNDEATH_ETERNAL_FOE);

	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	//Link Effects
	effect eLink = EffectLinkEffects(eNeg, eLevel);
	eLink = EffectLinkEffects(eLink, eAbil);
	//eLink = EffectLinkEffects(eLink, eAC);
	eLink = EffectLinkEffects(eLink, ePoison);
	eLink = EffectLinkEffects(eLink, eDisease);
	eLink = EffectLinkEffects(eLink, eIcon);

	//Apply the VFX impact and effects
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );

}



void main()
{
	//scSpellMetaData = SCMeta_SP_undeathseter();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_UNDEATHS_ETERNAL_FOE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_CURE_AOE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget;

	float fDelay;
	//Metamagic duration check
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	//Get the first target in the radius around the caster
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF) || GetFactionEqual(oTarget))
		{
			fDelay = CSLRandomBetweenFloat(0.4, 1.1);
			//Fire spell cast at event for target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 444, FALSE));
			GrantProtection(oTarget);
		}
		//Get the next target in the specified area around the caster
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, HkGetSpellTargetLocation());
	}
	
	HkPostCast(oCaster);
}

