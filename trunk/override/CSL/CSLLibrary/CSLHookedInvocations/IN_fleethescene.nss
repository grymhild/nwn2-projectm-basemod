//:://///////////////////////////////////////////////
//:: Warlock Lesser Invocation: Flee the Scene
//:: nw_s0_ifleescen.nss
//:: Copyright (c) 2005 Obsidian Entertainment Inc.
//::////////////////////////////////////////////////
//:: Created By: Brock Heinz
//:: Created On: 08/12/05
//::////////////////////////////////////////////////
/*
			5.7.2.7   Flee the Scene
			Complete Arcane, pg. 134
			Spell Level: 4
			Class:       Misc

			The warlock gets the benefits of the expeditious retreat spell
			(1st level wizard) for 1 hour. They also get the benefits of the haste
			spell (3rd level wizard) for 5 rounds.

			[Rules Note] In the rules this equivalent to the dimension door spell,
			which doesn't exist in NWN2. Instead it is replaced by Expeditious
			Retreat and a brief bout of the haste spell. The Haste effect would
			be incredibly powerful in pen-and-paper, but eventually boots of speed
			and the like will mean the player perpetually has that beneficial
			effect, so the warlock gets consistent access to it a little bit earlier.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"
#include "_SCInclude_Transmutation"





const int SC_MAXPORTS = 2;

void SCPortingStack(object oCaster, int nInc = 1, int nStackLimit = 3)
{
	int nStack = CSLGetMax(0, GetLocalInt(oCaster, "SC_PORTSTACK") + nInc);
	SetLocalInt(oCaster, "SC_PORTSTACK", nStack);
	string sMsg = "<color=cyan>Teleport Stack:</color><color=green> Clear</color>";
	int nStackLimit = SC_MAXPORTS;
	if (nStack < nStackLimit && GetLocalInt(oCaster, "SC_PORTBLOCKED") )
	{
		FloatingTextStringOnCreature("<color=cyan>You can teleport again</color>", oCaster, FALSE);
		SetLocalInt(oCaster, "SC_PORTBLOCKED", FALSE);
	//if (nStack) {
	//	sMsg="<color=cyan>AOE Stack:</color> ";
	//	if (nInc==1) sMsg += "<color=red>"; // GOING UP
	//	else sMsg +="<color=yellow>"; // COOLING DOWN
	//	sMsg += IntToString(nStack) + " of " + IntToString(nStackLimit) + "</color>";
	}
	//FloatingTextStringOnCreature(sMsg, oCaster, FALSE);
}


void main()
{
	//scSpellMetaData = SCMeta_IN_fleethescene();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_I_FLEE_THE_SCENE;
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_TELEPORTATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	if ( CSLGetPreferenceSwitch("PNPFleeTheScene",FALSE) )
	{

		if ( CSLGetCanTeleport( oCaster ) )
		{
			int iSpellPower = HkGetSpellPower(oCaster, 30, CLASS_TYPE_WARLOCK );
			location lTargetLoc = HkGetSpellTargetLocation();
			location lCasterLoc = GetLocation(oCaster);
			float fDuration = RoundsToSeconds( HkGetSpellDuration(oCaster, 30, CLASS_TYPE_WARLOCK ) );
			
			// Implement the nerfing script to prevent abuse
			int nStack = GetLocalInt(oCaster, "SC_PORTSTACK");
			int nStackLimit = SC_MAXPORTS;
			
			if (GetHasFeat(FEAT_DARK_TRANSIENT, oCaster))
			{
				nStackLimit += 2; // 2 extra ports
				fDuration = fDuration * 2; 
			}
			if (nStack >= nStackLimit)
			{
				//SetModuleOverrideSpellScriptFinished();
				SendMessageToPC(oCaster, "You have teleported too many times and must wait to port again");
				SetLocalInt(oCaster, "SC_PORTBLOCKED", TRUE);
				return;
			}
			else if ( GetIsInCombat(oCaster) )
			{
				int nStackBlockDuration = nStack + 12 - ( iSpellPower / 5 ); //( which is current stack + 10 - 6 or current stack +6 at level 30, and +10 at level 10; 
				SCPortingStack(oCaster, 1, nStackLimit);
				AssignCommand(oCaster, DelayCommand(RoundsToSeconds(nStackBlockDuration), SCPortingStack(oCaster, -1, nStackLimit)));
			}
			
			
			// 2
			effect eEthereal = EffectLinkEffects(EffectEthereal(), EffectVisualEffect( VFX_DUR_SPELL_ETHEREALNESS ));
			effect eSpeedUp = EffectLinkEffects(EffectMovementSpeedIncrease(50), EffectVisualEffect( VFX_DUR_SPELL_EXPEDITIOUS_RETREAT ));
			effect eImmobile = EffectCutsceneParalyze();
			eImmobile = ExtraordinaryEffect(eImmobile);
			
			// 5
			CSLRemoveEffectSpellIdSingle(SC_REMOVE_FIRSTALLCREATORS, oCaster, oCaster, iSpellId );//
			//RemoveEffectsFromSpell(oCaster, 1643);
			
			SignalEvent( oCaster, EventSpellCastAt(OBJECT_SELF, SPELL_I_FLEE_THE_SCENE, FALSE) );
		
			HkApplyEffectAtLocation (DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_AOE_SONIC), lCasterLoc);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEthereal, oCaster, 6.0f);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeedUp, oCaster, fDuration);
		
			AssignCommand(oCaster, ActionJumpToLocation(lTargetLoc));
			
			if ( GetIsInCombat(oCaster) || CSLGetIsEnemyClose(oCaster, 30.0f ) )
			{
				string sTag = "Decoy_"+ObjectToString(oCaster);
				CopyObject(oCaster, lCasterLoc, OBJECT_INVALID, sTag);
				object oDecoy = GetObjectByTag(sTag);
				
				SetEventHandler( oDecoy, CREATURE_SCRIPT_ON_DAMAGED, "" );
				
				ChangeToStandardFaction(oDecoy, STANDARD_FACTION_DEFENDER);
				AssignCommand(oDecoy, ActionWait(6.1f));
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eImmobile, oDecoy);
		
				SetImmortal(oDecoy, TRUE);		
				AssignCommand(oDecoy, SetIsDestroyable(TRUE, FALSE, FALSE));
				DelayCommand(6.0f, DestroyObject(oDecoy));
			}
			
			ClearAllActions(TRUE);
		}
		else
		{
			SendMessageToPC( oCaster, "You are Dimensionally Anchored");
		}
	}
	else
	{
		int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
		int iDuration = HkGetSpellDuration( oCaster, 30, CLASS_TYPE_WARLOCK );
		float fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);
		//int iBonus = HkGetWarlockBonus(oCaster);
		//int iDuration = 5 * iBonus;
		int nHasDarkTransient = FALSE;
		if (GetHasFeat(FEAT_DARK_TRANSIENT, oCaster))
		{
			nHasDarkTransient = TRUE;
			iDuration = iDuration * 2;
		}
		//SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_I_FLEE_THE_SCENE, FALSE));
		//effect eLink = EffectVisualEffect(VFX_DUR_SPELL_HASTE);
		//eLink = EffectLinkEffects(eLink, EffectHaste());
		//Apply haste to party members
		location lTarget = GetLocation(oCaster);
		object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		while (GetIsObjectValid(oTarget))
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster))
			{
				
				
				if ( nHasDarkTransient && oCaster == oTarget )
				{
					HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(1), oCaster, 6.0f);
				}
				DelayCommand(0.0f,SCApplyHasteEffect( oTarget, oCaster, SPELL_I_FLEE_THE_SCENE, fDuration, DURATION_TYPE_TEMPORARY ) );
				//CSLUnstackSpellEffects(oTarget, GetSpellId());
				//CSLUnstackSpellEffects(oTarget, SPELL_HASTE, "Haste");
				//CSLUnstackSpellEffects(oTarget, SPELL_EXPEDITIOUS_RETREAT, "Expeditious Retreat");
				//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
			}
			oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
	
	}
	HkPostCast(oCaster);	
}

