//::///////////////////////////////////////////////
//:: Color Spray
//:: NW_S0_ColSpray.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A cone of sparkling lights flashes out in a cone
	from the casters hands affecting all those within
	the Area of Effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_colorspray();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_COLOR_SPRAY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_PATTERN, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	
	
	float fMaxDelay = 0.0f; // Used to determine length of spell cone
	
	object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, HkGetSpellTargetLocation(), TRUE);
	while (GetIsObjectValid(oTarget))
	{
		if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) )
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_COLOR_SPRAY));
			float fDelay = GetDistanceBetween(oCaster, oTarget) / 30;
			fMaxDelay = CSLGetMaxf(fMaxDelay, fDelay);
			if ( oTarget!=oCaster && !HkResistSpell(oCaster, oTarget, fDelay))
			{
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, oCaster, fDelay))
				{
					
					int iDuration = HkApplyMetamagicVariableMods(d4(), 4)+3;
					float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
					int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
					
					DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_ILLUSION), oTarget));
					int iHD = GetHitDice(oTarget);
					if ( iHD <=2 )
					{
						DelayCommand(fDelay, HkApplyEffectToObject(iDurType, EffectSleep(), oTarget, fDuration));
					}
					else if ( iHD < 5 )
					{
						if ( !GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) )
						{
							DelayCommand(fDelay, HkApplyEffectToObject(iDurType, EffectBlindness(), oTarget, CSLGetMaxf( 6.0f, fDuration-6.0f) ) );
						}
						else
						{
							DelayCommand(fDelay, HkApplyEffectToObject(iDurType, EffectStunned(), oTarget, CSLGetMaxf( 6.0f, fDuration-12.0f) ) );
						}
					}
				}
			}
		}
		//Get next target in spell area
		oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, HkGetSpellTargetLocation(), TRUE);
	}
	fMaxDelay += 0.5f;
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CONE_COLORSPRAY), oCaster, fMaxDelay);
	
	HkPostCast(oCaster);
}

