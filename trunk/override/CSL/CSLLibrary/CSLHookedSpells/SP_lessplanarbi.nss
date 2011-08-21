//::///////////////////////////////////////////////
//:: Lesser Planar Binding
//:: NW_S0_LsPlanar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Level 5 wizard 
	
	Summons an outsider dependant on alignment, or
	holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Class"


void main()
{
	//scSpellMetaData = SCMeta_SP_lessplanarbi();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LESSER_PLANAR_BINDING;
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
				
				/*
				int iRoll = d4();
				switch (iRoll)
				{
					case 1: iDescriptor = SCMETA_DESCRIPTOR_FIRE; break;
					case 2: iDescriptor = SCMETA_DESCRIPTOR_EARTH; break;
					case 3: iDescriptor = SCMETA_DESCRIPTOR_WATER; break;
					case 4: iDescriptor = SCMETA_DESCRIPTOR_AIR; break;
				}
				*/
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
	int iSaveDC = HkGetSpellSaveDC();
	effect eSummon;
	//effect eGate;
	effect eDur = EffectVisualEffect( VFX_DUR_PARALYZED );
	//effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
	//effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
	effect eLink = EffectLinkEffects(eDur, EffectParalyze(iSaveDC, SAVING_THROW_WILL));
	//eLink = EffectLinkEffects(eLink, eDur2);
	//eLink = EffectLinkEffects(eLink, eDur3);

	//object oTarget = HkGetSpellTarget();
	int nRacial = GetRacialType(oTarget);	
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	//Check to see if the target is valid
	if (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_PLANAR_BINDING, TRUE ));
				//Check to make sure the target is an outsider
				if(nRacial == RACIAL_TYPE_OUTSIDER)
				{
					//Make a will save
					if(!WillSave(oTarget, iSaveDC))
					{
							//Apply the linked effect
							float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) /2.0f );
							int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
					}
				}
			}
	}
	else
	{
			//If the ground was clicked on summon an outsider based on alignment
			string sSummon = "csl_sum_elem_fire_16huge";
			int nElemental = 1;
			int iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
			float fDelay = 1.0f;
			if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )
			{
				sSummon = "csl_sum_baat_imp";
				nElemental = 0;
				iVFXEffect = VFX_FNF_SUMMON_GATE;
			}
			else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )
			{
				sSummon = "csl_sum_celest_wolf";
				nElemental = 0;
				iVFXEffect = VFX_FNF_SUMMON_CELESTIAL;
			}
			else if ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )
			{
				sSummon = "csl_sum_elem_fire_mephit";
				nElemental = 1;
				iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
			}
			else if ( iDescriptor & SCMETA_DESCRIPTOR_EARTH )
			{
				sSummon = "csl_sum_elem_eart_mephit";
				nElemental = 1;
				iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
			}
			else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )
			{
				sSummon = "csl_sum_elem_water_mephit";
				nElemental = 1;
				iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
			}
			else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )
			{
				sSummon = "csl_sum_elem_air_mephit";
				nElemental = 1;
				iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
			}
			else
			{
				return;
			}
			if (GetHasFeat(FEAT_ASHBOUND, OBJECT_SELF))
			{
				iDuration = iDuration * 2;
			}
			eSummon = EffectSummonCreature(sSummon, iVFXEffect, fDelay);
			
			//Apply the summon effect and the VFX impact
			//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, HkGetSpellTargetLocation());
			float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds(iDuration*10) );
			int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
			HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fDuration ); // AFW-OEI 06/02/2006: Minutes
			DelayCommand(fDelay+1.5f, BuffSummons(OBJECT_SELF, nElemental, 1 ));
			//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, OBJECT_SELF), OBJECT_SELF );
	}
	
	HkPostCast(oCaster);
}

