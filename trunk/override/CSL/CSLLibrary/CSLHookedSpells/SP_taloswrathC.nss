//::///////////////////////////////////////////////
//:: Talo's Wrath (H) - Heartbeat
//:: SG_S0_TalWrathH.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	**** This script goes in the heartbeat of the
	SpellHelper object created in the main script ****

	This spell creates a column of raging electrical
	energy at a target specified by the caster for a
	duration of 1 round for every 6 levels of the caster.
	Targets caught within the area of effect suffer
	1d6 pts of damage (up to 15d6 max)

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////
//:: Edited On: October 3, 2003
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_elements"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"
//#include "x0_i0_position"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if ( CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = SPELL_TALOS_WRATH;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//object oTarget = HkGetAOEOwner(OBJECT_SELF);
	///int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget; 		//= HkGetSpellTarget();
	location lTarget 		= GetLocalLocation(OBJECT_SELF, "MY_LOC");
	//int 	iDC; //= HkGetSpellSaveDC(oCaster, oTarget);
	int iMetamagic 	= HkGetMetaMagicFeat();
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	//float 	fDuration 		= HkGetSpellDuration(iCasterLevel/6);
	//---
	//int iDuration = HkGetSpellDuration( oCaster, 30 );
	//float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	//int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//---

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( DAMAGE_TYPE_ELECTRICAL );
	//int iShapeEffect = HkGetShapeEffect( VFX_NONE, SC_SHAPE_NONE );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_LIGHTNING );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_ELECTRICAL );
		

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 6;
	//int 	iNumDice 		= iCasterLevel;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	//location lRgtLocation 	= GetLocalLocation(OBJECT_SELF, "MY_RGT_LOC");
	//location lLftLocation 	= GetLocalLocation(OBJECT_SELF, "MY_LFT_LOC");
	//location lFrtLocation 	= GetLocalLocation(OBJECT_SELF, "MY_FRT_LOC");
	//location lBckLocation 	= GetLocalLocation(OBJECT_SELF, "MY_BCK_LOC");

	float 	fDelay;


	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eImp = EffectVisualEffect( iHitEffect );
	//effect eImp2= EffectVisualEffect(VFX_IMP_DOOM);
	//effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
	effect eDam;
	effect eLink;
	//int iLightningEffect;

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
	
	//int iShapeEffect = CSLPickOneInt(VFXSC_FX_LIGHTNINGSTRIKE1, VFXSC_FX_LIGHTNINGSTRIKE2, VFXSC_FX_LIGHTNINGSTRIKE3, VFXSC_FX_LIGHTNINGSTRIKE4, VFXSC_FX_LIGHTNINGSTRIKE5, VFXSC_FX_LIGHTNINGSTRIKE6 );

	
	oTarget = GetFirstInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
	while (GetIsObjectValid(oTarget))
	{
		if(CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iSpellId));
			fDelay = CSLRandomBetweenFloat(0.4, 1.75);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{
				iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iSpellPower), iDieType * iSpellPower)+iBonus;
				iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, HkGetSpellSaveDC(oCaster, oTarget), iSaveType);
				if(iDamage > 0)
				{
					eDam = EffectLinkEffects(eImp, EffectDamage(iDamage, iDamageType) );
					//iLightningEffect = ;
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
					DelayCommand( fDelay-0.35f, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( CSLPickOneInt(VFXSC_FX_LIGHTNINGSTRIKE1, VFXSC_FX_LIGHTNINGSTRIKE2, VFXSC_FX_LIGHTNINGSTRIKE3, VFXSC_FX_LIGHTNINGSTRIKE4, VFXSC_FX_LIGHTNINGSTRIKE5, VFXSC_FX_LIGHTNINGSTRIKE6 ) ), GetLocation(oTarget) ) );
					
					 
				}
				//DelayCommand(fDelay+0.1, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp, lRgtLocation));
				//DelayCommand(fDelay+1.7, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp, lLftLocation));
				//DelayCommand(fDelay+3.25, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp, lFrtLocation));
				//DelayCommand(fDelay+5.37, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImp, lBckLocation));
			}
		}
		oTarget = GetNextInPersistentObject(OBJECT_SELF, OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
	}

}