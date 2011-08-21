/*
Dracon Sight
Sean Harrington
11/11/07
#1376
*/
//#include "nwn2_inc_spells"
//#include "x2_inc_spellhook"


#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object 		oPC 			= OBJECT_SELF;
object 		oTarget 		= GetSpellTargetObject();
location 	lLocation		= GetSpellTargetLocation();
int			nCasterLevel	= HkGetCasterLevel(oPC);
int			nDuration 		= nCasterLevel*3600;


if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration *2;
}





effect eSeeInviso		= EffectSeeInvisible();
effect eLLVision		= EffectUltravision();
effect eDarkVision		= EffectDarkVision();
effect eLink			= EffectLinkEffects(eSeeInviso,eLLVision);
		eLink			= EffectLinkEffects(eLink,eDarkVision);



/*
if (!GetIsObjectValid(GetItemPossessedBy(oPC,"sh_i_dragons_eye")))
	{
	SendMessageToPC(oPC,"You must possess a dragon's eye to use as a focus to cast this spell");
	return;
	}

*/



HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,IntToFloat(nDuration));









}