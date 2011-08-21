//::///////////////////////////////////////////////
//:: Name 	Clutch of Orcus
//:: FileName sp_clutch_orcus.nss
//:://////////////////////////////////////////////
/**@file Clutch of Orcus
Necromancy [Evil]
Level: Clr 3
Components: V, S
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Target: One humanoid
Duration: Concentration (see text)
Saving Throw: Fortitude negates (see text)
Spell Resistance: Yes

The caster creates a magical force that grips the
subject's heart (or similar vital organ) and
begins crushing it. The victim is paralyzed
(as if having a heart attack) and takes 1d3 points
of damage per round.

Each round, the caster must concentrate to
maintain the spell. In addition, a conscious
victim gains a new saving throw each round to stop
the spell. If the victim dies as a result of this
spell, his chest ruptures and bursts, and his
smoking heart appears in the caster's hand.

Author: 	Tenjac
Created: 	3/28/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"
#include "_HkSpell"

void CrushLoop(object oTarget, object oCaster, int bEndSpell, int nDC)
{

	//Conc check
	if(GetBreakConcentrationCheck(oCaster))
	{
		bEndSpell = TRUE;
	}

	//if makes save, abort
	if(HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
	{
		bEndSpell = TRUE;
	}

	//if Conc and failed save...
	if(bEndSpell = FALSE)
	{
		//Paral
		effect ePar = EffectParalyze();
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, 6.0f);

		//damage
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(d3(1), DAMAGE_TYPE_MAGICAL), oTarget);

		//if dead, end effect
		if(GetIsDead(oTarget))
		{
			effect eChunky = EffectVisualEffect(VFX_COM_CHUNK_RED_MEDIUM);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eChunky, oTarget);

			//End loop next time so it doesn't keep going forever
			bEndSpell = TRUE;
		}

		DelayCommand(6.0f, CrushLoop(oTarget, oCaster, bEndSpell, nDC));
	}
}




void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CLUTCH_OF_ORCUS; // put spell constant here
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

	object oTarget= HkGetSpellTarget();
	int bEndSpell = FALSE;
	int nDC = HkGetSpellSaveDC(oCaster,oTarget);
	int nCasterLvl = HkGetCasterLevel(oCaster);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE));
	//SPRaiseSpellCastAt(oTarget, TRUE, SPELL_CLUTCH_OF_ORCUS, oCaster);

	//Check spell resistance
	if(!HkResistSpell(oCaster, oTarget ))
	{
		//start loop
		CrushLoop(oTarget, oCaster, bEndSpell, nDC);
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}