//::///////////////////////////////////////////////
//:: Blade Barrier, Self : On Enter
//:: NW_S0_BladeBarSelfA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Creates a curtain of blades 10m in diameter around the caster
	that hack and slice anything moving into it.  Anything
	caught in the blades takes 2d6 per caster level.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_bladebarself(); //SPELL_BLADE_BARRIER;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_BLADE_BARRIER_SELF;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCaster = GetAreaOfEffectCreator();
	int iDice = HkGetSpellPower(oCaster, 15);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) && (oTarget!=oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BLADE_BARRIER, TRUE ));
		if (!HkResistSpell(oCaster, oTarget)) {
			int iDamage = HkApplyMetamagicVariableMods(d6(iDice), 6 * iDice);
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster);
			if (iDamage) {
				effect eDam = EffectLinkEffects(EffectDamage(iDamage, DAMAGE_TYPE_SLASHING), EffectVisualEffect(VFX_COM_BLOOD_REG_RED));
				SpawnBloodHit(oTarget, TRUE, OBJECT_INVALID);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			}
		}
	}
}