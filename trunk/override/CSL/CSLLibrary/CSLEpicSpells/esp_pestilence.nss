//::///////////////////////////////////////////////
//:: Epic Spell: Pestilence
//:: Author: Boneshank (Don Armstrong)
//#include "prc_alterations"
//#include "inc_epicspells"

#include "_HkSpell"
#include "_SCInclude_Epic"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_EPIC_PESTIL;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_PESTIL))
	{
		
		int nDamage;

		float fDelay;
		effect eExplode = EffectVisualEffect(VFX_FNF_HORRID_WILTING);
		effect eDuration = EffectVisualEffect(VFX_DUR_AURA_DISEASE);
		effect eVis = EffectVisualEffect(VFX_IMP_DISEASE_S);
		effect eDisease = SupernaturalEffect(EffectDisease(DISEASE_SLIMY_DOOM));
		location lTarget = GetLocation(OBJECT_SELF);
		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDuration, lTarget, 10.0);
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
		//Cycle through the targets within the spell shape until an invalid object is captured.
		while (GetIsObjectValid(oTarget))
		{
			if (oTarget != OBJECT_SELF)
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HORRID_WILTING));
				//Get the distance between the explosion and the target to calculate delay
				fDelay = CSLRandomBetweenFloat(1.5, 2.5);
				if(!HkResistSpell(OBJECT_SELF, oTarget, fDelay))
				{
				if( !CSLGetIsConstruct(oTarget) && !CSLGetIsUndead(oTarget) )
				{

					// Targets all get a Fortitude saving throw
					if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC(OBJECT_SELF, oTarget), SAVING_THROW_TYPE_DISEASE, OBJECT_SELF, fDelay))
					{
						// Apply effects to the currently selected target.
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDisease, oTarget));
						DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
					}
				}
				}
			}
			//Select the next target within the spell shape.
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lTarget);
		}
	}
	HkPostCast(oCaster);
}
