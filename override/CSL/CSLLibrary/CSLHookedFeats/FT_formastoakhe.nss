//::///////////////////////////////////////////////
//:: Oak Heart
//:: cmi_s2_oakheart
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 13, 2008
//:://////////////////////////////////////////////


/*----  Kaedrin PRC Content ---------*/


//#include "_SCInclude_Class"
#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = FOREST_MASTER_OAK_HEART;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
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
	

	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	//int iDamageType = HkGetDamageType( DAMAGE_TYPE_NONE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );

	effect eMind = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	effect ePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
	effect eSleep = EffectImmunity(IMMUNITY_TYPE_SLEEP);
	effect eParalysis = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
	effect eStun = EffectImmunity(IMMUNITY_TYPE_STUN);
	effect eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
	effect eSneak = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
	effect eVuln = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE, 50);
	
	effect eLink = EffectLinkEffects(eMind,ePoison);
	eLink = EffectLinkEffects(eLink, eSleep);
	eLink = EffectLinkEffects(eLink, eParalysis);
	eLink = EffectLinkEffects(eLink, eStun);
	eLink = EffectLinkEffects(eLink, eCrit);
	eLink = EffectLinkEffects(eLink, eSneak);
	eLink = EffectLinkEffects(eLink, eVuln);						
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
	
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF, 0.0f, iSpellId ));
	
	HkPostCast(oCaster);
}