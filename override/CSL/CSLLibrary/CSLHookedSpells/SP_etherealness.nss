//::///////////////////////////////////////////////
//:: Etherealness
//:: x0_s0_ether.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Like sanctuary except almost always guaranteed
	to work.
	Lasts one turn per level.

	AFW-OEI 05/30/2006:
	Actually etherealness works exactly like
	sanctuary, but never fails.

	Also, it affects yourself and one ally / 3
	caster levels within 10'.  D&D rules say
	"touch" but that's a bit restrictive for NWN2.
*/
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


#include "_SCInclude_Invisibility"

void main()
{
	//scSpellMetaData = SCMeta_SP_etherealness();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_ETHEREALNESS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	

	
	if ( CSLGetPreferenceSwitch("EtherealCasterOnly",FALSE) )
	{
		CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oCaster,  SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS, SPELLABILITY_ELEMWAR_SANCTUARY  );
	
		float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(HkGetSpellDuration( oCaster ), SC_DURCATEGORY_ROUNDS) );
	
		// this is normal
		
		if ( CSLGetPreferenceSwitch("EtherealRemovedByInvisPurge",FALSE) && GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oCaster ))
		{
			// Cannot be cast when in a purge AOE
			SendMessageToPC( oCaster, "Invisibility Purge Prevents Going Etheral");
		}
		else if ( !CSLGetCanEthereal( oCaster ) )
		{
			SendMessageToPC( oCaster, "You are Dimensionally Anchored");
		}
		else if ( CSLGetPreferenceSwitch("ImprovedEthereal",FALSE) ) // they can ethereal
		{
			SCApplyImpEtheralness( oCaster, oCaster, fDuration, SPELL_ETHEREALNESS );
			SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_ETHEREALNESS, FALSE));	
		}
		else // they can ethereal
		{
			effect eLink = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );  // NWN2 VFX
			eLink = EffectLinkEffects(eLink, EffectEthereal() );
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
			SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_ETHEREALNESS, FALSE));	
		}
		
	}
	else
	{
		int    iSpellPower = HkGetSpellPower( oCaster, 30 );
		int    nMaxTargets = 1 + iSpellPower/3;
		//float  fDuration = TurnsToSeconds( HkGetSpellDuration( oCaster, 30 ) );
	 
		   //Enter Metamagic conditions
		float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds( HkGetSpellDuration( oCaster, 30 ) ) );
		
		int nTargets = 0;
		object oTarget = GetFirstFactionMember( oCaster, FALSE );
		while ( GetIsObjectValid(oTarget) && nTargets < nMaxTargets )
		{
			float fDist = GetDistanceBetween( oCaster, oTarget ); // returns 0.0 if they're in different areas
	 		
			if ( ( fDist > 0.0 && fDist < 3.3f ) ||	( oCaster == oTarget ) )	// Is the party member close enough to feel the effects? Or it's the caster himself
			{
				float fDelay = 0.25 * fDist;
				
				DelayCommand( fDelay, SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_ETHEREALNESS, FALSE) ) );
				//DelayCommand( fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget) );	// NWN1 VFX
				
				CSLRemoveEffectSpellIdGroup( SC_REMOVE_ALLCREATORS, oCaster, oTarget,  SPELL_ETHEREAL_JAUNT, SPELLABILITY_SPIRIT_JOURNEY, SPELL_ETHEREALNESS  );

				
				if ( CSLGetPreferenceSwitch("EtherealRemovedByInvisPurge",FALSE) && GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, oTarget ))
				{
					// Cannot be cast when in a purge AOE
					SendMessageToPC( oCaster, "Invisibility Purge Prevents Going Etheral");
				}
				else if ( !CSLGetCanEthereal( oTarget ) )
				{
					SendMessageToPC( oTarget, "You are Dimensionally Anchored");
				}
				else if ( CSLGetPreferenceSwitch("ImprovedEthereal",FALSE) ) // they can ethereal
				{
					SCApplyImpEtheralness( oTarget, oCaster, fDuration, SPELL_ETHEREALNESS );
					SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ETHEREALNESS, FALSE));	
				}
				else // they can ethereal
				{
					effect eLink = EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS );  // NWN2 VFX
					eLink = EffectLinkEffects(eLink, EffectEthereal() );
					HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, SPELL_ETHEREALNESS );
					SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ETHEREALNESS, FALSE));	
				}
				
	
				nTargets++;
			}
	
			oTarget = GetNextFactionMember( oCaster, FALSE );
		}
	}
	
	HkPostCast(oCaster);
}

