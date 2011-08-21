//::///////////////////////////////////////////////
//:: Hunter's Immunity (and all other Skullclan Hunter abilities)
//:: cmi_s2_skullimmun
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: July 26, 2008
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "_SCInclude_Class"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_spells"
//#include "cmi_includes"

void main()
{	
	//scSpellMetaData = SCMeta_FT_skullclanhun();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELLABILITY_SKULLCLAN_HUNTERS_IMMUNITIES;
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
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, OBJECT_SELF, iSpellId );
	}		
	
	int nClassLevel = GetLevelByClass(CLASS_SKULLCLAN_HUNTER);
		
	
	effect eLink = EffectImmunity(IMMUNITY_TYPE_FEAR); //3rd level


	
	
	if (nClassLevel > 9)
	{
		effect eImmuneEnrgyDrn = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);		
		eLink = EffectLinkEffects(eLink, eImmuneEnrgyDrn);
	}
	if (nClassLevel > 7)
	{
		effect eImmuneAbilDmg = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
		eLink = EffectLinkEffects(eLink, eImmuneAbilDmg);		
	}
	if (nClassLevel > 6)
	{	
		effect eImmunePara = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
		eLink = EffectLinkEffects(eLink, eImmunePara);
	}
	if (nClassLevel > 3)
	{	
		effect eImmuneDisease = EffectImmunity(IMMUNITY_TYPE_DISEASE);
		eLink = EffectLinkEffects(eLink, eImmuneDisease);
	}
		
	if (nClassLevel > 8) //Sword of Dark
	{
		effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_2d6, DAMAGE_TYPE_DIVINE);
		eDmg = VersusRacialTypeEffect(eDmg, RACIAL_TYPE_UNDEAD);
		eLink = EffectLinkEffects(eLink, eDmg);
	}
	else
	if (nClassLevel > 4) //Sword of Light
	{
		effect eDmg = EffectDamageIncrease(DAMAGE_BONUS_1d6, DAMAGE_TYPE_DIVINE);
		eDmg = VersusRacialTypeEffect(eDmg, RACIAL_TYPE_UNDEAD);		
		eLink = EffectLinkEffects(eLink, eDmg);		
	}	
	
	if (nClassLevel > 3) //Protection
	{
		effect eProtEvil;
	    effect eAC = EffectACIncrease(2, AC_DEFLECTION_BONUS);
	    eAC = VersusAlignmentEffect(eAC,ALIGNMENT_ALL, ALIGNMENT_EVIL);
	    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
	    eSave = VersusAlignmentEffect(eSave,ALIGNMENT_ALL, ALIGNMENT_EVIL);
	    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
	    eImmune = VersusAlignmentEffect(eImmune,ALIGNMENT_ALL, ALIGNMENT_EVIL);
	    
		eProtEvil = EffectLinkEffects(eImmune, eSave);
	    eProtEvil = EffectLinkEffects(eProtEvil, eAC);	
		
		eProtEvil = SetEffectSpellId(eProtEvil,iSpellId);
		eProtEvil = SupernaturalEffect(eProtEvil);
		DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eProtEvil, OBJECT_SELF, 0.0f, iSpellId));					
	}
	
	eLink = SetEffectSpellId(eLink,iSpellId);
	eLink = SupernaturalEffect(eLink);

	DelayCommand(0.1f, HkUnstackApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, OBJECT_SELF, 0.0f,  iSpellId));
	
	HkPostCast(oCaster);
}