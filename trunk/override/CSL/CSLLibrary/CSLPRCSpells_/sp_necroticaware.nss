//::///////////////////////////////////////////////
//:: Name 	Necrotic Awareness
//:: FileName sp_nec_aware.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Awareness
Necromancy
Level: Clr 1, sor/wiz 1
Components: V S, F
Casting Time: 1 standard action
Range: 60 ft.
Area: Cone-shaped emanation
Duration: Concentration, up to 1 min./level (D)
Saving Throw: None
Spell Resistance: No

You can sense the presence of creatures who bear
a necrotic cyst (see spell of the same name). The
amount of information revealed depends on how long
you remain within range of a creature that triggers
your cyst awareness:

1st Round: Presence or absence of creatures with
necrotic cysts.

2nd Round: Number of creatures bearing
necrotic cysts in the area.

3rd Round: The location ofeach creature bearing a
necrotic cyst. If a cyst-bearer is outside your
line of sight, then you discern its direction but
not its exact location.
*/
// Author: 	Tenjac
// Created: 12/16/05
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//#include "prc_alterations"
//#include "spinc_common"

#include "_HkSpell"
#include "_SCInclude_Necromancy"

void RoundThree(object oCaster, location lTarget);
void RoundTwo(object oCaster, location lTarget);
void RoundOne(object oCaster, location lTarget);

void RoundThree(object oCaster, location lTarget)
{
		//get first
		object oTest = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);

		//loop
		while(GetIsObjectValid(oTest))
		{
				//Check for presence
				if(GetHasNecroticCyst(oTest))
				{
					// 						Name 				has a necrotic cyst
					FloatingTextStringOnCreature(GetName(oTest) + " " + GetStringByStrRef(16829323) + ".", oCaster, FALSE);
				}
				//get next
				oTest = GetNextObjectInShape(SHAPE_SPELLCONE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}

		//Repeat from round one
		//DelayCommand(6.0f,RoundThree(oCaster, lTarget));
}

void RoundTwo(object oCaster, location lTarget)
{
		int nCount=0;

		//get first
		object oTest = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);

		//loop to check all
		while(GetIsObjectValid(oTest))
		{
				//Check for presence
				if(GetHasNecroticCyst(oTest))
				{
					nCount++;
				}
				//next object
				oTest = GetNextObjectInShape(SHAPE_SPELLCONE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);
		}
								//You detect the presence of 			count 					necrotic cysts
		FloatingTextStringOnCreature(GetStringByStrRef(16832001) + " " + IntToString(nCount) + " " + GetStringByStrRef(16829322) + ".", oCaster, FALSE);

		//Schedule next round
		DelayCommand(6.0f, RoundThree(oCaster, lTarget));
}

void RoundOne(object oCaster, location lTarget)
{
		//get first
		object oTest = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0, lTarget, TRUE, OBJECT_TYPE_CREATURE);

		//loop to check all
		while(GetIsObjectValid(oTest))
		{
				//Check for presence
				if(GetHasNecroticCyst(oTest))
				{
					FloatingTextStringOnCreature(GetStringByStrRef(16832001) + " " + GetStringByStrRef(16829322) + ".", oCaster, FALSE);

					//Schedule next round
					DelayCommand(6.0f, RoundTwo(oCaster, lTarget));

					//abort; finding one is enough.
					return;
				}

		}

		//if concentration is broken, abort

		//Re-run round 1 if nothing found
		DelayCommand(6.0f, RoundOne(oCaster, lTarget));
}




void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_NECROTIC_AWARENESS;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//vars
		

		//Check for castability
		if(!GetCanCastNecroticSpells(oCaster))
		{
				return;
		}

		//location
		location lTarget = HkGetSpellTargetLocation();
		if(GetIsObjectValid(HkGetSpellTarget()))
		lTarget = GetLocation(HkGetSpellTarget());

		//Detect
		RoundOne(oCaster, lTarget);

		
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}
