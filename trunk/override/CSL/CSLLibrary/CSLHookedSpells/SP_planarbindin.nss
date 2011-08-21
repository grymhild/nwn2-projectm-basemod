//::///////////////////////////////////////////////
//:: Planar Binding
//:: NW_S0_Planar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Summons an outsider dependant on alignment, or
	holds an outsider if the creature fails a save.
	
	Level 6
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_CSLCore_Config"
#include "_SCInclude_Class"

void main()
{
	//scSpellMetaData = SCMeta_SP_planarbindin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_PLANAR_BINDING;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	object oTarget = HkGetSpellTarget();
	int iDescriptor = SCMETA_DESCRIPTOR_AIR;
	if ( !GetIsObjectValid(oTarget))
	{
		int nAlign = GetAlignmentGoodEvil(oCaster);
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
				iDescriptor = SCMETA_DESCRIPTOR_AIR;
				/*int iRoll = d4();
				switch (iRoll)
				{
					case 1: iDescriptor = SCMETA_DESCRIPTOR_FIRE; break;
					case 2: iDescriptor = SCMETA_DESCRIPTOR_EARTH; break;
					case 3: iDescriptor = SCMETA_DESCRIPTOR_WATER; break;
					case 4: iDescriptor = SCMETA_DESCRIPTOR_AIR; break;
				}*/
				break;
		}
	}
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
	//int iMetaMagic = GetMetaMagicFeat();
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster );
	effect eSummon;
	//effect eGate;
	int iSaveDC = HkGetSpellSaveDC()+2;
	effect eParalyze = EffectParalyze(iSaveDC, SAVING_THROW_WILL);
	effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
	eParalyze = EffectLinkEffects( eParalyze, eVis );
	effect eHit = EffectVisualEffect(VFX_HIT_SPELL_SUMMON_CREATURE);
	
	if (!GetIsPC(oCaster))
	{
		// SEED EDIT - PUT THE RESREF OF THE CREATURE YOU WANT THE MONSTER TO SUMMON IN A STRING VARIABLE "SUMMON_PET"
		string sOverRide = GetLocalString(oCaster, "SUMMON_PET");
		if (sOverRide!="") // OVERRIDE FOR MONSTER SUMMONS
		{
			object oMinion = CreateObject(OBJECT_TYPE_CREATURE, sOverRide, HkGetSpellTargetLocation(), TRUE);
			SetLocalInt(oMinion,"SEEDED",TRUE);
			//DelayCommand(200.0, Despawn(oMinion));
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_GATE), GetLocation(oMinion));
			return;
		}
	}
	
	int nRacial = GetRacialType(oTarget);
	int nAlign = GetAlignmentGoodEvil(oCaster);
	
	//Check to make sure a target was selected
	if (GetIsObjectValid(oTarget))
	{
		//Check the racial type of the target
		if(nRacial == RACIAL_TYPE_OUTSIDER)
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				//Fire cast spell at event for the specified target
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_PLANAR_BINDING, TRUE ));
				//Make a Will save
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC))
				{
					float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS)/2 );
					int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

					HkApplyEffectToObject(iDurType, eParalyze, oTarget, fDuration );
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
				}
			}
		}
	}
	else
	{
		//Set the summon effect based on the alignment of the caster
		string sSummon = "csl_sum_spirit_sylph";
		int iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
		float fDelay = 1.0f;
		if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )
		{
			sSummon = "csl_sum_tanar_succubus2";
			iVFXEffect = VFX_FNF_SUMMON_GATE;
			fDelay = 3.0f;		
		}
		else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )
		{
			sSummon = "csl_sum_celest_bear";
			iVFXEffect = VFX_FNF_SUMMON_CELESTIAL;
			fDelay = 3.0f;		
		}
		else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )
		{
			sSummon = "csl_sum_spirit_sylph";
			iVFXEffect = VFX_FNF_SUMMON_MONSTER_3;
			fDelay = 1.0f;
		}
		else
		{
			return;
		}
		eSummon = EffectSummonCreature(sSummon, iVFXEffect, fDelay);
		
		//Apply the summon effect and VFX impact
		//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eGate, HkGetSpellTargetLocation());
		
		if (GetHasFeat(FEAT_ASHBOUND, oCaster))
		{
			iDuration = iDuration * 2;
		}
		
		float fDuration = HkApplyMetamagicDurationMods( RoundsToSeconds(iDuration*10) );
		int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
		
		HkApplyEffectAtLocation(iDurType, eSummon, HkGetSpellTargetLocation(), fDuration ); // AFW-OEI 06/02/2006: Minutes
		DelayCommand(fDelay+1.5f, BuffSummons(oCaster, 0, 1));
		//SCApplySummonTag( GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster), oCaster );
	}
	
	HkPostCast(oCaster);
}

