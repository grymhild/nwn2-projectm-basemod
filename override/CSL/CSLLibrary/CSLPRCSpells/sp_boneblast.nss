//::///////////////////////////////////////////////
//:: Name 	Boneblast
//:: FileName sp_boneblast.nss
//:://////////////////////////////////////////////
/**@file Boneblast
Necromancy [Evil]
Level: Blk 1, Clr 2
Components: V, S, M, Undead
Casting Time: 1 action
Range: Touch
Target: One creature that has a skeleton
Duration: Instantaneous
Saving Throw: Fortitude half or negates
Spell Resistance: Yes

The caster causes some bone within a touched
creature to break or crack. The caster cannot specify
which bone. Because the damage is general rather than
specific, the target takes 1d3 points of Constitution
damage. A Fortitude save reduces the Constitution damage
by half, or negates it if the full damage would have been
1 point of Constitution damage.

Material Component: The bone of a small child that still lives.


Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"



#include "_HkSpell"
#include "_SCInclude_Necromancy"

void main()
{	
	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_BONEBLAST; // put spell constant here
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
	
	
	
	object oTarget = HkGetSpellTarget();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nMetaMagic = HkGetMetaMagicFeat();
	int nDam = d3(1);
	int iDC = HkGetSpellSaveDC(oCaster,oTarget);
	int iSave, iAdjustedDamage;


	//Check for PLAYER undeath
	if( CSLGetIsUndead(oCaster) )
	{
		//check for target skeleton or innate immunity
		//***RACIAL_TYPE_PLANT should also be included if it ever exists***
		if( !CSLGetIsUndead(oTarget) && !CSLGetIsOoze(oTarget) && !CSLGetIsConstruct(oTarget) && !CSLGetIsElemental(oTarget) && !CSLGetIsPlant(oTarget) )
		{
			//Check for resistance
			if(!HkResistSpell(oCaster, oTarget ))
			{
				//Check for save
				iSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_ALL, OBJECT_SELF);
				
				int iAdjustedDamage = HkIsDamageSaveAdjusted(SAVING_THROW_FORT, SAVING_THROW_METHOD_FORPARTIALDAMAGE, oTarget, iDC, SAVING_THROW_TYPE_EVIL, oCaster, iSave );
				if ( iAdjustedDamage >= SAVING_THROW_ADJUSTED_PARTIALDAMAGE )
				{
					if ( iAdjustedDamage < SAVING_THROW_ADJUSTED_FULLDAMAGE ) 
					{
						nDam--;
					}
					
					SCApplyAbilityDrainEffect( ABILITY_CONSTITUTION, nDam, oTarget, DURATION_TYPE_TEMPORARY, -1.0f);
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



