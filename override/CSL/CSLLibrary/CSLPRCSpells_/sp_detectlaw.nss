/*
Detect Evil

Divination
Level: Clr 1, Rgr 2
Components: V, S, DF
Casting Time: 1 action
Range: 60 ft.
Area: Quarter circle emanating from you
to the extreme of the range
Duration: Concentration, up to 10
minutes/level (D)
Saving Throw: None
Spell Resistance: No

You can sense the presence of evil. The amount of information revealed depends
on how long you study a particular area or subject:
1st Round: Presence or absence of evil.
2nd Round: Number of evil auras (creatures, objects, or spells) in the area and
the strength of the strongest evil aura present. If you are of good alignment, the strongest evil aura's strength is
"overwhelming" (see below), and the strength is at least twice your character
level, you are stunned for 1 round and the spell ends. While you are stunned, you
can't act, you lose any Dexterity bonus to AC, and attackers gain +2 bonuses to attack
you.
3rd Round: The strength and location of each aura. If an aura is outside your line of
sight, then you discern its direction but not its exact location.

Aura Strength: An aura's evil power and strength depend on the type of evil
creature or object that you're detecting and its HD, caster level, or (in the case of a
cleric) class level.

Creature/Object 	Evil Power
Evil creature 		HD / 5
Undead creature 	HD / 2
Evil elemental 		HD / 2
Evil outsider 		HD
Cleric of an evil deity 	Caster Level

Evil Power 	Aura Strength
Lingering 		Dim
1 or less 		Faint
2'4 		Moderate
5'10 		Strong
11+ 		Overwhelming
If an aura falls into more than one strength category, the spell indicates the stronger of
the two.

Remember that animals, traps, poisons, and other potential perils are not evil; this
spell does not detect them.

Note: Each round, you can turn to detect things in a new area but if you move
more than 2 meters the spell ends. The spell can penetrate barriers, but 1 foot
of stone, 1 inch of common metal, a thin sheet of lead, or 3 feet of wood or dirt
blocks it.

*/
//#include "prc_inc_s_det"


#include "_HkSpell"

void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DETECT_LAW;
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_DIVINATION, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	location lTarget = HkGetSpellTargetLocation();
	if(GetIsObjectValid(HkGetSpellTarget()))
		lTarget = GetLocation(HkGetSpellTarget());
	// 											"lawful"
	DetectAlignmentRound(0, lTarget, -1, ALIGNMENT_LAWFUL, GetStringByStrRef(4954), VFX_BEAM_MIND);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );

}