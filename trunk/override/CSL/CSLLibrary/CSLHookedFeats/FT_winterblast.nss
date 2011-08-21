//::///////////////////////////////////////////////
//:: Winter's Blast
//:: cmi_s2_winterblast
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: December 21, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "X0_I0_SPELLS"
//#include "x2_inc_spellhook" 
#include "_SCInclude_Class"
#include "_SCInclude_Reserve"

void main()
{	
	//scSpellMetaData = SCMeta_FT_winterblast();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	int nDamageDice = CSLGetHighestLevelByDescriptor( SCMETA_DESCRIPTOR_COLD, oCaster );
	if (nDamageDice == -1)
	{
		SendMessageToPC(oCaster,"You do not have any valid spells left that can trigger this ability.");
		return;
	}
		
	object oTarget;
	location lTargetLocation = HkGetSpellTargetLocation();
    float fDelay;
	float fMaxDelay = 0.0f;
	int iDamage;
		 
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 4.572, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	int iDC = GetReserveSpellSaveDC(nDamageDice,oCaster);
	while(GetIsObjectValid(oTarget))
	{
		if ( oTarget != oCaster && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
			//Get the distance between the target and caster to delay the application of effects
			fDelay = GetDistanceBetween(oCaster, oTarget)/20.0;
			if (fDelay > fMaxDelay)
			{
				fMaxDelay = fDelay;
			}

			//Detemine damage
			iDamage = SCGetReserveFeatDamage( nDamageDice, 4);

			//Adjust damage according to Reflex Save, Evasion or Improved Evasion
			iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, SAVING_THROW_TYPE_COLD);

			// Apply effects to the currently selected target.
			effect eCold = EffectDamage(iDamage, DAMAGE_TYPE_COLD);
			effect eVis = EffectVisualEffect(VFX_HIT_SPELL_ICE);
			if(iDamage > 0)
			{
				//Apply delayed effects
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
			}
		}
		//Select the next target within the spell shape.
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 4.572, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
	}
	fMaxDelay += 0.5f;
	effect eCone = EffectVisualEffect(VFX_DUR_CONE_ICE);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oCaster, fMaxDelay);
	
		

	HkPostCast(oCaster);
}