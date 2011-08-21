//::///////////////////////////////////////////////
//:: [Dominate Animal]  (Harper Class Ability "Llurue's Voice")
//:: [NW_S2_DomAn.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 30, 2001


// JLR-OEI 04/02/06: For GDD Update


#include "_HkSpell" 
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_FT_harperdomani();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE;
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
	effect eDom = HkGetScaledEffect(EffectDominated(), oTarget);

	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_DOM_ANIMAL );
	
	int iCasterLevel = HkGetSpellPower(oCaster,60,CLASS_TYPE_RACIAL); //  GetTotalLevels(OBJECT_SELF, TRUE); //HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDuration = 3 + iCasterLevel;

	//Fire cast spell at event for the specified target
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_ANIMAL, FALSE));
	//Make sure the target is an animal
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		if ( CSLGetIsAnimal(oTarget) )
		{
			//Make SR check
			if (!HkResistSpell(OBJECT_SELF, oTarget))
			{
				//Will Save for spell negation
				if (!/*Will Save*/ HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
				{
					//Check for Metamagic extension
					float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
					int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

					//Apply linked effect and VFX impact
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
					HkApplyEffectToObject(iDurType, eDom, oTarget, fDuration );
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}