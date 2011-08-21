//::///////////////////////////////////////////////
//:: Glitterdust
//:: SG_S0_GltDust.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	Conjuration (Creation)
	Level: Brd 2, Sor/Wiz 2
	Components: V,S
	Casting Time: 1 action
	Range: Medium (100 ft + 10 ft/level)
	Area: Creatures and objects within a 10-ft spread
	Duration: 1 round/level
	Saving Throw: Will negates (Blinding Only )
	Spell Resistance: No
	
	A cloud of golden particles covers everyone and everything in the area, blinding creatures and
	visibly outlining invisible things for the duration of the spell.  All within the area are covered
	by the dust, which cannot be removed and continues to sparkle until it fades.
	
	From SRD
	A cloud of golden particles covers everyone and everything in the area, causing creatures to become
	blinded and visibly outlining invisible things for the duration of the spell. All within the area
	are covered by the dust, which cannot be removed and continues to sparkle until it fades.
	
	Any creature covered by the dust takes a -40 penalty on Hide checks.
	
	This does not affect Ethereal, Astral, or Incorporeal Creature
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_GLITTERDUST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	float 	fDelay;
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);


	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eLink = EffectVisualEffect(VFXSC_GLITTERDUST);
	eLink = EffectLinkEffects(eLink,  EffectSkillDecrease(SKILL_HIDE, 40));
	eLink = EffectLinkEffects(eLink, EffectConcealmentNegated());
	effect eBlind 	= EffectBlindness();

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	fDelay=CSLRandomBetweenFloat(0.4,1.1);
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_GLITTERDUST, TRUE ));
	//if(!HkResistSpell(oCaster,oTarget)) {
	if ( !CSLGetIsImmuneToClouds(oTarget) )
	{
		if( !CSLGetHasEffectType( oTarget, EFFECT_TYPE_BLINDNESS ) && oTarget != oCaster)
		{
			if(!HkSavingThrow(SAVING_THROW_WILL,oTarget,iDC,SAVING_THROW_TYPE_SPELL, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER))
			{
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, fDuration, iSpellId));
			}
		}
		// This is not a valid spell yet SPELL_BLUR, perhaps mirror images and other new concealment spells
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_INVISIBILITY_SPHERE, SPELL_DISAPPEAR, SPELL_INVISIBILITY, SPELL_ASN_Invisibility, SPELL_ASN_Spellbook_3, SPELLABILITY_AS_INVISIBILITY, SPELLABILITY_INVISIBILITY, SPELL_SHADOW_CONJURATION_INIVSIBILITY );
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_CHAMELEON_SKIN, SPELL_DISPLACEMENT, SPELL_CAMOFLAGE, SPELL_MASS_CAMOFLAGE, SPELL_I_RETRIBUTIVE_INVISIBILITY, SPELL_GREATER_INVISIBILITY );
		
		
		if (GetActionMode(oTarget, ACTION_MODE_STEALTH)==TRUE)
		{
			SetActionMode(oTarget, ACTION_MODE_STEALTH, FALSE);
		}
		DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId ));
	}
}