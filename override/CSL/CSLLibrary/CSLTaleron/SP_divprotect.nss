/*
Divine Protection
Sean Harrington
11/11/07
#1374
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
location 	lLocation		= GetSpellTargetLocation();
object 		oTarget 		= GetFirstObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_HUGE,lLocation,FALSE,OBJECT_TYPE_CREATURE);

int			nCasterLevel	= HkGetCasterLevel(oPC);
int			nDuration 		= nCasterLevel;
effect		eSave			= EffectSavingThrowIncrease(SAVING_THROW_ALL,1);
effect		eAC				= EffectACIncrease(1);
effect 		eLink			= EffectLinkEffects(eSave,eAC);


if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration *2;
}
if (HkGetMetaMagicFeat() == METAMAGIC_PERSISTENT)
{
nDuration = 24 * 60; //24 hours x 60 minutes per hour, being lazy and not doing the math, heh.
}


while (GetIsObjectValid(oTarget))
{


if (GetIsFriend(oTarget,OBJECT_SELF) && oTarget != oPC)
{

HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,TurnsToSeconds(nDuration ));

}




oTarget	= GetNextObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_HUGE,lLocation,FALSE,OBJECT_TYPE_CREATURE);
}







	}