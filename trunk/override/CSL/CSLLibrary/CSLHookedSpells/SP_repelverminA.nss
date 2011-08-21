//::///////////////////////////////////////////////
//:: Repel Vermin - On Enter
//:: sg_s0_repverminen.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Abjuration
	Level: Animal 4, Clr 4, Drd 4
	Casting Time: 1 action
	Range: 10 ft
	Area: 10 ft emanation centered on you
	Duration: 10 minutes/level
	Saving Throw: None or will negates (see text)
	Spell Resistance: Yes

	An invisible barrier holds back vermin. A vermin
	with less than 1/3 you level in HD cannot
	penetrate the barrier. a vermin with at least
	1/3 your level in HD can penetrate the barrier
	on a successful Will Save. Even so, crossing
	the barrier does 2d6 points of damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: July 29, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= GetLocation(oCaster);
	int 	iDC; 			//= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	//float 	fDuration 		= TurnsToSeconds(10*iCasterLevel);
	//---
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	//float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	//int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//---

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 6;
	int 	iNumDice 		= 2;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	float 	fRadius 		= FeetToMeters(10.0);
	location lBehindLoc;
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	//if(SGCheckMetamagic(iMetamagic,METAMAGIC_EXTEND)) fDuration *= 2;
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImp 	= EffectVisualEffect(VFX_IMP_HEAD_SONIC);
	effect eVis 	= EffectVisualEffect(VFX_IMP_HEAD_FIRE);
	effect eDamage;
	effect eLink;

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_REPEL_VERMIN, FALSE));
	if(  CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && CSLGetIsVermin(oTarget) )
	{
		if(!HkResistSpell(oCaster, oTarget))
		{
			iDC = HkGetSpellSaveDC(oCaster, oTarget);
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_REPEL_VERMIN));
			if((GetHitDice(oTarget)<(iCasterLevel/3)) || (!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC)))
			{
				lBehindLoc = CSLGenerateNewLocation(oTarget, SC_DISTANCE_SHORT, CSLGetOppositeDirection(GetFacing(oTarget)), GetFacing(oTarget));
				AssignCommand(oTarget,ClearAllActions(TRUE));
				AssignCommand(oTarget,JumpToLocation(lBehindLoc));
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
			}
			else
			{
				iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;
				eDamage = EffectDamage(iDamage);
				eLink = EffectLinkEffects(eDamage,eVis);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
		}
	}
}