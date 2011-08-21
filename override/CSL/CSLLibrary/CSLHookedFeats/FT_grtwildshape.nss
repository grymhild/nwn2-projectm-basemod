//::///////////////////////////////////////////////
//:: Greater Wild Shape, Humanoid Shape
//:: x2_s2_gwildshp
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Allows the character to shift into one of these
	forms, gaining special abilities

	Credits must be given to mr_bumpkin from the NWN
	community who had the idea of merging item properties
	from weapon and armor to the creatures new forms.

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-02
//:://////////////////////////////////////////////
// AFW-OEI 05/04/2007: Handle Plant Wild Shape, too.

#include "_HkSpell"
#include "_SCInclude_Polymorph"

// just use this constant for now, but revise to use correct one, perhaps without the 1
//     FEAT_GREATER_WILDSHAPE_1


void main()
{
	//scSpellMetaData = SCMeta_FT_grtwildshape();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	if (!GetHasFeat(FEAT_WILD_SHAPE, OBJECT_SELF))
	{
			SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_FEAT_USES);
			return;
	}
	
	if (GetHasSpellEffect(SPELL_Plant_Body))	
	{
		SendMessageToPC(OBJECT_SELF, "Wildshape failed.  The spell Plant Body prevents shifting forms.");
		int nFeatId = GetSpellFeatId();
		IncrementRemainingFeatUses(OBJECT_SELF, nFeatId);
		return;
	}
	
	if( CSLGetPreferenceSwitch("UnlimitedWildshapeUses",FALSE) )
	{
		//int nFeatId = GetSpellFeatId();
		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_WILD_SHAPE);
	}
	
	if ( GetSpellId() == 400 )
	{
		//SendMessageToPC(OBJECT_SELF, "Wildshape Elder air.");

		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		if (GetIsObjectValid(oWeapon))
    	{
			if( GetBaseItemType(oWeapon) == BASE_ITEM_SLING )
			{
				SendMessageToPC(OBJECT_SELF, "Wildshape failed.  This is to block a crash from happening, try without a sling.");
				return;
			}
		}
	}
	
	
	int iLevel = CSLGetWildShapeLevel(oCaster);
	int bElder = ( iLevel >= 20 ); // not really using elder for this...
	float fDuration = HoursToSeconds(iLevel);
	PolyMerge(oCaster, GetSpellId(), fDuration, bElder, TRUE, TRUE);
	
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_WILD_SHAPE);
	
	HkPostCast(oCaster);
}
/*
void mainxxx()
{
	// AFW-OEI 02/28/2007: Early-out if you have no wildshape uses left.
	if (!GetHasFeat(FEAT_WILD_SHAPE, OBJECT_SELF))
	{
			SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_FEAT_USES);
			return;
	}
	
	if (GetHasSpellEffect(SPELL_Plant_Body))	
	{
		SendMessageToPC(OBJECT_SELF, "Wildshape failed.  The spell Plant Body prevents shifting forms.");
		return;
	}
	
	int nSubrace = GetSubRace(OBJECT_SELF);
	
	int nWisBonus = GetAbilityScore(OBJECT_SELF, ABILITY_WISDOM, FALSE) - GetAbilityScore(OBJECT_SELF, ABILITY_WISDOM, TRUE);
	int nIntBonus = GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE, FALSE) - GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE, TRUE);
	int nChaBonus = GetAbilityScore(OBJECT_SELF, ABILITY_CHARISMA, FALSE) - GetAbilityScore(OBJECT_SELF, ABILITY_CHARISMA, TRUE);


	//--------------------------------------------------------------------------
	// Declare major variables
	//--------------------------------------------------------------------------
	int    iSpellId = GetSpellId();
	object oTarget = HkGetSpellTarget();
	effect eVis = EffectVisualEffect(VFX_DUR_POLYMORPH);
	//int    nShifter = GetLevelByClass(CLASS_TYPE_SHIFTER);
	effect ePoly;
	int    nPoly;

	// Feb 13, 2004, Jon: Added scripting to take care of case where it's an NPC
	// using one of the feats. It will randomly pick one of the shapes associated
	// with the feat.
	switch(iSpellId)
	{
			// Greater Wildshape I
			case 646: iSpellId = Random(5)+658; break;
			// Greater Wildshape II
			case 675: switch(Random(3))
						{
							case 0: iSpellId = 672; break;
							case 1: iSpellId = 678; break;
							case 2: iSpellId = 680;
						}
						break;
			// Greater Wildshape III
			case 676: switch(Random(3))
						{
							case 0: iSpellId = 670; break;
							case 1: iSpellId = 673; break;
							case 2: iSpellId = 674;
						}
						break;
			// Greater Wildshape IV
			case 677: switch(Random(3))
						{
							case 0: iSpellId = 679; break;
							case 1: iSpellId = 691; break;
							case 2: iSpellId = 694;
						}
						break;
			// Humanoid Shape
			case 681:  iSpellId = Random(3)+682; break;
			// Undead Shape
			case 685:  iSpellId = Random(3)+704; break;
			// Dragon Shape
			case 725:  iSpellId = Random(3)+707; break;
			// Outsider Shape
			case 732:  iSpellId = Random(3)+733; break;
			// Construct Shape
			case 737:  iSpellId = Random(3)+738; break;
			// Magical Beast Wild Shape
			case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE:
				iSpellId = Random(3)+SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_CELESTIAL_BEAR; break;
		// Plant Wild Shape
		case SPELLABILITY_PLANT_WILD_SHAPE:
			iSpellId = Random(2) + SPELLABILITY_PLANT_WILD_SHAPE_SHAMBLING_MOUND; break; // 2 forms to choose from
	}

	//--------------------------------------------------------------------------
	// Determine which form to use based on spell id, gender and level
	//--------------------------------------------------------------------------
	switch (iSpellId)
	{
			/*
			//-----------------------------------------------------------------------
			// Greater Wildshape I - Wyrmling Shape
			//-----------------------------------------------------------------------
			case 658:  nPoly = POLYMORPH_TYPE_WYRMLING_RED; break;
			case 659:  nPoly = POLYMORPH_TYPE_WYRMLING_BLUE; break;
			case 660:  nPoly = POLYMORPH_TYPE_WYRMLING_BLACK; break;
			case 661:  nPoly = POLYMORPH_TYPE_WYRMLING_WHITE; break;
			case 662:  nPoly = POLYMORPH_TYPE_WYRMLING_GREEN; break;

			//-----------------------------------------------------------------------
			// Greater Wildshape II  - Minotaur, Gargoyle, Harpy
			//-----------------------------------------------------------------------
			case 672: if (nShifter < X2_GW2_EPIC_THRESHOLD)
							nPoly = POLYMORPH_TYPE_HARPY;
						else
							nPoly = 97;
						break;

			case 678: if (nShifter < X2_GW2_EPIC_THRESHOLD)
							nPoly = POLYMORPH_TYPE_GARGOYLE;
						else
							nPoly = 98;
						break;

			case 680: if (nShifter < X2_GW2_EPIC_THRESHOLD)
							nPoly = POLYMORPH_TYPE_MINOTAUR;
						else
							nPoly = 96;
						break;

			//-----------------------------------------------------------------------
			// Greater Wildshape III  - Drider, Basilisk, Manticore
			//-----------------------------------------------------------------------
			case 670: if (nShifter < X2_GW3_EPIC_THRESHOLD)
							nPoly = POLYMORPH_TYPE_BASILISK;
						else
							nPoly = 99;
						break;

			case 673: if (nShifter < X2_GW3_EPIC_THRESHOLD)
							nPoly = POLYMORPH_TYPE_DRIDER;
						else
							nPoly = 100;
						break;

			case 674: if (nShifter < X2_GW3_EPIC_THRESHOLD)
							nPoly = POLYMORPH_TYPE_MANTICORE;
						else
							nPoly = 101;
						break;

		//-----------------------------------------------------------------------
		// Greater Wildshape IV - Dire Tiger, Medusa, MindFlayer
		//-----------------------------------------------------------------------
			case 679: nPoly = POLYMORPH_TYPE_MEDUSA; break;
			case 691: nPoly = 68; break; // Mindflayer
			case 694: nPoly = 69; break; // DireTiger


		//-----------------------------------------------------------------------
		// Humanoid Shape - Kobold Commando, Drow, Lizard Crossbow Specialist
		//-----------------------------------------------------------------------
		case 682:
						if(nShifter< 17)
						{
							if (GetGender(OBJECT_SELF) == GENDER_MALE) //drow
								nPoly = 59;
							else
								nPoly = 70;
						}
						else
						{
							if (GetGender(OBJECT_SELF) == GENDER_MALE) //drow
								nPoly = 105;
							else
								nPoly = 106;
						}
						break;
		case 683:
						if(nShifter< 17)
						{
							nPoly = 82; break; // Lizard
						}
						else
						{
							nPoly =104; break; // Epic Lizard
						}
		case 684: if(nShifter< 17)
						{
							nPoly = 83; break; // Kobold Commando
						}
						else
						{
							nPoly = 103; break; // Kobold Commando
						}

		//-----------------------------------------------------------------------
		// Undead Shape - Spectre, Risen Lord, Vampire
		//-----------------------------------------------------------------------
		case 704: nPoly = 75; break; // Risen lord

		case 705: if (GetGender(OBJECT_SELF) == GENDER_MALE) // vampire
							nPoly = 74;
						else
							nPoly = 77;
						break;

		case 706: nPoly = 76; break; /// spectre
		* /
		//-----------------------------------------------------------------------
		// Dragon Shape - Red, Blue, and Black Dragons
		//-----------------------------------------------------------------------
		case 707: nPoly = POLYMORPH_TYPE_RED_DRAGON; break;    // Red Dragon
		case 708: nPoly = POLYMORPH_TYPE_BLUE_DRAGON; break;   // Blue Dragon
		case 709: nPoly = POLYMORPH_TYPE_BLACK_DRAGON; break;  // Black Dragon

		//-----------------------------------------------------------------------
		// Outsider Shape - Rakshasa, Azer Chieftain, Black Slaad
		//-----------------------------------------------------------------------
		case 733:   if (GetGender(OBJECT_SELF) == GENDER_MALE) //azer
							nPoly = 85;
							else // anything else is female
							nPoly = 86;
							break;

		case 734:   if (GetGender(OBJECT_SELF) == GENDER_MALE) //rakshasa
							nPoly = 88;
							else // anything else is female
							nPoly = 89;
							break;

		case 735: nPoly =87; break; // slaad

		//-----------------------------------------------------------------------
		// Construct Shape - Stone Golem, Iron Golem, Demonflesh Golem
		//-----------------------------------------------------------------------
		case 738: nPoly =91; break; // stone golem
		case 739: nPoly =92; break; // demonflesh golem
		case 740: nPoly =90; break; // iron golem

		//-----------------------------------------------------------------------
		// Magical Beast Wild Shape - Celestial Leopard, Phase Spider, Winter Wolf
		//-----------------------------------------------------------------------
		case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_CELESTIAL_BEAR:
				nPoly = POLYMORPH_TYPE_CELESTIAL_LEOPARD; break;    // Celestial Leopard; yes, everything says bear, but we don't have a bear in NX1
		case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_PHASE_SPIDER:
				nPoly = POLYMORPH_TYPE_PHASE_SPIDER; break;      // Phase Spider
		case SPELLABILITY_MAGICAL_BEAST_WILD_SHAPE_WINTER_WOLF:
				nPoly = POLYMORPH_TYPE_WINTER_WOLF; break;       // Winter Wolf
			
		//-----------------------------------------------------------------------
		// Plant Wild Shape -- Shambling Mound, Treant
		//-----------------------------------------------------------------------
		case SPELLABILITY_PLANT_WILD_SHAPE_SHAMBLING_MOUND:
				nPoly = POLYMORPH_TYPE_SHAMBLING_MOUND; break;    // Shambling Mound
		case SPELLABILITY_PLANT_WILD_SHAPE_TREANT:
				nPoly = POLYMORPH_TYPE_TREANT; break;      // Treant

	}


	//--------------------------------------------------------------------------
	// Determine which items get their item properties merged onto the shifters
	// new form.
	//--------------------------------------------------------------------------
	///* AFW-OEI 02/28/2007: No more shifter stuff
	//int bWeapon = ShifterMergeWeapon(nPoly);
	//int bArmor  = ShifterMergeArmor(nPoly);
	//int bItems  = ShifterMergeItems(nPoly);
	//* /
	
	//--------------------------------------------------------------------------
	// Determine which items get their item properties merged onto the new form.
	//--------------------------------------------------------------------------
	int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",nPoly)) == 1;
	int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",nPoly)) == 1;
	int bItems  = StringToInt(Get2DAString("polymorph","MergeI",nPoly)) == 1;

	//--------------------------------------------------------------------------
	// Store the old objects so we can access them after the character has
	// changed into his new form
	//--------------------------------------------------------------------------
	object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST,OBJECT_SELF);
	object oRing1Old  = GetItemInSlot(INVENTORY_SLOT_LEFTRING,OBJECT_SELF);
	object oRing2Old  = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,OBJECT_SELF);
	object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,OBJECT_SELF);
	object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,OBJECT_SELF);
	object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,OBJECT_SELF);
	object oBeltOld   = GetItemInSlot(INVENTORY_SLOT_BELT,OBJECT_SELF);
	object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,OBJECT_SELF);
	object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,OBJECT_SELF);

	if (GetIsObjectValid(oShield))
	{
			if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
				GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
				GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
			{
				oShield = OBJECT_INVALID;
			}
	}


	//--------------------------------------------------------------------------
	// Here the actual polymorphing is done
	//--------------------------------------------------------------------------
	ePoly = EffectPolymorph(nPoly, FALSE, TRUE); // AFW-OEI 06/06/2007: Use 3rd boolean to say this is a wildshape polymorph.
	ePoly = ExtraordinaryEffect(ePoly);
	ClearAllActions(); // prevents an exploit
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF);
	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

	//--------------------------------------------------------------------------
	// This code handles the merging of item properties
	//--------------------------------------------------------------------------
	object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
	object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

	//identify weapon
	SetIdentified(oWeaponNew, TRUE);

	//--------------------------------------------------------------------------
	// ...Weapons
	//--------------------------------------------------------------------------
	if (bWeapon)
	{
			CSLWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
	}

	//--------------------------------------------------------------------------
	// ...Armor
	//--------------------------------------------------------------------------
	if (bArmor)
	{
			//----------------------------------------------------------------------
			// Merge item properties from armor and helmet...
			//----------------------------------------------------------------------
			CSLWildShapeCopyItemProperties(oArmorOld,oArmorNew);
			CSLWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
			CSLWildShapeCopyItemProperties(oShield,oArmorNew);
	}

	//--------------------------------------------------------------------------
	// ...Magic Items
	//--------------------------------------------------------------------------
	if (bItems)
	{
			//----------------------------------------------------------------------
			// Merge item properties from from rings, amulets, cloak, boots, belt
			//----------------------------------------------------------------------
			CSLWildShapeCopyItemProperties(oRing1Old,oArmorNew);
			CSLWildShapeCopyItemProperties(oRing2Old,oArmorNew);
			CSLWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
			CSLWildShapeCopyItemProperties(oCloakOld,oArmorNew);
			CSLWildShapeCopyItemProperties(oBootsOld,oArmorNew);
			CSLWildShapeCopyItemProperties(oBeltOld,oArmorNew);
	}

	//--------------------------------------------------------------------------
	// Set artificial usage limits for special ability spells to work around
	// the engine limitation of not being able to set a number of uses for
	// spells in the polymorph radial
	//--------------------------------------------------------------------------
	//ShifterSetGWildshapeSpellLimits(iSpellId);  // AFW-OEI 02/28/2007: No more shifter stuff

		float fDuration =  HkApplyDurationCategory(3, SC_DURCATEGORY_DAYS);	
	object oBracer = GetItemInSlot(INVENTORY_SLOT_ARMS,OBJECT_SELF);	
	//Allow jewelery to affect wildshape per pnp	
    CSLWildShapeCopyItemProperties(oRing1Old,oArmorNew);
    CSLWildShapeCopyItemProperties(oRing2Old,oArmorNew);
    CSLWildShapeCopyItemProperties(oAmuletOld,oArmorNew);	
    if (GetIsObjectValid(oBracer))	
	{
		if (GetBaseItemType(oBracer) == BASE_ITEM_BRACER)
			CSLWildShapeCopyItemProperties(oBracer,oArmorNew);
	}
	
	PolyApplyClassFeats( fDuration );
	
	
	//Fix for Spell Slot loss	
	object oCursedPolyItem = CreateItemOnObject("cmi_cursedpoly",OBJECT_SELF,1,"",FALSE);
	if (oCursedPolyItem == OBJECT_INVALID)
		SendMessageToPC(OBJECT_SELF, "Your Inventory was full so bonus spell slots from items and racial spellcasting stat modifiers will not survive the transition to your new form.");
	
	SCAddSpellSlotsToObject(oWeaponOld,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oArmorOld,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oRing1Old,oCursedPolyItem, fDuration);
	SCAddSpellSlotsToObject(oRing2Old,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oAmuletOld,oCursedPolyItem, fDuration);
	SCAddSpellSlotsToObject(oCloakOld,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oBootsOld,oCursedPolyItem, fDuration);			
	SCAddSpellSlotsToObject(oBeltOld,oCursedPolyItem, fDuration);
	SCAddSpellSlotsToObject(oHelmetOld,oCursedPolyItem, fDuration);	
	SCAddSpellSlotsToObject(oShield,oCursedPolyItem, fDuration);
	
	if (nWisBonus > 12)
		nWisBonus = 12;	
	if (nIntBonus > 12)
		nIntBonus = 12;	
	if (nChaBonus > 12)
		nChaBonus = 12;	
						
	itemproperty ipNewEnhance = ItemPropertyAbilityBonus(IP_CONST_ABILITY_WIS, nWisBonus);  	  
	CSLSafeAddItemProperty(oCursedPolyItem, ipNewEnhance,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	ipNewEnhance = ItemPropertyAbilityBonus(IP_CONST_ABILITY_INT, nIntBonus);  	  
	CSLSafeAddItemProperty(oCursedPolyItem, ipNewEnhance,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);

	ipNewEnhance = ItemPropertyAbilityBonus(IP_CONST_ABILITY_CHA, nChaBonus);  	  
	CSLSafeAddItemProperty(oCursedPolyItem, ipNewEnhance,fDuration, SC_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);							
		
	PolyApplyNatureWarrior( oAmuletOld, fDuration);  
	    
	SCWildshapeCheck(OBJECT_SELF,oCursedPolyItem);
	//--------------------------------------------------------------------------
	// Decrement wildshape uses
	//--------------------------------------------------------------------------
	DecrementRemainingFeatUses(OBJECT_SELF, FEAT_WILD_SHAPE);
}
*/