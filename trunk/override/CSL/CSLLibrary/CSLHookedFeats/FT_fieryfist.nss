//::///////////////////////////////////////////////
//:: Fiery Fist
//:: cmi_s2_fieryfist
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: April 12, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_FIERY_FIST;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	//FIRE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


   
   if (!GetHasFeat(39, OBJECT_SELF))
   {
        SpeakString("This ability is tied to your stunning fist ability, which has no more uses for today.");

   }
   else
   {
   		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  OBJECT_SELF, iSpellId );
			
		int nWis = 1 + GetAbilityModifier(ABILITY_WISDOM);
		float fDuration = RoundsToSeconds( nWis );
		
	    effect eVis = EffectVisualEffect(VFX_DUR_SPELL_PREMONITION);
		effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, iDamageType);
		effect eLink = EffectLinkEffects(eVis,eDmg);
		eLink = SupernaturalEffect(eLink);
	    eLink = SetEffectSpellId(eLink, iSpellId); 
	    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration);
		
        DecrementRemainingFeatUses(OBJECT_SELF, 39);
    }
    
    HkPostCast(oCaster);
}