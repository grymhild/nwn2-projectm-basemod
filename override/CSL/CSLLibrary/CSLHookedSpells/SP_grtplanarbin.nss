//::///////////////////////////////////////////////
//:: Greater Planar Binding
//:: NW_S0_GrPlanar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons an outsider dependant on alignment, or
	holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: AFW-OEI 06/02/2006:
//:: Update creature blueprints
//:: Change summon duration from rounds to minutes.

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_SP_grtplanarbin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_PLANAR_BINDING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	object oTarget = HkGetSpellTarget();
	int iDescriptor = SCMETA_DESCRIPTOR_NONE;
	if ( !GetIsObjectValid(oTarget))
	{
		int nAlign = GetAlignmentGoodEvil(OBJECT_SELF);
		float fDelay = 3.0;
		switch (nAlign)
		{
			case ALIGNMENT_EVIL:
				iDescriptor = SCMETA_DESCRIPTOR_EVIL;
				break;
			case ALIGNMENT_GOOD:
				iDescriptor = SCMETA_DESCRIPTOR_GOOD;
				break;
			case ALIGNMENT_NEUTRAL:
				iDescriptor = SCMETA_DESCRIPTOR_FIRE;
				int iRoll = d4();
				switch (iRoll)
				{
					case 1: iDescriptor = SCMETA_DESCRIPTOR_FIRE; break;
					case 2: iDescriptor = SCMETA_DESCRIPTOR_EARTH; break;
					case 3: iDescriptor = SCMETA_DESCRIPTOR_WATER; break;
					case 4: iDescriptor = SCMETA_DESCRIPTOR_AIR; break;
				}
				break;
		}
	}
	int iImpactSEF = VFX_HIT_SPELL_SUMMON_CREATURE;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_INTERNAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CALLING, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//Declare major variables
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = HkGetSpellDuration(OBJECT_SELF); // OldGetCasterLevel(OBJECT_SELF);
	int iSaveDC = HkGetSpellSaveDC()+5;
	effect eSummon;
	//effect eGate;
	effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
	//effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
	//effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

	effect eLink = EffectLinkEffects(eDur, EffectParalyze(iSaveDC, SAVING_THROW_WILL));
	//eLink = EffectLinkEffects(eLink, eDur2);
	//eLink = EffectLinkEffects(eLink, eDur3);
	
	
	int nRacial = GetRacialType(oTarget);
	
	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);


	//Check to see if a valid target has been chosen
	if (GetIsObjectValid(oTarget))
	{
		float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS)/2.0f );
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
		
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
			//Fire cast spell at event for the specified target
			SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GREATER_PLANAR_BINDING));
			//Check for racial type
			if(nRacial == RACIAL_TYPE_OUTSIDER)
			{
				//Allow will save to negate hold effect
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC))
				{
						//Apply the hold effect
					HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration );
				}
			}
		}
	}
	else
	{
		if (GetHasFeat(FEAT_ASHBOUND, OBJECT_SELF))
		{
			iDuration = iDuration * 2;	
		}
		
		float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS)/2.0f );
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
		//If the ground was clicked on summon an outsider based on alignment
		string sSummon = "csl_sum_elem_fire_16huge";
		int nElemental = 1;
		int iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
		float fDelay = 1.0f;
		if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )
		{
			sSummon = "csl_sum_baat_erinyes1";
			nElemental = 0;
			iVFXEffect = VFX_FNF_SUMMON_GATE;
			fDelay = 3.0f;		
		}
		else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )
		{
			sSummon = "csl_sum_celest_beardire";
			nElemental = 0;
			iVFXEffect = VFX_FNF_SUMMON_CELESTIAL;
			fDelay = 3.0f;		
		}
		else if ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )
		{
			sSummon = "csl_sum_elem_fire_16huge";
			nElemental = 1;
			iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
		}
		else if ( iDescriptor & SCMETA_DESCRIPTOR_EARTH )
		{
			sSummon = "csl_sum_elem_eart_16huge";
			nElemental = 1;
			iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
		}
		else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )
		{
			sSummon = "csl_sum_elem_wat_16huge";
			nElemental = 1;
			iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
		}
		else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )
		{
			sSummon = "csl_sum_elem_air_16huge";
			nElemental = 1;
			iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
		}
		else
		{
			return;
		}
		eSummon = EffectSummonCreature(sSummon, iVFXEffect, fDelay);

		
	
	
		//Apply the VFX impact and summon effect
		HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, HkGetSpellTargetLocation(), RoundsToSeconds(iDuration*10)); // AFW-OEI 06/02/2006: Minutes
		DelayCommand(fDelay+1.5f, BuffSummons(OBJECT_SELF, nElemental, 1));
		//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	}
	
	HkPostCast(oCaster);
}

