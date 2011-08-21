//::///////////////////////////////////////////////
//:: Hellball
//:: X2_S2_HELLBALL
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
//:: Created By: Andrew Noobs, Georg Zoeller
//:: Created On: 2003-08-20
//:://////////////////////////////////////////////
/*
	Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/
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
	int iSpellId = SPELL_EPIC_HELBALL;
	int iClass = CLASS_TYPE_BESTCASTER;
	int iSpellLevel = 10;
	//int iImpactSEF = VFXSC_HIT_AOE_HELLBALL;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	
	if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_HELBALL))
	{
		
		int nDamage1, nDamage2, nDamage3, nDamage4;
		float fDelay;
		effect eExplode = EffectVisualEffect(464);
		effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
		effect eVis2 = EffectVisualEffect(VFX_IMP_ACID_L);
		effect eVis3 = EffectVisualEffect(VFX_IMP_SONIC);


		// if this option has been enabled, the caster will take damage for casting
		// epic spells, as descripbed in the ELHB
		if ( CSLGetPreferenceSwitch("EpicBacklashDamage") )
		{
			effect eCast = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
			int nDamage5 = d6(10);
			effect eDam5 = HkEffectDamage(nDamage5, DAMAGE_TYPE_NEGATIVE);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCast, OBJECT_SELF);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam5, OBJECT_SELF);
		}



		effect eDam1, eDam2, eDam3, eDam4, eDam5, eKnock;
		eKnock= EffectKnockdown();

		location lTarget = HkGetSpellTargetLocation();

		HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

		int nTotalDamage;
		while (GetIsObjectValid(oTarget))
		{
			if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
			{

			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, HkGetSpellId()));

			fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20 + 0.5f;
			//Roll damage for each target
				nDamage1 = d6(10);
				nDamage2 = d6(10);
				nDamage3 = d6(10);
				nDamage4 = d6(10);

				// no we don't care about evasion. there is no evasion to hellball
				if (HkSavingThrow(SAVING_THROW_REFLEX,oTarget,HkGetSpellSaveDC(OBJECT_SELF, oTarget),SAVING_THROW_TYPE_SPELL,OBJECT_SELF,fDelay) >0)
				{
				nDamage1 /=2;
				nDamage2 /=2;
				nDamage3 /=2;
				nDamage4 /=2;
				}
				nTotalDamage = nDamage1+nDamage2+nDamage3+nDamage4;
				//Set the damage effect
				eDam1 = HkEffectDamage(nDamage1, DAMAGE_TYPE_ACID);
				eDam2 = HkEffectDamage(nDamage2, DAMAGE_TYPE_ELECTRICAL);
				eDam3 = HkEffectDamage(nDamage3, DAMAGE_TYPE_FIRE);
				eDam4 = HkEffectDamage(nDamage4, DAMAGE_TYPE_SONIC);

				if(nTotalDamage > 0)
				{
				if (nTotalDamage > 50)
				{
					DelayCommand(fDelay+0.3f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnock, oTarget, 3.0f ));
				}

				// Apply effects to the currently selected target.
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam1, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam3, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam4, oTarget));
				//This visual effect is applied to the target object not the location as above. This visual effect
				//represents the flame that erupts on the target not on the ground.
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay+0.2f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
				DelayCommand(fDelay+0.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
				}
			}
			//Select the next target within the spell shape.
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0f, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		}
	}
	HkPostCast(oCaster);
}

