//::///////////////////////////////////////////////
//:: x0_s3_gemspray
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
For Wand of Wonder
This script fires when gem spray ability from wand is activated
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
// Gems go flying out in a cone. All targets in the area take d4() damage
// for each of 1-5 gems, and end up with that number of gems in their
// inventory. Reflex save halves damage.
//#include "x0_i0_spells"
// Gems go flying out in a cone. All targets in the area take d4() damage
// for each of 1-5 gems, and end up with that number of gems in their
// inventory. Reflex save halves damage.


#include "_HkSpell"


void DoFlyingGems(object oCaster, location lTarget);

void DoFlyingGems(object oCaster, location lTarget)
{
	int nMetaMagic = HkGetMetaMagicFeat();
	vector vOrigin = GetPosition(oCaster);
	int nGems, nDamage, nRand, i;
	
	float fDelay;
	float fMaxDelay = 0.0f; // Used to determine the duration of the flame cone

	object oTarget = GetFirstObjectInShape(SHAPE_CONE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
	while (GetIsObjectValid(oTarget))
	{
		if ( oTarget != oCaster && CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
		{	
			
			SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE ));
			fDelay = 2.0f + GetDistanceBetween(oCaster, oTarget)/20;
			fMaxDelay = CSLGetMaxf(fMaxDelay, fDelay);
			
			nGems = HkApplyMetamagicVariableMods(Random(5) + 1, 5);
			nDamage = 0;
			for (i=0; i < nGems; i++)
			{
				// Create the gems on the target
				string sResRef = "nw_it_gem0";
				nRand = Random(20);
				if (nRand == 0)
				{
					sResRef += "11"; // topaz, a nice windfall
				}
				else if (nRand < 7)
				{
					sResRef += "02";
				}
				else if (nRand < 14)
				{
					sResRef += "05";
				}
				else
				{
					sResRef += "08";
				}
				object oGem = CreateItemOnObject(sResRef,
				oTarget);
				if (GetIsObjectValid(oGem) == FALSE)
				{
					sResRef = GetStringUpperCase(sResRef);
					oGem = CreateItemOnObject(sResRef, oTarget);
					if (GetIsObjectValid(oGem) == FALSE)
					{
					// SpeakString("Gem " + sResRef + " is invalid");
					}
				}
				
				nDamage += HkApplyMetamagicVariableMods( d4(), 4);
				
				
			}
			nDamage = GetReflexAdjustedDamage(nDamage, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_ALL);
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING), oTarget));
		}
		oTarget = GetNextObjectInShape(SHAPE_CONE, 11.0, lTarget, TRUE, OBJECT_TYPE_CREATURE, vOrigin);
	}
	//fMaxDelay += 0.5f;
	//ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFXSC_DUR_SPELLCONEHAND_GEMS ), oCaster, fMaxDelay);
	if (DEBUGGING >= 4) { CSLDebug(  "DoFlyingGems: Doing Cone Effect Now "+FloatToString( fMaxDelay ), oCaster ); }
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFXSC_DUR_SPELLCONEHAND_GEMS), oCaster, fMaxDelay+0.5);

}


void main ()
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
	int iAttributes = -1;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	
	DoFlyingGems( oCaster, HkGetSpellTargetLocation() );
	
	HkPostCast(oCaster);
}