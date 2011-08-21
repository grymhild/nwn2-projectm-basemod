//::///////////////////////////////////////////////
//:: Foundation of Stone
//:: nw_s0_foundstone.nss
//:: Copyright (c) 2006 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Calling on the strength of the earth, you lend some of the stability
	of stone to yourself or an ally.  The subject is immune to knockdown
	effects for the duration of the spell, but moves at a greatly reduced
	speed.
*/
//:://////////////////////////////////////////////
//:: Created By: Patrick Mills
//:: Created On: Oct 17, 2006
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_foundationst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FOUNDATION_OF_STONE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	


//Major variables
	object oTarget = HkGetSpellTarget();
	
	effect eVis = EffectVisualEffect(VFX_SPELL_DUR_FOUND_STONE);
	effect eImmuneKO = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
	effect eSlow = EffectMovementSpeedDecrease(50);
	int nDur = 3+HkGetSpellDuration(oCaster);
	float fDuration = RoundsToSeconds(nDur);

//Link effects
	effect eLink = EffectLinkEffects(eVis, eImmuneKO);
			eLink = EffectLinkEffects(eLink, eSlow);

//Determine duration
			fDuration = HkApplyMetamagicDurationMods(fDuration);

//Validate target and apply effects
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			if( CSLGetPreferenceSwitch("FreedomDeathwardBuffExclude", FALSE ) )
			{
				CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_FREEDOM_OF_MOVEMENT, SPELL_ASN_Freedom_of_Movement, SPELL_BG_Freedom_of_Movement );
			}
			HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
		}
	}
	
	HkPostCast(oCaster);
}
	

