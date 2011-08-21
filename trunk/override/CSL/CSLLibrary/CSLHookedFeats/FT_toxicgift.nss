//::///////////////////////////////////////////////
//:: Toxic Gift
//:: cmi_s2_toxicgift
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
	//scSpellMetaData = SCMeta_FT_toxicgift();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_TOXIC_GIFT;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


   int nWildShapeFeat = GetCurrentWildShapeFeat(OBJECT_SELF);
   
   if (nWildShapeFeat == -1)
   {
        SpeakString("This ability is tied to your wildshape ability, which has no more uses for today.");
   }
   else
   {
		if (GetHasSpellEffect(iSpellId))
		{
			CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  OBJECT_SELF, iSpellId );
		}
			
		float fDuration = RoundsToSeconds( HkGetSpellDuration(OBJECT_SELF) );
		
	    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
		effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_ACID);
		effect eLink = EffectLinkEffects(eVis,eDmg);
		eLink = SupernaturalEffect(eLink);
	    eLink = SetEffectSpellId(eLink, iSpellId); 
	    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
		
        DecrementRemainingFeatUses(OBJECT_SELF, nWildShapeFeat);
    }
    
    HkPostCast(oCaster);
}