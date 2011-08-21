//::///////////////////////////////////////////////
//:: Wall of Sound
//:: sg_s0_wallsnd.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation
     Level: Brd 3
     Components: V, S
     Casting Time: 1 action
     Range: Short
     Duration: 1 round/level
     Area of Effect: Special
     Saving Throw: See text
     Spell Resistance: No

     The wall of sound spell brings forth an immobile, shimmering curtain of violently
     disturbed air. The wall is 10 meters wide x 2 meters thick. One side of the wall (away from the caster),
     produces a voluminous roar that completely disrupts all communication, command words, verbal spell components, and
     any other form of organized sound within 30 feet. In addition, those within 10 feet are
     deafened for 1d4 turns if they fail a fortitude save.
     On the other side of the wall, a loud roar can be heard, but communication is possible
     by shouting, and verbal components and command words function normally.
     Anyone passing through the wall suffers 1d8 points of damage and is permanently
     deafened unless he makes a successful Fortitude save.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 5, 2004
//:://////////////////////////////////////////////
// #include "sg_inc_elements"
//
//
// void main()
// {
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration) );
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower,  fDuration,FALSE  );
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	location lTargetSoundBlock = CSLGenerateNewLocationFromLocation(lTarget, FeetToMeters(15.0), GetFacing(oCaster), GetFacing(oCaster));
	location lTargetDeafenChance = CSLGenerateNewLocationFromLocation(lTarget, FeetToMeters(5.0), GetFacing(oCaster), GetFacing(oCaster));
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImpVis = EffectVisualEffect(VFX_FNF_SOUND_BURST);
	effect eAOE1 = EffectAreaOfEffect(AOE_PER_WALLSOUND, "", "", "", sAOETag);
	effect eAOE2 = EffectAreaOfEffect(AOE_PER_WALLSND_DEAF, "", "", "", sAOETag);
	effect eAOE3 = EffectAreaOfEffect(AOE_PER_WALLSND_SNDBLK, "", "", "", sAOETag);
	
	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, lTarget);
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE1, lTarget, fDuration);
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE2, lTargetDeafenChance, fDuration);
	HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE3, lTargetSoundBlock, fDuration);
	HkPostCast(oCaster);
}


