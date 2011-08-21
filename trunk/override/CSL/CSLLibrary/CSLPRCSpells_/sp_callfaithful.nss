//::///////////////////////////////////////////////
//:: Name 	Call Faithful Servants
//:: FileName sp_call_fserv.nss
//:://////////////////////////////////////////////
/**@file Call Faithful Servants
Conjuration(Calling) [Good]
Level: Celestial 6, cleric 6, sorc/wiz 6
Components: V, S, Abstinance, Celestial
Casting Time: 1 minute
Range: Close
Duration: Instantaneous

You call 1d4 lawful good lantern archons from Celestia,
1d4 chaotic good coure eladrins from Arborea, or 1d4
neutral good mesteval guardinals from Elysium to
your location. They serve you for up to one year
as guards, soldiers, spies, or whatever other holy
purpose you have.

No matter how many times you cast this spell, you
can control no more than 2HD worth of celestials
per caster level. If you exceed this number, all
the newly created creatures fall under your
control, and any excess servants from previous
castings return to their home plane.

Absinance Component: The character must abstain
from casting Conjuration spells for 3 days prior
to casting this spell.

Author: 	Tenjac
Created: 	6/14/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
//#include "prc_inc_template"

void SummonLoop(int nCounter, location lLoc, object oCaster);


#include "_HkSpell"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CALL_FAITHFUL_SERVANTS; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	//


	
	location lLoc = HkGetSpellTargetLocation();
	int nCounter = HkApplyMetamagicVariableMods(d4(1), 4 );
	int nMetaMagic = HkGetMetaMagicFeat();

	//Must be celestial
	if(GetHasTemplate(TEMPLATE_CELESTIAL) ||
		GetHasTemplate(TEMPLATE_HALF_CELESTIAL) ||
		( CSLGetIsOutsider(oCaster)  && GetAlignmentGoodEvil(oCaster) == ALIGNMENT_GOOD)
		)

	{
		//Get original max henchmen
		int nMax = GetMaxHenchmen();

		//Set new max henchmen high
		SetMaxHenchmen(150);

		SummonLoop(nCounter, lLoc, oCaster);

		//Restore original max henchmen
		SetMaxHenchmen(nMax);
	}

	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
	CSLSpellGoodShift(oCaster);
}

void SummonLoop(int nCounter, location lLoc, object oCaster)
{
	while(nCounter > 0)
	{
		//Create appropriate Ghoul henchman
		object oArchon = CreateObject(OBJECT_TYPE_CREATURE, "nw_clantern", lLoc, TRUE, "Archon" + IntToString(nCounter));

		//Make henchman
		AddHenchman(oCaster, oArchon);

		nCounter--;
		SummonLoop(nCounter, lLoc, oCaster);
	}
}

