#include "elu_functions_i"

void main()
{
	//If this is not the first time the char has gained the Summon Familiar feat AND
	//the char has added a feat which enables choosing a new familiar, then show the familiar screen
	object oControlledChar = GetControlledCharacter(OBJECT_SELF);

	//Filter Feats:
	//
	//Familiars
	//IMPROVED FAMILIAR 8987
	//ELEMENTAL FAMILIAR 8991
	//CRAFT CONSTRUCT 8989

	int bOpenFamiliarScreen = HasAsAddedFeat(oControlledChar, 8987); //check for Improved Familiar Feat
	if (!bOpenFamiliarScreen)
		bOpenFamiliarScreen = HasAsAddedFeat(oControlledChar, 8991); //check for Elemental Familiar Feat


	if (!bOpenFamiliarScreen && (GetHasFeat(FEAT_SUMMON_FAMILIAR, oControlledChar, TRUE) || HasAsAddedFeat(oControlledChar, FEAT_SUMMON_FAMILIAR)))
		bOpenFamiliarScreen = HasAsAddedFeat(oControlledChar, 8989); //check for Craft Construct Feat

	if (!bOpenFamiliarScreen && GetHasFeat(8989, oControlledChar, TRUE) && HasAsAddedFeat(oControlledChar, FEAT_SUMMON_FAMILIAR))
		bOpenFamiliarScreen = TRUE;

	//Animal Companions
	//IMPROVED COMPANION 2168
	//ELEMENTAL COMPANION 8990
	//DRAGON COMPANION 8988
	//TELTHOR COMPANION 3704
	int bOpenAnimalCompanionScreen = HasAsAddedFeat(oControlledChar, 2168); //check for Improved Companion
	if (!bOpenAnimalCompanionScreen)
		bOpenAnimalCompanionScreen = HasAsAddedFeat(oControlledChar, 8990); //check for Elemental Companion Feat
	if (!bOpenAnimalCompanionScreen)
		bOpenAnimalCompanionScreen = HasAsAddedFeat(oControlledChar, 8988); //check for Dragon Companion Feat

	if (!bOpenAnimalCompanionScreen)
		bOpenAnimalCompanionScreen = HasAsAddedFeat(oControlledChar, 3704); //check for Telthor Companion Feat

	//If the Animal Companion feat itself was added, do not force open the Animal Companion screen, it will open on its own.
	if (HasAsAddedFeat(oControlledChar, FEAT_ANIMAL_COMPANION))
		bOpenAnimalCompanionScreen = FALSE;

	if (bOpenFamiliarScreen)
		DisplayGuiScreen(OBJECT_SELF, "SCREEN_LEVELUP_FAMILIARX3", TRUE, "levelup_familiarx3.xml");
		
	if (bOpenAnimalCompanionScreen)
		DisplayGuiScreen(OBJECT_SELF, "SCREEN_LEVELUP_ANIMAL", TRUE);
}