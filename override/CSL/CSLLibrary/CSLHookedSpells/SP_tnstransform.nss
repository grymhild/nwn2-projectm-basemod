//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Gives the caster the following bonuses:
		+1 Attack per 2 levels
		+4 Natural AC
		20 STR and DEX and CON
		1d6 Bonus HP per level
		+5 on Fortitude Saves
		-10 Intelligence
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Polymorph"




void MarkSword(object oPC) {
	object oSword = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	SetLocalInt(oSword, "TENSORS_SWORD", TRUE);
}

void main()
{
	//scSpellMetaData = SCMeta_SP_tnstransform();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_TENSERS_TRANSFORMATION;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	CSLRemoveEffectSpellIdSingle(SC_REMOVE_ALLCREATORS, oCaster, oCaster, SPELL_TENSERS_TRANSFORMATION );
	CSLTimedFlag(oCaster, "LOADING", 1.0); // THIS SKIPS THE ON-EQUIP CHECK
	
	int iSpellPower = HkGetSpellPower(oCaster, 20);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	
	int nAB = CSLGetMin( iSpellPower - GetBaseAttackBonus(oCaster), 1);

	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//if (!GetIsPC(oCaster))
	//{
	//	return;
	//}
	
	 //Declare effects
    
    
	
    effect eVis = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
	
	effect eTensers = EffectAttackIncrease(nAB); 
    eTensers = EffectLinkEffects(eTensers, EffectSavingThrowIncrease(SAVING_THROW_FORT, 5));
    eTensers = EffectLinkEffects(eTensers, EffectAbilityIncrease(ABILITY_STRENGTH, 4));
    eTensers = EffectLinkEffects(eTensers, EffectAbilityIncrease(ABILITY_DEXTERITY, 4));
    eTensers = EffectLinkEffects(eTensers, EffectAbilityIncrease(ABILITY_CONSTITUTION, 4));
    eTensers = EffectLinkEffects(eTensers, EffectACIncrease(4, AC_NATURAL_BONUS));
    eTensers = EffectLinkEffects(eTensers, EffectSpellFailure(100));
    eTensers = EffectLinkEffects(eTensers, EffectVisualEffect( VFX_DUR_SPELL_TENSERS_TRANSFORM ));
					
	itemproperty iBonusFeat1 = ItemPropertyBonusFeat(22); //Martial
	itemproperty iBonusFeat2 = ItemPropertyBonusFeat(23); //Simple	
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
	if (oArmorNew == OBJECT_INVALID)
	{
		oArmorNew = CreateItemOnObject("x2_it_emptyskin", OBJECT_SELF, 1, "", FALSE);
		//AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat1,oArmorNew,fDuration);
		//AddItemProperty(DURATION_TYPE_TEMPORARY,iBonusFeat2,oArmorNew,fDuration);
		CSLSafeAddItemProperty(oArmorNew, iBonusFeat1, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
        CSLSafeAddItemProperty(oArmorNew, iBonusFeat2, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );		
		DelayCommand(fDuration, DestroyObject(oArmorNew,0.0f,FALSE));		
	}
	else
	{
        CSLSafeAddItemProperty(oArmorNew, iBonusFeat1, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );
        CSLSafeAddItemProperty(oArmorNew, iBonusFeat2, fDuration,SC_IP_ADDPROP_POLICY_KEEP_EXISTING );			
	}
    ClearAllActions();		
	ActionEquipItem(oArmorNew,INVENTORY_SLOT_CARMOUR);	
	DelayCommand(fDuration, DestroyObject(oArmorNew, 2.0f, FALSE)); 
		
    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));
	
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eTensers, OBJECT_SELF, fDuration,iSpellId);
	
	//ClearAllActions();
	
	//CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oCaster, oCaster, EFFECT_TYPE_TEMPORARY_HITPOINTS );
	
	// add temporary hit points -- does this work when before polymerge...
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	//int nHP = HkApplyMetamagicVariableMods(d6(iSpellPower), 120);
	//effect eHP   = EffectTemporaryHitpoints(nHP);
	//eHP = EffectLinkEffects(eHP,  EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oCaster, SPELL_TENSERS_TRANSFORMATION ) ) );
	/*
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oCaster, fDuration-0.01);
	
	PolyMerge(oCaster, SPELL_TENSERS_TRANSFORMATION, fDuration, FALSE, TRUE);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT,  EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION) , oCaster);

	DelayCommand(0.5f, MarkSword(oCaster) );
	*/
	//return;
	
	//int iDuration = HkGetSpellDuration( oCaster );
	

	

	//effect eLink = EffectVisualEffect(VFX_DUR_SPELL_TENSERS_TRANSFORM);
	
	
	
	//eLink = EffectLinkEffects(eLink, EffectPolymorph(POLYMORPH_TYPE_DOOM_KNIGHT));
	
	
	
	//eLink = EffectLinkEffects(eLink, eOnDispell);
	
	
	// SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_TENSERS_TRANSFORMATION, FALSE));
	 // prevents an exploit effect eVis  =;

	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	CSLConstitutionBugCheck( oCaster );
	
	HkPostCast(oCaster);	
}
