//::///////////////////////////////////////////////
//:: Name: 	Lahm's Finger Darts
//:: Filename: sp_lahms_fd.nss
//::///////////////////////////////////////////////
/**@file Lahm's Finger Darts
Transmutation [Evil]
Level: Corrupt 2
Components: V S, Corrupt
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Targets: Up to five creatures, no two of which can
be more than 15 ft. apart
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

The caster's finger becomes a dangerous projectile
that flies from her hand and unerringly strikes its
target. The dart deals 1d4 points of Dexterity
damage. Creatures without fingers cannot cast this
spell.

The dart strikes unerringly, even if the target is
in melee or has partial cover or concealment.
Inanimate objects (locks, doors, and so forth)
cannot be damaged by the spell.

For every three caster levels beyond 1st, the caster
gains an additional dart by losing an additional
finger: two at 4th level, three at 7th level, four
at 10th level, and the maximum of five darts at 13th
level or higher. If the caster shoots multiple darts,
she can have them strike a single creature or several
creatures. A single dart can strike only one creature.
The caster must designate targets before checking for
spell resistance or damage.

Fingers lost to this spell grow back when the
corruption cost is healed, at the rate of one finger
per point of Strength damage healed.

Corruption Cost: 1 point of Strength damage per dart,
plus the loss of one finger per dart. A hand with one
or no fingers is useless.

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_SCInclude_Necromancy"
#include "_CSLCore_Nwnx"
void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LAHMS_FINGER_DARTS; // put spell constant here
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

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = HkGetSpellTarget();
	int nLFingers = (CSLGetPersistentInt(oCaster, "FINGERS_LEFT_HAND") - 1);
	int nRFingers = (CSLGetPersistentInt(oCaster, "FINGERS_RIGHT_HAND")- 1);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nFingers = 1;
	int nDam;
	effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
	effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
	effect eDam = EffectAbilityDecrease(ABILITY_DEXTERITY, nDam);
	float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
	float fDelay = fDist/(3.0 * log(fDist) + 2.0);
	float fDelay2, fTime;
	location lTarget = HkGetSpellTargetLocation();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_LAHMS_FINGER_DARTS, oCaster);

	//Set up fingers if it hasn't been done before
	if (CSLGetPersistentInt(oCaster, "FINGERS_LEFT_HAND") < 1)
	{
		CSLSetPersistentInt(oCaster, "FINGERS_LEFT_HAND", 6);
		CSLSetPersistentInt(oCaster, "FINGERS_RIGHT_HAND", 6);
	}

	//Spell Resistance, no save
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//Calculate fingers used
		if(nCasterLvl > 3) nFingers++;
		if(nCasterLvl > 6) nFingers++;
		if(nCasterLvl > 9) nFingers++;
		if(nCasterLvl > 12) nFingers++;

		//gotta set up a new counter because nFingers is used later
		int nCounter = nFingers;

		//Determine which hand to screw up
		if(nLFingers > nFingers)
		{
			nLFingers -= nFingers;
			CSLSetPersistentInt(oCaster, "FINGERS_LEFT_HAND", nLFingers);
		}

		else if(nRFingers > nFingers)
		{
			nRFingers -= nFingers;
			CSLSetPersistentInt(oCaster, "FINGERS_RIGHT_HAND", nRFingers);
		}

		else
		{
			SendMessageToPC(oCaster, "You do not have enough fingers left to cast this spell");
			nCounter = 0;
		}

		//Damage loop
		while(nCounter > 0)
		{
			nDam = d4(1);

			//Apply the MIRV and damage effect
			DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
			DelayCommand(fDelay2, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
			DelayCommand(fTime, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

			// Play the sound of a dart hitting
			DelayCommand(fTime, PlaySound("cb_ht_dart1"));

			//decrement nCounter to handle loop termination
			nCounter--;
		}

		//Determine usefullness of remaining stumps
		if(nLFingers < 2)
		{
			//mark left hand useless
			CSLSetPersistentInt(oCaster, "LEFT_HAND_USELESS", 1);
		}

		if(nRFingers < 2)
		{
			//mark right hand useless
			CSLSetPersistentInt(oCaster, "RIGHT_HAND_USELESS", 1);
		}
	}

	CSLSpellEvilShift(oCaster);
	SCApplyCorruptionCost(oCaster, ABILITY_STRENGTH, nFingers, 0);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}