//::///////////////////////////////////////////////
//:: Name 	Stunning Screech
//:: FileName sp_stn_scrch
//:://////////////////////////////////////////////
/**@file Stunning Screech
Evocation [Evil, Sonic]
Level: Brd 3, Demonologist 2
Components: V, S, M, Drug
Casting Time: 1 action
Range: 30 ft.
Targets: All creatures within range
Duration: 1 round
Saving Throw: Fortitude negates
Spell Resistance: Yes

The caster emits a piercing screech like that of a
vrock demon. Every creature within the area is
stunned for 1 round.

Material Component: Feather of a large bird or
a vrock.

Drug Component: Mushroom powder.

Author: 	Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "spinc_common"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_STUNNING_SCREECH; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	
	

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	location lLoc = HkGetSpellTargetLocation();
	effect eStun = EffectStunned();
	int nCasterLvl = HkGetCasterLevel(oCaster);
	int nDC;
	effect eVis1 = EffectVisualEffect(VFX_FNF_SOUND_BURST);
	effect eVis2 = EffectVisualEffect(VFX_IMP_STUN);


	//check for drug
	if(GetHasSpellEffect(SPELL_MUSHROOM_POWDER, oCaster))
	{
		//Play VFX and sound
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oCaster);
		PlaySound("sff_combansh");

		//loop
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLoc);

		while (GetIsObjectValid(oTarget))
		{
			if(oTarget != oCaster)
			{
				nDC = HkGetSpellSaveDC(oCaster,oTarget);
				//SR
				if(!HkResistSpell(oCaster, oTarget))
				{
					//Save
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))

					{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
						HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, 6.0f);
					}
				}
			}

				oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lLoc);
		}
	}

	CSLSpellEvilShift(oCaster);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
