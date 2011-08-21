//::///////////////////////////////////////////////
//:: Doom
//:: NW_S0_Doom.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	If the target fails a save they recieve a -2
	penalty to all saves, attack rolls, damage and
	skill checks for the duration of the spell.

	July 22 2002 (BK): Made it mind affecting.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: RPGplayer1 03/27/2008: Won't roll saving throw if blocked by SR or immunity


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{
	//scSpellMetaData = SCMeta_SP_doom();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DOOM;
	int iClass = CLASS_TYPE_NONE;
	if ( iSpellId == SPELL_BG_Doom )
	{
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	object oTarget = HkGetSpellTarget();
	//effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY); // All visual effects for Doom are now handled in SCCreateDoomEffectsLink(); see nw_i0_spells.nss for more info
	effect eLink = SCCreateDoomEffectsLink();
	
	int iLevel = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	
	float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds(iLevel) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOOM, TRUE));
		//Spell Resistance and Saving throw
		
		if (!HkResistSpell(OBJECT_SELF, oTarget) )
		{
			//* GZ Engine fix for mind affecting spell
			
			int iResult = WillSave(oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS);
			if ( iResult == 2 )
			{
				if ( GetIsPC(OBJECT_SELF) ) // only display immune feedback for PCs
				{
					FloatingTextStrRefOnCreature( 84525, oTarget, FALSE ); // * Target Immune
				}
				return;
			}
			
			//iResult = (iResult || HkResistSpell(OBJECT_SELF, oTarget));
			if (!iResult)
			{
				//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
				HkApplyEffectToObject(iDurType, eLink , oTarget, fDuration);
			}
		}
	}
	
	HkPostCast(oCaster);
}

