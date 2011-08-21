//::///////////////////////////////////////////////
//:: Poison
//:: NW_S0_Poison.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Must make a touch attack. If successful the target
	is struck down with wyvern poison.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void main()
{
	//scSpellMetaData = SCMeta_SP_poison();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_POISON;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_ASN_Poison )
	{
		iClass = CLASS_TYPE_ASSASSIN;
	}
	else if ( GetSpellId() == SPELL_BG_Poison )
	{
		iClass = CLASS_TYPE_BLACKGUARD;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_POISON, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	object oTarget = HkGetSpellTarget();
	object oItem  = GetSpellCastItem();
	if (GetIsObjectValid(oItem))
	{
		string sPoison = GetLocalString(oItem, "SPECIALPOISON");
		if (sPoison!="")
		{
			object oPC = GetItemPossessor(oItem);
			if (GetLocalInt(oTarget, "SPECIALPOISON")) return; // TARGET CAN ONLY BE POISONED ONCE PER ROUND
			int iBonus = CSLGetMax(GetLevelByClass(CLASS_TYPE_ASSASSIN), GetLevelByClass(CLASS_TYPE_BLACKGUARD)) / 2;
			int nPoisonType = GetLocalInt(oItem, "SPECIALPOISON_TYPE") + iBonus;
			FloatingTextStringOnCreature("<color=limegreen>*Poison Attack*", oPC);
			SendMessageToPC(oTarget, "<color=limegreen>Some " + sPoison + " gets in your wounds.");
			SendMessageToPC(oCaster, "Poison Type : " + sPoison + " row # " + IntToString(nPoisonType));
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(nPoisonType), oTarget);
			CSLTimedFlag(oTarget, "SPECIALPOISON", 6.0); // PUT FLAG ON FOR 6 SECS
			return;
		}
	}

	//Declare major variables
	effect ePoison = EffectPoison(POISON_LARGE_SCORPION_VENOM);
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_POISON, TRUE ));
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
				HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
			}
		}
	}
	HkPostCast(oCaster);
}

