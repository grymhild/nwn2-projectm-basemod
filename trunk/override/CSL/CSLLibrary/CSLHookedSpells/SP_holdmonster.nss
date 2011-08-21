//::///////////////////////////////////////////////
//:: Hold Monster
//:: NW_S0_HoldMon
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Will hold any monster in place for 1
	round per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: Aug 1, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
 


void main()
{
	//scSpellMetaData = SCMeta_SP_holdmonster();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HOLD_MONSTER;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	




	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration( OBJECT_SELF ) ;
	iDuration = HkGetScaledDuration(iDuration, oTarget);
	int iSaveDC = HkGetSpellSaveDC();
	effect eParal = EffectParalyze(iSaveDC, SAVING_THROW_WILL);
	effect eHit = EffectVisualEffect( VFX_DUR_SPELL_HOLD_MONSTER );
	eParal = EffectLinkEffects( eParal, eHit );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
				

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_MONSTER));
		//Make SR check
		if (!HkResistSpell(OBJECT_SELF, oTarget))
		{
				//Make Will save
				if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC))
				{
						//Apply the paralyze effect and the VFX impact
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParal, oTarget,fDuration );
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
				}
			}
	}
	
	HkPostCast(oCaster);
}

