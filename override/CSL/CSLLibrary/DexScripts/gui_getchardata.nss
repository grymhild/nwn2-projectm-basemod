// gui_getchardata.nss
/*
Credits
UI hack for extracting character data by Abraxas77
Based on the ideas & work of Raelius Archmannon, BrianMeyer, 2Drunk2Frag, and Mithdradates
Forum Thread: http://nwn2forums.bioware.com/forums/viewtopic.html?topic=630757&forum=114
*/
void main(string sField, string sValue)
{
	//Trim the value string.
	sValue = GetStringRight(sValue, GetStringLength(sValue) - 17);
	
	object oChar = OBJECT_SELF;
	
	//SendMessageToPC(oChar, "Running Script School");
	//SpeakString("Running Script School");
	// Categorize and store the character data for easier retrieval.
	// Assign feats (as Raelius Archmannon suggested) or store in your DB.
	//SendMessageToPC(OBJECT_SELF, sField + " = " + sValue);
	if ( sField == "SCHOOL" ) // don't even bother if the field returned is not school, possibly make this fire once for each field desired
	{
		
		int iTargetSchool = -1;
		// Lets do some validation, this should already be set up correctly, but checking for monkey business
		// If the caster is a specialist some other things should be set as well

		// is the caster a wizard
		if ( GetLevelByClass( CLASS_TYPE_WIZARD, oChar ) > 0 )
		{
			if ( sValue == "Abjuration" && GetHasFeat( FEAT_SPELL_FOCUS_ABJURATION ) )
			{
				iTargetSchool = SPELL_SCHOOL_ABJURATION;
			}
			else if ( sValue == "Conjuration" && GetHasFeat( FEAT_SPELL_FOCUS_CONJURATION ) )
			{
				iTargetSchool = SPELL_SCHOOL_CONJURATION;
			}
			else if ( sValue == "Divination" && GetHasFeat( FEAT_SPELL_FOCUS_DIVINATION ) )
			{
				iTargetSchool = SPELL_SCHOOL_DIVINATION;
			}
			else if ( sValue == "Enchantment" && GetHasFeat( FEAT_SPELL_FOCUS_ENCHANTMENT ) )
			{
				iTargetSchool = SPELL_SCHOOL_ENCHANTMENT;
			}
			else if ( sValue == "Evocation" && GetHasFeat( FEAT_SPELL_FOCUS_EVOCATION ) )
			{
				iTargetSchool = SPELL_SCHOOL_EVOCATION;
			}
			else if ( sValue == "Illusion" && GetHasFeat( FEAT_SPELL_FOCUS_ILLUSION ) )
			{
				iTargetSchool = SPELL_SCHOOL_ILLUSION;
			}
			else if ( sValue == "Necromancy" && GetHasFeat( FEAT_SPELL_FOCUS_NECROMANCY ) )
			{
				iTargetSchool = SPELL_SCHOOL_NECROMANCY;
			}
			else if ( sValue == "Transmutation" && GetHasFeat( FEAT_SPELL_FOCUS_TRANSMUTATION ) )
			{
				iTargetSchool = SPELL_SCHOOL_TRANSMUTATION;
			}
			else
			{
				iTargetSchool = SPELL_SCHOOL_GENERAL;
				if ( GetLevelByClass( CLASS_TYPE_RED_WIZARD, oChar ) > 0 )
				{
					// log message to dms now, we hve an issue, red wizards have to have a speciality.
					// set up benefits so it does not matter too much
				}
			}
			//iTargetSchool = 100;
			SetLocalInt(oChar, "SC_iSpellSchool", iTargetSchool );
		}
	}
	//SetLocalInt(oChar, "SC_iSpellSchool", 99 );
	CloseGUIScreen(OBJECT_SELF, "SCREEN_CHAR_DATA");
}

/*
<!-- List of character data fields (found in characterscreen.xml):
FULLNAME
SUBRACE
ALIGNMENT_TITLE
MAINHAND
MAINHAND_ATTACK_BONUS_STRING
MAINHAND_DAMAGE_STRING
OFFHAND
OFFHAND_ATTACK_BONUS_STRING
OFFHAND_DAMAGE_STRING
BASE_ATTACK
DEITY
PACKAGE
DOMAINS
SCHOOL
SPELL_RESIST
ARCANE_SPELL_FAILURE
ARMOR_CHECK_PENALTY
STRENGTH
STR_TOTAL_BONUS
DEXTERITY
DEX_TOTAL_BONUS
CONSTITUTION
CON_TOTAL_BONUS
INTELLIGENCE
INT_TOTAL_BONUS
WISDOM
WIS_TOTAL_BONUS
CHARISMA
CHA_TOTAL_BONUS
FORT_SAVINGTHROW
REFLEX_SAVINGTHROW
WILL_SAVINGTHROW
EXP_RATIO
HP_RATIO
ARMOR_CLASS
-->
*/