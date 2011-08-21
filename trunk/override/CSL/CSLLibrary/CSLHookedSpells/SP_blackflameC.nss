//::///////////////////////////////////////////////
//:: Blackflame (B) - Heartbeat
//:: sg_s0_blkflameb.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	shadowy flames burst to life on one subject,
	causing dmg. target must save each round throughout
	the duration of the spell. Those failing a will save
	take no actions that round and are considered to be cowering.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 25, 2003
//:://////////////////////////////////////////////
//#include "sg_i0_spconst"
//#include "sg_inc_spinfo"
//#include "sg_inc_wrappers"
//#include "sg_inc_utils"
//#include "x2_i0_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	if (CSLDestroyUnownedAOE(oCaster, OBJECT_SELF)) { return; }
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 8;
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_FEAR, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	object oTarget = HkGetAOEOwner(OBJECT_SELF);
	location lTarget 		= GetLocation(oTarget);
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();

		

	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
	int 	iDieType 		= 10;
	int 	iNumDice 		= 1;
	int 	iBonus 		= 0;
	int 	iDamage 		= 0;

	string sAfraid 		= "Help me please! Help me! I'm burning!";
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	//if(SGCheckMetamagic(iMetamagic,METAMAGIC_EXTEND)) fDuration *= 2;
	//iDamage=SGMaximizeOrEmpower(iDieType,iNumDice,iMetamagic,iBonus);
	iDamage = HkApplyMetamagicVariableMods(CSLDieX( iDieType, iNumDice), iDieType * iNumDice)+iBonus;
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eDmg 	= EffectDamage(iDamage,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_PLUS_FIVE);
	effect eCowerVis= EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
	effect eVis = EffectVisualEffect( VFX_HIT_SPELL_NECROMANCY );
	effect eFright = EffectFrightened();
	effect ePara 	= EffectParalyze();

	effect eCower 	= EffectLinkEffects(eFright,ePara);
	eCower = EffectLinkEffects(eCowerVis,eCower);
	
	//effect eImpVis = EffectVisualEffect(VFX_IMP_ELEMENTAL_PROTECTION);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_BLACKFLAME));
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
	if(FortitudeSave(oTarget, iDC)==0) {
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget);
		if(WillSave(oTarget, iDC, SAVING_THROW_TYPE_MIND_SPELLS)==0) {
			AssignCommand(oTarget,ClearAllActions());
			DelayCommand(0.2f,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCower, oTarget, HkApplyDurationCategory(1)));
			DelayCommand(0.5f,AssignCommand(oTarget,ActionSpeakString(sAfraid)));
		}
	}
}
