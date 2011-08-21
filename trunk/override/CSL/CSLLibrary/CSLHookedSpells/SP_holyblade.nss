//::///////////////////////////////////////////////
//:: Sacred Flame
//:: cmi_s2_sacredflame
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Oct 3, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"
#include "_SCInclude_Class"

void main()
{	
	//scSpellMetaData = SCMeta_SP_holyblade();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_SB_Holy_Blade;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	
	int nDur = GetLevelByClass(CLASS_SHINING_BLADE, OBJECT_SELF);
	int nCha = GetAbilityModifier(ABILITY_CHARISMA);
	nDur = nDur + nCha;
	
		
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BLESS_WEAPON );
	if (nDur > 8)
	{
		effect eAB = EffectAttackIncrease(2);
		eVis = EffectLinkEffects(eVis, eAB);
	}
	
    object oMyWeapon   =  CSLGetTargetedOrEquippedMeleeWeapon();	
		
   	if(GetIsObjectValid(oMyWeapon) )
	{
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
		CSLSafeAddItemProperty(oMyWeapon, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL,IP_CONST_DAMAGETYPE_DIVINE,IP_CONST_DAMAGEBONUS_2d6), RoundsToSeconds(nDur),SC_IP_ADDPROP_POLICY_KEEP_EXISTING);
	   	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDur));
	   	DecrementRemainingFeatUses(OBJECT_SELF,FEAT_SB_HOLY_BLADE1);
		DecrementRemainingFeatUses(OBJECT_SELF,FEAT_SB_SHOCK_BLADE1);
		return;
    }
    else
    {
    	FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
    	return;
    }

	HkPostCast(oCaster);
}

