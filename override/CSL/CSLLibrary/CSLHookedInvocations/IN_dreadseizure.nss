//::///////////////////////////////////////////////
//:: Dread Seizure
//:: nx_s0_dreadseizure.nss
//:: Copyright (c) 2007 Obsidian Entertainment
//:://////////////////////////////////////////////
/*
	Dread Seizure
	Lesser, 4th
	
	You speak a word that sends wracking pain through
	the limbs of a single target creature within
	60ft.  Though these seizures are not powerful
	enough to immobilize the creature, they do
	reduce its movement speed by 30%.  The target
	also takes a -3 penalty to all attacks it makes.
	These effects last for 3 rounds; a successful
	Fortitude save negates the effects.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"





void main()
{
	//scSpellMetaData = SCMeta_IN_dreadseizure();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFXSC_HIT_DREADSEIZURE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	object oTarget =  HkGetSpellTarget();
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			int iSaveDC = GetInvocationSaveDC(oCaster); //GetSpellSaveDC();
			if (!HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC))
			{
				int iBonus = HkGetWarlockBonus(oCaster);
				float fDuration = HkApplyMetamagicDurationMods(RoundsToSeconds(3 + iBonus / 3));
				effect eLink = EffectVisualEffect(VFX_DUR_BIGBYS_INTERPOSING_HAND);
				eLink = EffectLinkEffects(eLink, EffectAttackDecrease(3 + iBonus / 3));
				eLink = EffectLinkEffects(eLink, EffectMovementSpeedDecrease(30 + iBonus));
				SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
				HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );
			}
		}
	}
	
	HkPostCast(oCaster);
}

