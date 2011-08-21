//::///////////////////////////////////////////////
//:: Destruction
//:: NW_S0_Destruc
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The target creature is destroyed if it fails a
	Fort save, otherwise it takes 10d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 13, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
 


void main()
{
	//scSpellMetaData = SCMeta_SP_destruction();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DESTRUCTION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DEATH, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	object oTarget = HkGetSpellTarget();
	int iDamage;
	effect eDeath = EffectDeath();
	effect eDam;
	effect eVis = EffectVisualEffect(VFX_IMP_DESTRUCTION);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DESTRUCTION));
		
		//Make sure the target is not immune to death effects
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
		{
			FloatingTextStrRefOnCreature(184683, oCaster, FALSE);
			return;
		}
		
		//Make SR check
		if(!HkResistSpell(oCaster, oTarget))
		{
			//Make a saving throw check using support for mettle
			int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, HkGetSpellSaveDC(oCaster, oTarget), SAVING_THROW_TYPE_DEATH, oCaster );
			if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_FULLDAMAGE )
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
				// apply this if they are not dead from the above
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE ) // partial damage is full hit point damage
				{
					iDamage = HkApplyMetamagicVariableMods(d6(10), 6 * 10);
		
					//Set damage effect
					eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
			}
			//Apply VFX impact
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		}
	}
	
	HkPostCast(oCaster);
}

