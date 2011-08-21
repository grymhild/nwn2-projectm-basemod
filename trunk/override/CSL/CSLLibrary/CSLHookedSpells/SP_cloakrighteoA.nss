//::///////////////////////////////////////////////
//:: Cloak of Righteousness (a) - Enter AOE
//:: sg_s0_clkrighta.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
	This spell creates a shining, white cloak/aura
	around the caster. Foes seeing the aura must
	make a Fortitude save or be blinded for the
	remaining duration of the spell. Allies seeing
	the aura are affected as if by a Bless spell.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 28, 2003
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_GOOD, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetEnteringObject();
	int 	iCasterLevel 	= HkGetCasterLevel(oCaster);
	//location lTarget 		= HkGetSpellTargetLocation();
	int 	iDC 			= HkGetSpellSaveDC(oCaster, oTarget);
	int 	iMetamagic 	= HkGetMetaMagicFeat();
	int iDuration = GetLocalInt(oCaster, "SG_L_CR_DUR");
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int nDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eTargetVis 	= EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
	effect eTargetDmg 	= EffectBlindness();
	effect eFriendVis 	= EffectVisualEffect(VFX_IMP_HEAD_HOLY);
	effect eAttack 	= EffectAttackIncrease(1);
	effect eSave 		= EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
	effect eDur 		= EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

	effect eFriendImp 	= EffectLinkEffects(eAttack, eSave);
	eFriendImp = EffectLinkEffects(eFriendImp, eDur);

	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	if(GetObjectSeen(oCaster,oTarget))
	{
		if(!CSLSpellsIsTarget(oTarget,SCSPELL_TARGET_ALLALLIES, oCaster) && oTarget!=oCaster)
		{
			SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_CLOAK_RIGHTEOUSNESS));
			if(!HkResistSpell(oCaster, oTarget))
			{
				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 0.0f, SAVING_THROW_RESULT_REMEMBER ) )
				{
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eTargetVis, oTarget);
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTargetDmg, oTarget, fDuration);
				}
			}
		}
		else
		{
			SignalEvent(oTarget,EventSpellCastAt(oCaster,SPELL_CLOAK_RIGHTEOUSNESS,FALSE));
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFriendImp, oTarget, fDuration);
		}
	}
}
