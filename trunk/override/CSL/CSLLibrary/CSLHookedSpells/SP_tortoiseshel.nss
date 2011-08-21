//::///////////////////////////////////////////////
//:: Tortoise Shell
//:: nw_s0_tortshell.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Tortoise Shell grants a +6 enhancement bonus to the subject's
	existing natural armor bonus.  This enhancement bonus increases
	by 1 for every three caster levels beyond 11th, to a maximum
	of +9 at 20th level.  Tortoise Shell slows a creature's
	movement to half its normal rate for the duration.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 12, 2006
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void main()
{
	//scSpellMetaData = SCMeta_SP_tortoiseshel();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TORTOISE_SHELL;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	object oTarget   =  HkGetSpellTarget();
	if (oTarget!=oCaster)
	{
		SendMessageToPC(oCaster, "Sorry, you can only target yourself with this spell on DEX.");
		return;
	}

	int iLevel = HkGetSpellPower( oCaster, 20 ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster );
	int nAC = CSLGetMin(9, 6 + (iLevel - 11) / 3);
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds(10 * iDuration));
	
	if( CSLGetPreferenceSwitch("FreedomDeathwardBuffExclude", FALSE ) )
	{
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_FREEDOM_OF_MOVEMENT, SPELL_ASN_Freedom_of_Movement, SPELL_BG_Freedom_of_Movement );
	}
	
	CSLUnstackSpellEffects(oCaster, GetSpellId());
	CSLUnstackSpellEffects(oCaster, SPELL_BARKSKIN, "Barkskin");
	CSLUnstackSpellEffects(oCaster, SPELL_SPIDERSKIN, "Spiderskin");

	effect eLink = EffectVisualEffect(VFX_SPELL_DUR_TORT_SHELL);
	eLink = EffectLinkEffects(eLink, EffectACIncrease(nAC, AC_NATURAL_BONUS));
	eLink = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(50));

	HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration, HkGetSpellId());

	HkPostCast(oCaster);
}

