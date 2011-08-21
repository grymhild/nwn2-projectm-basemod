//::///////////////////////////////////////////////
//:: Name 	Avascular Mass
//:: FileName 	sp_avas_mass.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*Avascular Mass
	Necromancy [Death, Evil]
	Sorc/Wizard 8
	Range: Close
	Saving Throw: Fortitude partial and Reflex negates
	Spell Resistance: yes

	You shoot a ray of necromantic energy from your outstretched
	hand, causing any living creature struck by the ray to violently
	purge blood vessels through its skin. You must succeed
	on a ranged touch attack to affect the subject. If successful, the
	subject is reduced to half of its current hit points (rounded down)
	and stunned for 1 round. On a successful Fortitude saving throw the
	subject is not stunned.

	Also, the purged blood vessels are magically animated, creating a many
	layered mass of magically strong, adhesive tissue that traps those caught
	in it... Creatures caught within a 20 foot radius become entangled unless
	the succeed on a Reflex save. The original target of the spell is automatically
	entangled.

	The entangled creature takes a -2 penalty on attack rolls, -4 to effective Dex,
	and can't move. An entangled character that attempts to cast a spell must succeed
	in a concentration check. Because the avascular mass is magically animate, and
	gradually tightens on those it holds, the Concentration check DC is 30...Once loose,
	a creature may progress through the writhing blood vessels very slowly.

	Spell is modeled after Entanglement, using three seperate scripts.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 10/05/05
//:://////////////////////////////////////////////
//::Added hold ray functionality - HackyKid
//#include "prc_alterations"
//#include "x2_inc_spellhook"
//#include "spinc_common"
//#include "prc_misc_const"
//#include "prc_sp_func"

#include "_HkSpell"
#include "_CSLCore_Combat"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
/*
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
	return iTouch; 	//return TRUE if spell charges should be decremented
}
*/



void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_AVASCULAR_MASS; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 

	object oTarget = HkGetSpellTarget();
	//--------------------------------------------------------------------------
	//do spell
	//--------------------------------------------------------------------------
	int nMetaMagic = HkGetMetaMagicFeat();
	int nSaveDC = HkGetSpellSaveDC(oTarget, oCaster);
	int nHP = GetCurrentHitPoints(oTarget);
	effect eHold = EffectEntangle();
	effect eSlow = EffectSlow();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_AVASCULAR_MASS, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_AVASCULAR_MASS, oCaster);

	// Gotta be a living critter
	if ( CSLGetIsLiving(oTarget) )
	{
		//temporary VFX
	
		effect eLink = EffectVisualEffect(VFX_DUR_ENTANGLE);
	
		//damage rounds up
		int nDam = (nHP - (nHP / 2));
		effect eDam = HkEffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
	
	
		//Blood gush
		effect eBlood = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
	
		//Make touch attack
		int iTouch = CSLTouchAttackRanged(oTarget);
		
		// Do attack beam VFX. Ornedan is my hero.
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_EVIL, oCaster, BODY_NODE_HAND, !iTouch), oTarget, 1.0f);
	
		
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			//Spell Resistance
			if (!HkResistSpell(OBJECT_SELF, oTarget ))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBlood, oTarget);
	
	
				//Apply AoE writing blood vessel VFX centered on oTarget
				//HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eMass, lLocation, fDuration);
	
				//Orignial target automatically entangled
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2),-1);
	
				//Fortitude Save for Stun
				if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_EVIL))
				{
					effect eStun = EffectStunned();
					effect eStunVis = EffectVisualEffect(VFX_IMP_STUN);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eStunVis, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(1));
				}
	
				//Declare major variables for Mass including Area of Effect Object
				effect eAOE = EffectAreaOfEffect(VFX_PER_AVASMASS);
				location lTarget = HkGetSpellTargetLocation();
	
				
				
				int iDuration = CSLGetMax(3+HkGetSpellDuration( oCaster, 30 )/2, 1);
				float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	
				//Create an instance of the AOE Object using the Apply Effect function
				HkApplyEffectAtLocation(iDurType, eAOE, lTarget, fDuration);
				// Getting rid of the local integer storing the spellschool name
			}
		}
		CSLSpellEvilShift(oCaster);
	}
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}