/*
Blast of Force
Sean Harrington
11/10/07
#1351
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

if (nCasterLevel > 10 ) nCasterLevel = 10;



int			nDuration 		= 6;

if (HkGetMetaMagicFeat() == METAMAGIC_EXTEND)
{
nDuration = nDuration *2;
}




	int nTouch 	= TouchAttackRanged(oTarget);


	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target


		if (nTouch != TOUCH_ATTACK_RESULT_MISS)
		{	//Make SR Check
			if(!HkResistSpell(OBJECT_SELF, oTarget))
			{



				//Enter Metamagic conditions
				int nDam = d6(nCasterLevel /2);

				if (HkGetMetaMagicFeat() == METAMAGIC_EMPOWER)
				{
				nDam = nDam + d3(nCasterLevel /2);
				}
				if (HkGetMetaMagicFeat() == METAMAGIC_MAXIMIZE)
				{
				nDam = 6 * (nCasterLevel /2);
				}




				if (nTouch == TOUCH_ATTACK_RESULT_CRITICAL)
				{
					nDam = d6(nCasterLevel);
					nDuration = nDuration *2;
				if (HkGetMetaMagicFeat() == METAMAGIC_EMPOWER)
				{
				nDam = nDam + d3(nCasterLevel);
				}
				if (HkGetMetaMagicFeat() == METAMAGIC_MAXIMIZE)
				{
				nDam = 6 * (nCasterLevel);
				}

					}



				//Set damage effect
				effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
					effect eVis = EffectVisualEffect(VFX_HIT_SPELL_MAGIC);
				effect eKnockdown = EffectKnockdown();
				effect eLink = EffectLinkEffects(eDam,eVis);

				//Apply the VFX impact and damage effect
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);


				if(!HkSavingThrow(SAVING_THROW_FORT, oTarget, HkGetSpellSaveDC()))
				{
				HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, IntToFloat(nDuration));
				}

				}
		}
	}

	effect eRay = EffectBeam(VFX_BEAM_MAGIC, OBJECT_SELF, BODY_NODE_HAND);
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}