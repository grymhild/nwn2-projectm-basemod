//::///////////////////////////////////////////////
//:: Elemental Essence
//:: cmi_s2_elemessence
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 12, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_FT_elemessence();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iClass = CLASS_TYPE_NONE;
	int iSpellId = SPELLABILITY_ELEMENTAL_ESSENCE_F;
	int iDescriptor = SCMETA_DESCRIPTOR_FIRE;
	if (GetSpellId() == SPELLABILITY_ELEMENTAL_ESSENCE || GetSpellId() == SPELLABILITY_ELEMENTAL_ESSENCE_A )
	{
		iDescriptor = SCMETA_DESCRIPTOR_ACID;
		iSpellId = SPELLABILITY_ELEMENTAL_ESSENCE_A;
	}
	else if (GetSpellId() == SPELLABILITY_ELEMENTAL_ESSENCE_C)
	{
		iDescriptor = SCMETA_DESCRIPTOR_COLD;
		iSpellId = SPELLABILITY_ELEMENTAL_ESSENCE_C;
	}
	else if (GetSpellId() == SPELLABILITY_ELEMENTAL_ESSENCE_E)
	{
		iDescriptor = SCMETA_DESCRIPTOR_ELECTRICAL;
		iSpellId = SPELLABILITY_ELEMENTAL_ESSENCE_E;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes =114816;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

   int nEffectSpellID = SPELLABILITY_ELEMENTAL_ESSENCE;
   
   int nWildShapeFeat = GetCurrentWildShapeFeat(OBJECT_SELF);

   if (nWildShapeFeat == -1)
   {
        SpeakString("This ability is tied to your wildshape ability, which has no more uses for today.");
   }
   else
   {
   		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, nEffectSpellID);
   
		float fDuration = RoundsToSeconds( 10 );
		effect eLink;
		
		if (iSpellId == SPELLABILITY_ELEMENTAL_ESSENCE || iSpellId == SPELLABILITY_ELEMENTAL_ESSENCE_A)
		{
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
			effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_ACID);
			effect eDmgRes = EffectDamageResistance(DAMAGE_TYPE_ACID, 5);
			eLink = EffectLinkEffects(eVis,eDmg);
			eLink = EffectLinkEffects(eDmgRes,eLink);
		}
		else if (iSpellId == SPELLABILITY_ELEMENTAL_ESSENCE_C)
		{
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
			effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_COLD);
			effect eDmgRes = EffectDamageResistance(DAMAGE_TYPE_COLD, 5);
			eLink = EffectLinkEffects(eVis,eDmg);
			eLink = EffectLinkEffects(eDmgRes,eLink);
		}
		else if (iSpellId == SPELLABILITY_ELEMENTAL_ESSENCE_E)
		{
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
			effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_ELECTRICAL);
			effect eDmgRes = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 5);
			eLink = EffectLinkEffects(eVis,eDmg);
			eLink = EffectLinkEffects(eDmgRes,eLink);
		}
		else
		{
		    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
			effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_FIRE);
			effect eDmgRes = EffectDamageResistance(DAMAGE_TYPE_FIRE, 5);
			eLink = EffectLinkEffects(eVis,eDmg);
			eLink = EffectLinkEffects(eDmgRes,eLink);
		}					
		
		eLink = SupernaturalEffect(eLink);		
	    eLink = SetEffectSpellId(eLink, SPELLABILITY_ELEMENTAL_ESSENCE); 
	    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
		
        DecrementRemainingFeatUses(OBJECT_SELF, nWildShapeFeat);
    }
    
    HkPostCast(oCaster);
}