//::///////////////////////////////////////////////
//:: Pain Touch
//:: cmi_s2_paintouch
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 28, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x0_I0_SPELLS"
//#include "x2_inc_spellhook"

void main()
{	
	//scSpellMetaData = SCMeta_FT_paintouch();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	


    object oTarget = HkGetSpellTarget();
	int iTouch = CSLTouchAttackMelee(oTarget);
	int nStrLoss = 2;
	int nDexLoss = 2;
	
	nStrLoss = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nStrLoss, SC_TOUCH_MELEE, oCaster );
	nDexLoss = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, nDexLoss, SC_TOUCH_MELEE, oCaster );
	
	
	
	
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);	
	
	effect eABLoss = EffectAbilityDecrease(ABILITY_STRENGTH,nStrLoss);
	effect eACLoss = EffectAbilityDecrease(ABILITY_DEXTERITY,nDexLoss);
	
	effect eLink = EffectLinkEffects(eABLoss,eACLoss);
	eLink = SupernaturalEffect(eLink);

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    
    // sneak damage on a attribute draining attack is added as negative damage
    int iSneakDamage = CSLEvaluateSneakAttack(oTarget, oCaster);
	if ( iSneakDamage > 0 )
	{
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iSneakDamage, DAMAGE_TYPE_NEGATIVE), oTarget);
	}
	
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, TurnsToSeconds(1));
    
    
    HkPostCast(oCaster);
}