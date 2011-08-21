//::///////////////////////////////////////////////
//:: [Sound Burst]
//:: [NW_S0_SndBurst.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Does 1d8 damage to all creatures in a 10ft
//:: radius.  Fort save or the creature is stunned
//:: for 1 round.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Z, Oct. 2003

// (Updated JLR - OEI 07/05/05 NWN2 3.5)

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_SP_soundburst();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SOUND_BURST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget;
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	int iDamage;
	
	//SONIC
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	float fRadius = HkApplySizeMods(RADIUS_SIZE_MEDIUM);
	int iShapeEffect = HkGetShapeEffect( VFXSC_FNF_BURST_MEDIUM_SONIC, SC_SHAPE_AOEEXPLODE, oCaster, fRadius );
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eStun = EffectStunned();
	effect eVis = EffectVisualEffect( iHitEffect );
	//effect eFNF = EffectVisualEffect( VFX_HIT_SPELL_SONIC );
	effect eMind = EffectVisualEffect(VFX_DUR_STUN);
	//effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

	effect eLink = EffectLinkEffects(eStun, eMind);
	//eLink = EffectLinkEffects(eLink, eDur);

	effect eDam;
	location lLoc = HkGetSpellTargetLocation();
	int iDC = HkGetSpellSaveDC();
	//Apply the FNF to the spell location
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT,eFNF, lLoc);
	
	effect eImpactVis = EffectVisualEffect( iShapeEffect );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lLoc);
	
	//Get the first target in the spell area
	oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SOUND_BURST));
			//Make a SR check
			if(!HkResistSpell(oCaster, oTarget))
			{
				//Roll damage
				//iDamage = d8();
				//Make a Fort roll to avoid being stunned
				//if(!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC, iSaveType))
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, iSaveType))
				{
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(2));
				}
				//Make meta magic checks
				
				
				iDamage = HkApplyMetamagicVariableMods(d8(), 8);
				if (GetHasSpellEffect(FEAT_LYRIC_THAUM_SONIC_MIGHT,oCaster))
				{
					iDamage += d6(2);	
				}
				//Set the damage effect
				eDam = HkEffectDamage(iDamage, iDamageType);
				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,oTarget);
				DelayCommand(0.01, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam,oTarget));
			}
		}
		//Get the next target in the spell area
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc);
	}
	
	HkPostCast(oCaster);
}

