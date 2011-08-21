//::///////////////////////////////////////////////
//:: [Psionic Charm Monster]
//:: [x2_m1_CharmMon.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save DC 17 or the target is charmed for 4 rounds
//::   **UPDATE - Now doing confused effect instead of charmed**
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 5, 2002
//:://////////////////////////////////////////////
//::

#include "_HkSpell" 
void main()
{
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
		//Declare major variables
	int iDuration = 4;
	int iDC = 17;
	location lTargetLocation = HkGetSpellTargetLocation();
	object oTarget;
	effect eGaze = EffectConfused();
	effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
	effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
	effect eVisDur = EffectVisualEffect( VFX_DUR_SPELL_CONFUSION );

	effect eLink = EffectLinkEffects(eDur, eVisDur);

	//Get first target in spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	while(GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
		{
				if(oTarget != OBJECT_SELF)
				{

					//Determine effect delay
					float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 552));
					if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
					{
							eGaze = HkGetScaledEffect(eGaze, oTarget);
							eLink = EffectLinkEffects(eLink, eGaze);

							//Apply the VFX impact and effects
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) ));
					}
				}
			}
			//Get next target in spell area
			oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
	}
}