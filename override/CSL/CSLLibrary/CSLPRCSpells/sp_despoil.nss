//::///////////////////////////////////////////////
//:: Name 	Despoil
//:: FileName sp_despoil.nss
//:://////////////////////////////////////////////
/**@file Despoil
Transmutation [Evil]
Level: Clr 9
Components: V, S, M
Casting Time: 1 minute
Range: Touch
Area: 100-ft./level radius
Duration: Instantaneous
Saving Throw: Fortitude partial (plants) or Fortitude negates (other living creatures)
Spell Resistance: Yes

The caster blights and corrupts a vast area of land.
Plants with 1 HD or less shrivel and die, and the
ground cannot support such plant life ever again.
Plants with more than 1 HD must succeed at a
Fortitude saving throw or die. Even those successful
on their saves take 5d6 points of damage. All living
creatures in the area other than plants (and the
caster) must succeed at a Fortitude saving throw
or take 1d4 points of Strength damage.

Unattended objects, including structural features
such as walls and doors, grow brittle and lose 1
point of hardness (to a minimum of 0), then take
1d6 points of damage.

Only the effects of multiple wish or miracle spells
can undo the lasting effects of this spell.

Material Component: Corpse of a freshly dead or
preserved (still bloody) living creature.

Author: 	Tenjac
Created: 	6/12/06
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
	int iSpellId = SPELL_DESPOIL; // put spell constant here
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

	//


	
	int nCasterLevel = HkGetCasterLevel(oCaster);
	int iSpellPower = HkGetSpellPower( oCaster, 30 ); 
	location lLoc = HkGetSpellTargetLocation();

	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, (10.0f * iSpellPower), lLoc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

	while(GetIsObjectValid(oTarget))
	{
		//Spell resistance
		if(!HkResistSpell(oCaster, oTarget ))
		{
			int nType = GetObjectType(oTarget);

			int nDC = HkGetSpellSaveDC(oCaster,oTarget);

			if(nType == OBJECT_TYPE_CREATURE)
			{
				if( CSLGetIsPlant(oTarget))
				{
					//Check HD
					if(GetHitDice(oTarget) == 1)
					{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
					}
					else
					{
						//Save
						if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
						{
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
						}

						else
						{
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(DAMAGE_TYPE_MAGICAL, d6(5)), oTarget);
						}
					}
				}

				
				if ( CSLGetIsLiving(oTarget) ) //nonliving
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE), oTarget, 1.0f);
				}
				else //living
				{
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SPELL))
					{
						SCApplyAbilityDrainEffect( ABILITY_STRENGTH, d4(1), oTarget, DURATION_TYPE_TEMPORARY, -1.0f);
					}
				}
			}
			if(nType == OBJECT_TYPE_DOOR || nType == OBJECT_TYPE_PLACEABLE)
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(DAMAGE_TYPE_MAGICAL, d6(1)), oTarget);
			}
		}

		oTarget = GetNextObjectInShape(SHAPE_SPHERE, (10.0f * iSpellPower), lLoc, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}