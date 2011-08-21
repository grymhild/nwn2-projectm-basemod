//::///////////////////////////////////////////////
//:: Infestation of Maggots
//:: X2_S0_InfestMag.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	You infest  a target with maggotlike creatures.
	They deal 1d4 points of temporary Constitution
	damage each round. Each round the subject makes
	a new Fortitude save. The spell ends if the
	target succeeds at its saving throw.

	If the targets constitution would drop to 0
	through this spell, and the player is playing
	on hardcore difficulty, the target is
	is killed instantly.

*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"





void RunInfestImpact(object oTarget, object oCaster, int iSaveDC, int iMetaMagic)
{
	SendMessageToPC(oTarget, "RunInfestImpact - Start");

	if (CSLGetDelayedSpellEffectsExpired(SPELL_INFESTATION_OF_MAGGOTS, oTarget, oCaster)) { return;}
	SendMessageToPC(oTarget, "RunInfestImpact - Unexpired");


	if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_DISEASE, oCaster))
	{
		SendMessageToPC(oTarget, "RunInfestImpact - Failed Save");
		if (GetIsImmune(oTarget, IMMUNITY_TYPE_DISEASE))
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_INFESTATION_OF_MAGGOTS );
			SendMessageToPC(oTarget, "RunInfestImpact - IsImmune Disease");
			return;
		}
		
		int iDamage = HkApplyMetamagicVariableMods(d4(), 4, iMetaMagic);
		
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY), oTarget);
		int nCon = GetAbilityScore(oTarget, ABILITY_CONSTITUTION);
		if ( iDamage>=nCon )
		{
			iDamage = nCon - 1; // NEVER GO BELOW 1 CON
		}
		if ( iDamage )
		{
			effect eDam = ExtraordinaryEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, iDamage));
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oTarget);
			if (nCon - iDamage > 1)
			{ // SOME CON LEFT TO EAT, RUN IT AGAIN
				DelayCommand(6.0, RunInfestImpact(oTarget, oCaster, iSaveDC, iMetaMagic));
				SendMessageToPC(oTarget, "RunInfestImpact - Calling Again, see you in 6");
				return;
			}
			else
			{
				SendMessageToPC(oTarget, "RunInfestImpact - Exit Recursion");
			}
		}
		else 
		{
			SendMessageToPC(oTarget, "RunInfestImpact - No Con Damage!!");
		}
	}
	else
	{
		SendMessageToPC(oTarget, "RunInfestImpact - Passed Save");
	}
	
	//GZRemoveSpellEffects(SPELL_INFESTATION_OF_MAGGOTS, oTarget);
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_INFESTATION_OF_MAGGOTS );
}

void main()
{
	//scSpellMetaData = SCMeta_SP_infestationm();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_INFESTATION_OF_MAGGOTS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_DISEASE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);

	if (GetHasSpellEffect(GetSpellId(), oTarget)) { // NEVER STACKS
		FloatingTextStrRefOnCreature(100775, oCaster, FALSE);
		return;
	}

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			SignalEvent( oTarget, EventSpellCastAt(oCaster, SPELL_INFESTATION_OF_MAGGOTS, TRUE ));
			float fDelay = GetDistanceToObject(oTarget)/25.0;
			if (!HkResistSpell(oCaster, oTarget, fDelay))
			{
				float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds(10 + HkGetSpellDuration( oCaster ) ) );
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_SPELL_MAGGOT_INFESTATION), oTarget, fDuration);
				DelayCommand(fDelay+0.1f, RunInfestImpact(oTarget, oCaster, HkGetSpellSaveDC(), HkGetMetaMagicFeat() ));
			}
		}
	}
	
	HkPostCast(oCaster);
}

