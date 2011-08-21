//::///////////////////////////////////////////////
//:: Name 	Baleful Polymorph
//:: FileName sp_bale_polym.nss
//:://////////////////////////////////////////////
/**@file Baleful Polymorph
Transmutation
Level: Drd 5, Sor/Wiz 5
Components: V, S
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: Permanent
Saving Throw: Fortitude negates, Will partial; see text
Spell Resistance: Yes

As polymorph, except that you change the subject into a
Small or smaller animal of no more than 1 HD. If the new
form would prove fatal to the creature the subject gets
a +4 bonus on the save.

If the spell succeeds, the subject must also make a Will
save. If this second save fails, the creature loses its
extraordinary, supernatural, and spell-like abilities,
loses its ability to cast spells (if it had the ability),
and gains the alignment, special abilities, and
Intelligence, Wisdom, and Charisma scores of its new form
in place of its own. It still retains its class and level
(or HD), as well as all benefits deriving therefrom (such
as base attack bonus, base save bonuses, and hit points).
It retains any class features (other than spellcasting)
that aren't extraordinary, supernatural, or spell-like
abilities.

Incorporeal or gaseous creatures are immune to being
polymorphed, and a creature with the shapechanger subtype
can revert to its natural form as a standard action.
**/

//:///////////////////////////////////////////////////
//: Author: 	Tenjac
//: Date : 	9/8/06
//:://////////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"
//#include "_CSLCore_Info"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BALEFUL_POLYMORPH; // put spell constant here
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
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE));
	//SPRaiseSpellCastAt(oTarget,TRUE, SPELL_BALEFUL_POLYMORPH, oCaster);
	

	//SR
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//First save
		if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
		{
			if(!CSLGetIsIncorporeal(oTarget))
			{
				//Adjust
				int nHP = GetCurrentHitPoints(oTarget);
				int nDam = (nHP - 10);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(nDam, DAMAGE_TYPE_DIVINE), oTarget);

				effect ePoly = EffectPolymorph(POLYMORPH_TYPE_CHICKEN, TRUE);
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, oTarget, 0.0f, iSpellId);
			}

		}
	}

	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}




