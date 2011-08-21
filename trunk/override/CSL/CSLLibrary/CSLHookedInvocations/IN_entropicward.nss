//::///////////////////////////////////////////////
//:: Invocation: Entropic Warding
//:: NW_S0_IEntrWard.nss
//:://////////////////////////////////////////////
/*
	Gives +4 Move Silently and Hide Skill Bonuses,
	and gives effect of Entropic Shield (Cleric)
	Spell:

	20% concealment to ranged attacks including
	ranged spell attacks
	Duration: 1 turn/level
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Invocations"





void main()
{
	//scSpellMetaData = SCMeta_IN_entropicward();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_WARLOCK;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE;
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
	

	
	//int iSpellPower = HkGetSpellPower( oCaster, 30, CLASS_TYPE_WARLOCK ); // OldGetCasterLevel(oCaster);
	int iBonus = 4;//HkGetWarlockBonus(oCaster);
	SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
	effect eLink = EffectVisualEffect(VFX_DUR_SPELL_ENTROPIC_SHIELD); // Using the same VFX as entropic shield
	eLink = EffectLinkEffects(eLink, EffectConcealment(20, MISS_CHANCE_TYPE_VS_RANGED));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_MOVE_SILENTLY, iBonus));
	eLink = EffectLinkEffects(eLink, EffectSkillIncrease(SKILL_HIDE, iBonus));
	CSLUnstackSpellEffects(oCaster, GetSpellId());
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, HkApplyDurationCategory(1, SC_DURCATEGORY_DAYS) );
	
	HkPostCast(oCaster);
}