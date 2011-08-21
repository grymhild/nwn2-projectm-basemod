//::///////////////////////////////////////////////
//:: Haste
//:: NW_S0_Haste.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the targeted creature one extra partial
	action per round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"
#include "_SCInclude_Transmutation"




#include "_SCInclude_Group"


void main()
{	
	//scSpellMetaData = SCMeta_SP_haste();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HASTE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	
	location lTarget = HkGetSpellTargetLocation();
	
	
	float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds( HkGetSpellDuration( oCaster ) ));
	if ( CSLStringStartsWith(GetTag(oCaster),"BABA_") || GetTag(GetSpellCastItem())=="quickstone") fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS);
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nNumTargets = iSpellPower;
	
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget) && (nNumTargets > 0))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
		{
			
			// DelayCommand( 0.1f, 
			
			SCApplyHasteEffect( oTarget, oCaster, SPELL_HASTE, fDuration, iDurType ); // );
			/*
			CSLUnstackSpellEffects(oTarget, SPELL_HASTE);
			CSLUnstackSpellEffects(oTarget, 647, "Blinding Speed");
			CSLUnstackSpellEffects(oTarget, SPELL_MASS_HASTE, "Mass Haste");
			CSLUnstackSpellEffects(oTarget, SPELL_EXPEDITIOUS_RETREAT, "Expeditious Retreat");
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_HASTE, FALSE));
			
			if ( (oTarget == OBJECT_SELF) && ( nSwiftblade > 0 ) )
			{
				float fSwiftbladeDuration = fDuration;
				fSwiftbladeDuration = GetSwiftbladeHasteDuration(nSwiftblade, fSwiftbladeDuration);
				//effect eSwiftbladeLink = eLink;
				eLink = GetSwiftbladeHasteEffect(nSwiftblade, eLink);
				HkApplyEffectToObject(iDurType, eLink, oTarget, fSwiftbladeDuration);
			
			}
			else
			{
				HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
			}
				
			if (GetHasSpellEffect(BLADESINGER_SONG_FURY, oTarget))
			{
				effect eAtks = EffectModifyAttacks(2);
				eAtks = SetEffectSpellId(eAtks, -BLADESINGER_SONG_FURY);
				if ( (oTarget == OBJECT_SELF) && (nSwiftblade > 0) )
				{
					HkApplyEffectToObject(iDurType, eAtks, oTarget, GetSwiftbladeHasteDuration(nSwiftblade, fDuration));
				}
				else
				{
					HkApplyEffectToObject(iDurType, eAtks, oTarget, fDuration);
				}
			}
			*/

			// HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration);
			nNumTargets--;
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		
	}
	
	HkPostCast(oCaster);
}

