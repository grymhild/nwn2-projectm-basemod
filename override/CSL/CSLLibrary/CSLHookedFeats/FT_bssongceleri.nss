//::///////////////////////////////////////////////
//:: Song of Celerity
//:: cmi_s2_sngcelrty
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Jan 19, 2008
//:: Based on nw_s0_haste
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Transmutation"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_bssongceleri();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = BLADESINGER_SONG_CELERITY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	
    //Declare major variables
    object oTarget = HkGetSpellTarget();
    //Get the spell target location as opposed to the spell target.
    location lTarget = HkGetSpellTargetLocation();
    // Create the Effects
    //effect eHaste = EffectHaste();
    //effect eDur = EffectVisualEffect( VFX_DUR_SPELL_HASTE );
    //effect eLink = EffectLinkEffects(eHaste, eDur);
	//eLink = SetEffectSpellId(eLink,iSpellId);
	//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, SPELL_EXPEDITIOUS_RETREAT );
	//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, 647 );
    

	//Favored Soul?
	//Warpriest?

    int iCasterLevel = GetLevelByClass(CLASS_BLADESINGER) * 3;
	float fDuration = RoundsToSeconds( iCasterLevel );
	float fDelay;
	
	object oTarget2 = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget2))
	{
    	if (CSLSpellsIsTarget( oTarget2, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF ))
    	{
				fDelay = CSLRandomBetweenFloat(0.1, 1.0);
        		//SignalEvent( oTarget2, EventSpellCastAt( OBJECT_SELF, SPELL_HASTE, FALSE ));
				DelayCommand(fDelay, SCApplyHasteEffect( oTarget2, oCaster, BLADESINGER_SONG_CELERITY, fDuration, DURATION_TYPE_TEMPORARY ) );
				
				//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget2, fDuration));
				
    	}        	
     	//Get the next target in the specified area around the caster
		oTarget2 = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		
	}
	
	HkPostCast(oCaster);
}