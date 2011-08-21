/*
	sp_nec_cyst

	Necrotic Cyst
	Necromancy [Evil]
	Level: Clr 2, sor/wiz 2
	Components: V, S, F
	Casting Time: 1 standard action
	Range: Touch
	Target: Living creature touched
	Duration: Instantaneous
	Saving Throw: Fortitude negates
	Spell Resistance: Yes

	The subject develops an internal spherical sac that
	contains fluid or semisolid necrotic flesh. The
	internal cyst is noticeable as a slight bulge on the
	subject's arm, abdomen, face (wherever you chose to
	touch the target) or it is buried deeply enough in
	the flesh of your target that it is not immediately
	obvious-the subject may not realize what was implanted
	within her.

	From now on, undead foes and necromantic magic are
	particularly debilitating to the subject-the cyst
	enables a sympathetic response between free-roaming
	external undead and itself. Whenever the victim is
	subject to a spell or effect from the school of
	necromancy, she makes saving throws to resist at a -2
	penalty. Whenever the subject is dealt damage by the
	natural weapon of an undead (claw, bite, or other
	attack form), she takes an additional 1d6 points of
	damage.

	Victims who possess necrotic cysts may elect to have
	some well-meaning chirurgeon remove them surgically.
	The procedure is a bloody, painful process that
	incapacitates the subject for 1 hour on a successful
	DC 20 Heal check, and kills the subject with an
	unsuccessful Heal check. The procedure takes 1 hour,
	and the chirurgeon can't take 20 on the check.

	Protection from evil or a similar spell prevents the
	necrotic cyst from forming. Once a necrotic cyst is
	implanted, spells that manipulate the cyst and its
	bearer are no longer thwarted by protection from evil.

	By: Tenjac
	Created: Oct 30, 2005
	Modified: Jul 2, 2006
*/
//#include "prc_sp_func"

//Implements the spell impact, put code here
// if called in many places, return TRUE if
// stored charges should be decreased
// eg. touch attack hits
//
// Variables passed may be changed if necessary
#include "_HkSpell"
#include "_CSLCore_Combat"
#include "_SCInclude_Necromancy"
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
	int iSpellId = SPELL_NECROTIC_CYST; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
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
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 


	object oTarget = HkGetSpellTarget();
	
	//--------------------------------------------------------------------------
	//Do Spell Script
	//--------------------------------------------------------------------------
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_NECROTIC_CYST, oCaster);

	int iTouch = CSLTouchAttackMelee(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if(GetCanCastNecroticSpells(oCaster))
		{
			if(!(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oTarget) || GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL)))
			{
				if(!HkResistSpell(oCaster, oTarget ))
				{
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(oCaster,oTarget), SAVING_THROW_TYPE_EVIL))
					{
						//ApplyTouchAttackDamage(oCaster, oTarget, iTouch, 0, DAMAGE_TYPE_POSITIVE, DAMAGE_TYPE_MAGICAL);
						int iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, 0, SC_TOUCHSPELL_MELEE, oCaster );
						if ( iDamage > 0 )
						{
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
						}
				
						GiveNecroticCyst(oTarget);
					}
				}
			}
		}
	}

	
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}