//::///////////////////////////////////////////////
//:: Name 	Flesh Ripper
//:: FileName sp_flesh_rip
//:://////////////////////////////////////////////
/**@file Flesh Ripper
Evocation [Evil]
Level: Clr 3, Mortal Hunter 3
Components: V, S, Undead, Fiend
Casting Time: 1 action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One living creature
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

The caster evokes pure evil power in the form of a
black claw that flies at the target. If a ranged
touch attack roll succeeds, the claw deals 1d8
points of damage per caster level (maximum 10d8).
On a critical hit, in addition to dealing double
damage, the wound bleeds for 1 point of damage per
round until it is magically healed.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"
#include "_CSLCore_Combat"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_FLESH_RIPPER; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	

	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 );
	int nMetaMagic = HkGetMetaMagicFeat();

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_FLESH_RIPPER, oCaster);

	//Caster must be undead. If not, hit 'em with alignment change anyway.
	//Try reading the description of the spell moron. =P

	if(  CSLGetIsUndead(oCaster) )
	{
		//Check spell resistance
		if(!HkResistSpell(oCaster, oTarget ))
		{
			int iTouch = CSLTouchAttackRanged(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
				int nDam = HkApplyMetamagicVariableMods(d8(iSpellPower), 8 * iSpellPower);
				nDam = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nDam, SC_TOUCHSPELL_RANGED, oCaster );
		
				//Non-descript
				effect eDam = HkEffectDamage(DAMAGE_TYPE_MAGICAL, nDam);
	
				//VFX
				effect eVis = EffectBeam(VFX_BEAM_BLACK, oCaster, BODY_NODE_HAND);

			//Make touch attack
			
				//Apply VFX
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

				//Apply damage
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			

				if( nTouch == TOUCH_ATTACK_RESULT_CRITICAL )
				{
					//Wounding
					effect eWound = EffectHitPointChangeWhenDying(1.0f);
	
					HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eWound, oTarget);
				}
			}
		}
	}
	CSLSpellEvilShift(oCaster);

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}