// nx_s1_demilich_touch
//
// Demilich touch attack.
//
// JSH-OEI 6/21/07

//#include "ginc_item"
#include "_HkSpell"

void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	object oCaster = OBJECT_SELF;
	object oTarget = HkGetSpellTarget();
	int iSpellId = HkGetSpellId();
	//SCMETA_DESCRIPTOR_NEGATIVE
		
	int nChaModifier = GetAbilityModifier(ABILITY_CHARISMA, oCaster);
	int iHD = HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); // GetTotalLevels(OBJECT_SELF, TRUE);
	int iDuration = 5; // 5 rounds
	int iSaveDC = (10 + nChaModifier + iHD);
	int nDamageAmt = d6(10) + 20;
	
	effect eDamage = EffectDamage(nDamageAmt, DAMAGE_TYPE_NEGATIVE);
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
	effect eParalyze = EffectParalyze(SAVING_THROW_FORT, FALSE);
	effect eVisual = EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eLink = EffectLinkEffects(eParalyze, eVisual);
	eLink = ExtraordinaryEffect(eLink);
	
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
	
	// If target fails the Fortitude save
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
	if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_NONE))
	{
		//PrettyDebug("Charisma modifier is " + IntToString(nChaModifier) + ".");
		//PrettyDebug("DC is " + IntToString(iSaveDC) + ".");
		//PrettyDebug("Target is paralyzed for " + IntToString(iDuration) + " rounds.");
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
		{
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
		}
	}
}