#include "_HkSpell"
#include "_SCInclude_Class"
#include "elu_fam_ancom_i"

void main()
{
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_BUFF;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )	
		return;
	
	object oMyPet = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);
	if (GetIsObjectValid(oMyPet))
	{
		SendMessageToPC(oCaster, "Animal Companion is already summoned.");
		HkPostCast(oCaster);
		return;
	}
	
	SummonAnimalCompanion();
	oMyPet = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, OBJECT_SELF);
	
	if (GetHasFeat(FEAT_SILVER_FANG))	
		ApplySilverFangEffect(oMyPet);	

	string sTag = GetTag(oMyPet);
	if (FindSubString(sTag, "blue") > -1 || FindSubString(sTag, "bronze") > -1)
	{
		effect eImm = EffectImmunity(FEAT_SNEAK_ATTACK);
		eImm = SupernaturalEffect(eImm);
		DelayCommand(1.0f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eImm, oMyPet));
	}

	int iHD = GetHitDice(oMyPet);
	int nSR = 5 + iHD;
	effect eSR = EffectSpellResistanceIncrease(nSR);
	int nHasSR = 0;
	if (GetHasFeat(FEAT_EXALTED_COMPANION))
	{
		nHasSR = 1;
		int nDR = 0;
		int nResist = 0;

		if (iHD > 7)		
			nResist = 10;		
		else		
			nResist = 5;		

		if (iHD > 11)		
			nDR = 10;		
		else		
			nDR = 5;		

		effect eDarkVis = EffectDarkVision();
		effect eDR = EffectDamageReduction(10, GMATERIAL_METAL_ADAMANTINE, 0, DR_TYPE_GMATERIAL);
		//effect eDR = EffectDamageReduction(nDR); // 10 unless a magic weapon
		effect eLink;

		if (GetAlignmentGoodEvil(OBJECT_SELF) == ALIGNMENT_EVIL)
		{	//Fiendish
			effect eDmgRes1 = EffectDamageResistance(DAMAGE_TYPE_FIRE,nResist);
			effect eDmgRes2 = EffectDamageResistance(DAMAGE_TYPE_COLD,nResist);
			eLink = EffectLinkEffects(eDmgRes1, eDmgRes2);
		}
		else
		{	//Celestial
			effect eDmgRes1 = EffectDamageResistance(DAMAGE_TYPE_ACID,nResist);
			effect eDmgRes2 = EffectDamageResistance(DAMAGE_TYPE_COLD,nResist);
			effect eDmgRes3 = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL,nResist);
			eLink = EffectLinkEffects(eDmgRes1, eDmgRes2);
			eLink = EffectLinkEffects(eLink, eDmgRes3);
		}

		eLink = EffectLinkEffects(eLink, eDarkVis);
		eLink = EffectLinkEffects(eLink, eSR);
		eLink = EffectLinkEffects(eLink, eDR);
		//eLink = SetEffectSpellId(eLink,iSpellId);
		eLink = SupernaturalEffect(eLink);
		DelayCommand(1.0f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oMyPet) );
	}

	if (GetHasFeat(FEAT_DEVOTED_TRACKER))
	{
		FeatAdd(oMyPet, 1337, FALSE);
		FeatAdd(oMyPet, 206, FALSE);
		FeatAdd(oMyPet, 212, FALSE);
		effect eLink = EffectACIncrease(2);
		if (GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF) > 14 && !nHasSR)
			eLink = EffectLinkEffects(eLink, eSR);
		//eLink = SetEffectSpellId(eLink,nSpellId);
		eLink = SupernaturalEffect(eLink);

		DelayCommand(1.0f, HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oMyPet));
	}
	HkPostCast(oCaster);
}