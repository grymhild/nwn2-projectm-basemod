//::///////////////////////////////////////////////
//:: Etherealness -> Ethereal Jaunt
//:: FT_wdminteleport.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Turns a creature ethereal
    Used by one of the undead shape forms for
    shifter/druids. lasts 5 rounds

	Changed to Ethereal Jaunt:
	Last for 1 round/caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003/08/01
//:://////////////////////////////////////////////
//:: AFW-OEI 05/30/2006:
//::	Changed to Ethereal Jaunt

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Invisibility"
//#include "x2_inc_spellhook"

void main()
{
	//scSpellMetaData = SCMeta_FT_elemwar_sanc();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_ELEMWAR_SANCTUARY;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_TELEPORTATION, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	if ( CSLGetPreferenceSwitch("EnableTeleport",FALSE) )
	{
		int iCasterLevel = HkGetCasterLevel(oCaster);
		location lTeleportTo = HkGetSpellTargetLocation();
		location lTeleportFrom = GetLocation(oCaster);
		
		//--------------------------------------------------------------------------
		// Effects
		//--------------------------------------------------------------------------
		effect eVis     = EffectVisualEffect(VFXSC_FNF_BURST_SMALL_SMOKEPUFF);
		effect eVis1    = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
		
		if ( CSLGetCanTeleport( oCaster ) )
		{
			lTeleportTo = CSLTeleportationBeam( lTeleportFrom, lTeleportTo, TRUE, TRUE, oCaster ); // this makes sure any triggers are triggered between here and there
			
			if ( lTeleportFrom != lTeleportTo )
			{
				SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_DIMENSION_DOOR, FALSE));
				HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis1, lTeleportTo);
				AssignCommand(oCaster,ClearAllActions());
				AssignCommand(oCaster,ClearAllActions(TRUE));
				
				//effect eImpactVis = EffectVisualEffect( iImpactSEF );
				//DelayCommand( 1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTeleportTo) );
			
				// CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oCaster, SPELL_BLACKFLAME );
				AssignCommand(oCaster, ClearAllActions() );
				DelayCommand( 1.5f,  CSLTeleportToLocation( oCaster, lTeleportTo, VFX_HIT_SPELL_CONJURATION ) );
				DelayCommand(1.5f,HkApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(460),oCaster));
				DelayCommand(1.5f,CSLPlayCustomAnimation_Void(oCaster, "*whirlwind", 0) );
				//AssignCommand(oCaster, ClearAllActions() );
				//DelayCommand(1.5f,AssignCommand(oCaster,JumpToLocation(lTeleportTo)));
				//DelayCommand(1.6f,HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTeleportFrom));
			}
		}
		else
		{
			SendMessageToPC( oCaster, "You are Dimensionally Anchored");
		}
	
	}
	else
	{
		// prevent ethereal effects from stacking
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oCaster,  SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY  );
	
		float fDuration = 10.0f;
		effect eLink;
		// this is normal
		
		SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));
	
		if ( CSLGetPreferenceSwitch("ImprovedEthereal",FALSE) )
		{
			SCApplyImpEtheralness( oCaster, oCaster, fDuration, SPELLABILITY_SPIRIT_JOURNEY, VFX_DUR_SPELL_ETHEREALNESS );
		}
		else
		{
			if ( CSLGetPreferenceSwitch("EtherealRemovedByInvisPurge",FALSE) && GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oCaster ))
			{
				// Cannot be cast when in a purge AOE
				SendMessageToPC( oCaster, "Invisibility Purge Prevents Going Etheral");
				return;
			}
			eLink = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );  // NWN2 VFX
			eLink = EffectLinkEffects(eLink, EffectEthereal() );
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);	
		}
	}
	
	HkPostCast(oCaster);

}