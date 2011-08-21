//::///////////////////////////////////////////////
//:: Eldritch Glaive
//:: cmi_s0_eldglaive
//:: Purpose: WARNING: Currently critical hits are not accounted for in the damage.
//:: 	ALSO: ONLY the Brimstone, Hellrime, Vitriolic, and Standard blast are functioning.
//::	ALSO: Melee Touch Attack Focus/Specialization is not accounted for.
//::	ALSO: This has not yet been tested.  Placeholder for getting it working.
//:: Created By: Kaedrin (Matt)
//:: Created On: Nov 11, 2007
//:://////////////////////////////////////////////
//:: Eldritch Glaive
//:: Invocation Type: Least; Blast Shape
//:: Spell Level Equivalent: 2
//:: 
//:: Your eldritch blast takes on physical substance, appearing similar to a
//:: glaive. As a full-round action, you can make a single melee touch attack.
//:: If you hit, your target is affected as if struck by your eldritch blast
//:: (including any eldritch essence applied to the blast).
//:: 
//:: If your base attack bonus is +6 or higher, you can (as part of the
//:: full-round action) make as many attacks with your eldritch glaive as
//:: your base attack bonus allows (maximum of 4). For example, a 12th-level
//:: warlock could attack twice, once with a base attack bonus of +9, and again
//:: with a base attack bonus of +4.
//:://////////////////////////////////////////////
// const int SPELL_Eldritch_Glaive = 1844;



#include "_HkSpell"
#include "_SCInclude_Invocations"
//#include "nw_i0_invocatns"

void main()
{	
	//scSpellMetaData = SCMeta_IN_eldglaive();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ELDRITCH, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
	//int nAtkCap = GetLocalInt(GetModule(), "EldGlaiveAttackCap");
	//int nAllowEssence = GetLocalInt(GetModule(), "EldGlaiveAllowEssence");
	int nAllowHaste = CSLGetPreferenceSwitch("EldGlaiveAllowHasteBoost",FALSE);				
	int nAllowCrit = CSLGetPreferenceSwitch("EldGlaiveAllowCrits",FALSE);	
	int nAllowEssence = TRUE;
	int nHasHaste = FALSE;
	
	if (nAllowHaste)
	{
	    // Need To: Possibly check for haste items too, like our boots we use -- get has haste function might be useful
	    if (  CSLGetHasEffectType( oCaster, EFFECT_TYPE_HASTE ) )
		{
			nHasHaste = 1;
		}
	}
	
	

    //Declare major variables
    object oTarget = HkGetSpellTarget();
	int iMetaMagic = GetMetaMagicFeat();
	
	
	int nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_ELDRITCH;
	//Enter Metamagic conditions
	
	//CSLHideHeldItems( oCaster, 5.5f );
	//if ( SetWeaponVisibility(OBJECT_SELF, FALSE, 0) )
	//{
	//	DelayCommand(5.0f, SetWeaponVisibility(OBJECT_SELF, 4, 0 ) ); // reset to default
	//}
	//object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	//if ( SetWeaponVisibility(oWeaponNew, FALSE, 0) )
	//{
	//	DelayCommand(5.0f, SetWeaponVisibility(oWeaponNew, 4, 0 ) ); // reset to default
	//}
	
	if ( iMetaMagic & METAMAGIC_INVOC_DRAINING_BLAST )         { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_NEGATIVE; }
	else if ( iMetaMagic & METAMAGIC_INVOC_FRIGHTFUL_BLAST )   { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_MAGIC; }
	else if ( iMetaMagic & METAMAGIC_INVOC_BESHADOWED_BLAST )  { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_NEGATIVE; }
	else if ( iMetaMagic & METAMAGIC_INVOC_BRIMSTONE_BLAST )   { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_FIRE; }
	else if ( iMetaMagic & METAMAGIC_INVOC_HELLRIME_BLAST )    { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_COLD; }
	else if ( iMetaMagic & METAMAGIC_INVOC_BEWITCHING_BLAST )  { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_MAGIC; }
	else if ( iMetaMagic & METAMAGIC_INVOC_NOXIOUS_BLAST )     { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_MAGIC; }
	else if ( iMetaMagic & METAMAGIC_INVOC_VITRIOLIC_BLAST )   { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_ACID; }
	else if ( iMetaMagic & METAMAGIC_INVOC_UTTERDARK_BLAST )   { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_NEGATIVE; }
	else if ( iMetaMagic & METAMAGIC_INVOC_BINDING_BLAST )     { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_MAGIC; }
	else if ( iMetaMagic & METAMAGIC_INVOC_HINDERING_BLAST )   { nDurVFX = VFXSC_DUR_SPELLWEAP_GLAIVE_MAGIC; }
	
   CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, GetSpellId() );
   
   ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( nDurVFX ), oCaster, 6.0f);

    //Fire cast spell at event for the specified target
    SignalEvent(oCaster, EventSpellCastAt(oCaster, iSpellId, FALSE));

    //Apply the VFX impact and effects
    //HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect( nDurVFX ), oCaster,6.0f);
	//Apply Damage
	
	int nBaseBAB = GetTRUEBaseAttackBonus(oCaster);
	int nCurrentBAB = nBaseBAB; 
	int iNumAttacks = ((nCurrentBAB-1)/5)+1;
	//int nCurrentBAB = nBaseBABSCGetMin( nBaseBAB, SC_ELDGLAIVEBASEATTACKCAP );
	iNumAttacks = CSLGetMin( iNumAttacks, CSLGetPreferenceInteger("EldGlaiveAttackCap",2) );
	
	int iBonus = 0;
    if (GetHasFeat(FEAT_EPIC_ELDRITCH_MASTER, oCaster))
    {
        iBonus = 2;
    }
    object oScepter = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	if (GetIsObjectValid(oScepter) && (GetTag(oScepter) == "cmi_wlkscptr01"))
	{
		iBonus += 2;	
	}
	
	if (CSLGetHasEffectType( OBJECT_SELF, EFFECT_TYPE_POLYMORPH ))
	{
		if (!GetHasFeat(FEAT_GUTTURAL_INVOCATIONS, OBJECT_SELF))
		{
			iBonus -= 20;
			SendMessageToPC(OBJECT_SELF,"You are exploiting the casting of spells while polymorphed without the Guttural Invocations feat. Your touch attack has been penalized 20 points.");			
		}				
	}
	
	if (GetActionMode(OBJECT_SELF, ACTION_MODE_IMPROVED_COMBAT_EXPERTISE) == TRUE)
	{
		iBonus -= 6;
	}
	else if (GetActionMode(OBJECT_SELF, ACTION_MODE_COMBAT_EXPERTISE) == TRUE)
	{
		iBonus -= 3;
	}
	
	
	int nCurrentAttack = 1;
	
	while (nCurrentBAB >= 0 && iNumAttacks > 0)
	{
		int iTouch = CSLTouchAttackMelee(oTarget,TRUE,(nCurrentBAB - nBaseBAB + iBonus));
		if (iTouch != TOUCH_ATTACK_RESULT_MISS )
		{
			//CSLNWN2Emote(oPC, "1attack01");
			//DoEldritchGlaiveAnimations( oCaster );
			PlayCustomAnimation(oCaster, "Glaive0"+IntToString(d4()), 0, 1.0);
			//PlayCustomAnimation(oCaster, "1attack01", FALSE);
			if (nAllowEssence)
			{
				DoEldritchCombinedEffects(oTarget, FALSE, FALSE );
			}
			else
			{
				if (iTouch == 2 && nAllowCrit == 1)
				{
					DoEldritchBlast(OBJECT_SELF, oTarget,FALSE,FALSE, 2);
				}
				else
				{
					DoEldritchBlast(OBJECT_SELF, oTarget,FALSE,FALSE);
				}
			}
		}
		if (nAllowHaste && nHasHaste && iNumAttacks == 1)
		{
			nAllowHaste = 0;
		}
		else
		{
			nCurrentBAB -= 5;
			iNumAttacks -= 1;
		}
	}
	
	
	
	
	
	SCWarlockPostCast(oCaster);
	HkPostCast(oCaster);
}