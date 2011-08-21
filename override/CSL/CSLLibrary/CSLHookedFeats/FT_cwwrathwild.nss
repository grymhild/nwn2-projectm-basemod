//::///////////////////////////////////////////////
//:: Wrath of the Wild
//:: cmi_s2_wrathwild
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 23, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_cwwrathwild();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_CHAMPWILD_WRATH_WILD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = 0;
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
	if (GetHasSpellEffect(iSpellId,OBJECT_SELF))
	{
		return;
		//RemoveSpellEffects(iSpellId, OBJECT_SELF, OBJECT_SELF);
	}	
	
	int iDuration = GetAbilityModifier(ABILITY_CHARISMA) + 4;
	if (iDuration < 1)
		iDuration = 1;
		
	float fDuration = RoundsToSeconds( iDuration );

	
    object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();	
	int nItemVisual = ITEM_VISUAL_HOLY;				
	
    if(GetIsObjectValid(oMyWeapon) )
    {
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyVisualEffect(nItemVisual), fDuration,SC_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);//Make the sword glow	
        DelayCommand(1.0f, HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HOLY_AID ),GetLocation(HkGetSpellTarget())));
    }
    else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    }
	
	effect eAB = EffectAttackIncrease(2);
	effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_DIVINE);
	effect eLink = EffectLinkEffects(eAB, eDmg);	
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);
	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, fDuration, iSpellId ));
	
	HkPostCast(oCaster);
}

