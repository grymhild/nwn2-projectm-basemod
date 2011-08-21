/*! \mainpage Community Script (CSL) Library Documentation
*
* \section intro_sec Introduction
*
* The Community Script Library Project is a library of code designed a solid foundation for the entire community to build upon.
*
* <b>Sources of this code include:</b>
* <list type="bullet"><item> OEI and Bioware Code for the game, rewritten and cleaned up to remove many errors and to make things easier to find.
* <item> Community Projects such as DMFI, HCR2, Spellcasting Framework, Kaedrins Class pack, Spell Compendium, PRC, Tome of Battle
* <item> Major PW's such as Cerea2, Khaladine, ALFA, Sea of Dragons, Dungeon Eternal 
* <item> Other programming languages such as PHP, Basic, Javascript, C
* <item> Numerous code snippets posted on the Bioware forums or which were requested by the community
* <item> Discussions and finished code from the Citadel, on IRC, and many other sources
* </list>
*
* It has a very well rounded set of available functions, organized as one project soas it can all work together. To a large degree much stock code that came with the game can be avoided and this used instead.
*
*
* <b>This project is organized as follows:</b>
*
* Reference for core nwscript functions
* \ref nwscript_i.nss "Includes"
* \ref nwscript_c.nss "Constants"
*
* \ref cslcore "Community Script Library" 
* The Core is the CSL Commmon Script Library. ( Files are all named _CSLCore_*.nss )
*
* &nbsp;&nbsp;&nbsp;<b>Configuration</b>
* \ref _CSLCore_Config.nss
*
* &nbsp;&nbsp;&nbsp;<b>Programming Tools</b>
* \ref _CSLCore_Math.nss "Math"
* \ref _CSLCore_Strings.nss "Strings"
* \ref _CSLCore_ObjectVars.nss "ObjectVars"
* \ref _CSLCore_Position.nss "Position"
* \ref _CSLCore_Messages.nss "Messages"
* \ref _CSLCore_UI.nss "User Interface"
*
* &nbsp;&nbsp;&nbsp;<b>Spell Properties</b>
* \ref _CSLCore_Attributes.nss "Attributes"
* \ref _CSLCore_Descriptor.nss "Descriptors"
*
* &nbsp;&nbsp;&nbsp;<b>NWN2 Specific</b>
* \ref _CSLCore_Magic.nss "Magic"
* \ref _CSLCore_Appearance.nss "Appearance"
* \ref _CSLCore_Visuals.nss "Visuals"
* \ref _CSLCore_Info.nss "Info"
* \ref _CSLCore_Items.nss "Items"
* \ref _CSLCore_Reputation.nss "Reputation"
* \ref _CSLCore_Player.nss "Player"
* \ref _CSLCore_Time.nss "Time"
* \ref _CSLCore_Feats.nss "Feats"
*
* &nbsp;&nbsp;&nbsp;<b>New Feature Implementation</b>
* \ref _CSLCore_Class.nss "Class"
* \ref _CSLCore_Combat.nss "Combat"
* \ref _CSLCore_Environment.nss "Environment"
*
*
* <b>HkSpell Function Wrappers</b> Overriding the engine in spells to fix bugs and add new features.
*
* &nbsp;&nbsp;&nbsp; \ref _HkSpell.nss "_HkSpell.nss"
*
* <b>Includes</b> Basic Include files for implementing special features or to use instead of the default includes. ( Files are all named _SCInclude_*.nss )
* 
* &nbsp;&nbsp;&nbsp; <b>Spell Related<b>
* \ref _SCInclude_Abjuration.nss "Abjuration"
* \ref _SCInclude_Transmutation.nss "Transmutation"
* \ref _SCInclude_Evocation.nss "Evocation"
* \ref _SCInclude_Necromancy.nss "Necromancy"
* \ref _SCInclude_Invocations.nss "Invocations"
* \ref _SCInclude_Songs.nss "Songs"
* \ref _SCInclude_Epic.nss "Epic"
* \ref _SCInclude_Summon.nss "Summon"
* \ref _SCInclude_Polymorph.nss "Polymorph"
* \ref _SCInclude_Invisibility.nss "Invisibility"
* \ref _SCInclude_Healing.nss "Healing"
* \ref _SCInclude_AbilityBuff.nss "AbilityBuff"
*
* &nbsp;&nbsp;&nbsp; <b>DMFI Related</b>
* \ref _SCInclude_DMFI.nss "DMFI"
* \ref _SCInclude_DMAppear.nss "DMAppear"
* \ref _SCInclude_DMInven.nss "DMInven"
* \ref _SCInclude_DMFIComm.nss "DMFIComm"
* \ref _SCInclude_CharEdit.nss "CharEdit"
* \ref _SCInclude_Language.nss "Language"
* \ref _SCInclude_Playerlist.nss "Playerlist"
* \ref _SCInclude_Chat.nss "Chat"
*
* &nbsp;&nbsp;&nbsp;<b>Caster Statistics</b>
* \ref _SCInclude_CacheStats.nss "CacheStats"
*
* &nbsp;&nbsp;&nbsp;<b>Classes and Feats</b>
* \ref _SCInclude_Class.nss "Class"
* \ref _SCInclude_BarbRage.nss "BarbRage"
* \ref _SCInclude_ArcaneArcher.nss "ArcaneArcher"
* \ref _SCInclude_Reserve.nss "Reserve"
* \ref _SCInclude_TomeBattle.nss "TomeBattle"
* \ref _SCInclude_AmmoBox.nss "AmmoBox"
*
* &nbsp;&nbsp;&nbsp;<b>Module</b>
* \ref _SCInclude_Events.nss "Events"
* \ref _SCInclude_Arena.nss "Arena"
* \ref _SCInclude_Battle.nss "Battle"
* \ref _SCInclude_Doors.nss "Doors"
* \ref _SCInclude_Faction.nss "Faction"
* \ref _SCInclude_Quest.nss "Quest"
* \ref _SCInclude_Monster.nss "Monster"
* \ref _SCInclude_RandomMonster.nss "RandomMonster"
* \ref _SCInclude_Encounter.nss "Encounter"
*
* &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \ref _SCInclude_Trap.nss "Trap"
* \ref _SCInclude_Treasure.nss "Treasure"
* \ref _SCInclude_Saveuses.nss "Saveuses"
* \ref _SCInclude_DeckOfMany.nss "DeckOfMany"
* \ref _SCInclude_SpiritEater.nss "SpiritEater"
* \ref _SCInclude_MagicStone.nss "MagicStone"
* \ref _SCInclude_Healer.nss "Healer"
*
* &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \ref _SCInclude_UnlimitedAmmo.nss "UnlimitedAmmo"
* \ref _SCInclude_WildEffects.nss "WildEffects"
* \ref _SCInclude_Graves.nss "Graves"
* \ref _SCInclude_IntWeapon.nss "IntWeapon"
* \ref _SCInclude_Light.nss "Light"
*
* &nbsp;&nbsp;&nbsp; <b>In Progress</b>
* \ref _SCInclude_Clock.nss "Clock"
* \ref _SCInclude_Artillery.nss "Artillery"
* \ref _SCInclude_Effects.nss "Effects"
* \ref _SCInclude_Weather.nss "Weather"
* \ref _SCInclude_Macro.nss "Macro"
* \ref _SCInclude_Mode.nss "Mode"
*
* Included are the following vanilla game includes, everything else is designed to only use the core libraries with much official content refactored to replace what comes with the game.:
*   x2_inc_switches
*   x0_i0_campaign
* Other includes will be removed as found, as it's important to make the library separate to avoid major issues with each include including more hidden includes.
*
*/

 
/** @defgroup  cslcore
* @name Common Script Library (CSL)
* @brief Common Script Library Core Include Files
*
* The Core is the CSL Commmon Script Library. ( Files are all named _CSLCore_*.nss )
*
* &nbsp;&nbsp;&nbsp;<b>Configuration</b>
* \ref _CSLCore_Config.nss
*
* &nbsp;&nbsp;&nbsp;<b>Programming Tools</b>
* \ref _CSLCore_Math.nss "Math"
* \ref _CSLCore_Strings.nss "Strings"
* \ref _CSLCore_ObjectVars.nss "ObjectVars"
* \ref _CSLCore_Position.nss "Position"
* \ref _CSLCore_Messages.nss "Messages"
* \ref _CSLCore_UI.nss "User Interface"
*
* &nbsp;&nbsp;&nbsp;<b>Spell Properties</b>
* \ref _CSLCore_Attributes.nss "Attributes"
* \ref _CSLCore_SubSchool.nss "Subschool"
* \ref _CSLCore_Descriptor.nss "Descriptors"
*
* &nbsp;&nbsp;&nbsp;<b>NWN2 Specific</b>
* \ref _CSLCore_Appearance.nss "Appearance"
* \ref _CSLCore_Visuals.nss "Visuals"
* \ref _CSLCore_Info.nss "Info"
* \ref _CSLCore_Items.nss "Items"
* \ref _CSLCore_Reputation.nss "Reputation"
* \ref _CSLCore_Player.nss "Player"
* \ref _CSLCore_Time.nss "Time"
* \ref _CSLCore_Magic.nss "Magic"
* \ref _CSLCore_Feats.nss "Feats"
*
* &nbsp;&nbsp;&nbsp;<b>New Feature Implementation</b>
* \ref _CSLCore_Class.nss "Class"
* \ref _CSLCore_Combat.nss "Combat"
* \ref _CSLCore_Environment.nss "Environment"
*
* @author Brian T. Meyer and others
*/


/** @defgroup  scinclude
* @name Support Spell Code Include(SC)
* @brief Common Script Library Support spell includes
*
* <b>Includes</b> Basic Include files for implementing special features or to use instead of the default includes. ( Files are all named _SCInclude_*.nss )
* 
* &nbsp;&nbsp;&nbsp; <b>Spell Related<b>
* \ref _SCInclude_Abjuration.nss "Abjuration"
* \ref _SCInclude_Transmutation.nss "Transmutation"
* \ref _SCInclude_Evocation.nss "Evocation"
* \ref _SCInclude_Necromancy.nss "Necromancy"
* \ref _SCInclude_Invocations.nss "Invocations"
* \ref _SCInclude_Songs.nss "Songs"
* \ref _SCInclude_Epic.nss "Epic"
* \ref _SCInclude_Summon.nss "Summon"
* \ref _SCInclude_Polymorph.nss "Polymorph"
* \ref _SCInclude_Invisibility.nss "Invisibility"
* \ref _SCInclude_Healing.nss "Healing"
* \ref _SCInclude_AbilityBuff.nss "AbilityBuff"
*
* &nbsp;&nbsp;&nbsp; <b>DMFI Related</b>
* \ref _SCInclude_DMFI.nss "DMFI"
* \ref _SCInclude_DMAppear.nss "DMAppear"
* \ref _SCInclude_DMInven.nss "DMInven"
* \ref _SCInclude_DMFIComm.nss "DMFIComm"
* \ref _SCInclude_CharEdit.nss "CharEdit"
* \ref _SCInclude_Language.nss "Language"
* \ref _SCInclude_Playerlist.nss "Playerlist"
* \ref _SCInclude_Chat.nss "Chat"
*
* &nbsp;&nbsp;&nbsp;<b>Caster Statistics</b>
* \ref _SCInclude_CacheStats.nss "CacheStats"
*
* &nbsp;&nbsp;&nbsp;<b>Classes and Feats</b>
* \ref _SCInclude_Class.nss "Class"
* \ref _SCInclude_BarbRage.nss "BarbRage"
* \ref _SCInclude_ArcaneArcher.nss "ArcaneArcher"
* \ref _SCInclude_Reserve.nss "Reserve"
* \ref _SCInclude_TomeBattle.nss "TomeBattle"
* \ref _SCInclude_AmmoBox.nss "AmmoBox"
*
* &nbsp;&nbsp;&nbsp;<b>Module</b>
* \ref _SCInclude_Events.nss "Events"
* \ref _SCInclude_Arena.nss "Arena"
* \ref _SCInclude_Battle.nss "Battle"
* \ref _SCInclude_Doors.nss "Doors"
* \ref _SCInclude_Faction.nss "Faction"
* \ref _SCInclude_Quest.nss "Quest"
* \ref _SCInclude_Monster.nss "Monster"
* \ref _SCInclude_RandomMonster.nss "RandomMonster"
* \ref _SCInclude_Encounter.nss "Encounter"
*
* &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \ref _SCInclude_Trap.nss "Trap"
* \ref _SCInclude_Treasure.nss "Treasure"
* \ref _SCInclude_Saveuses.nss "Saveuses"
* \ref _SCInclude_DeckOfMany.nss "DeckOfMany"
* \ref _SCInclude_SpiritEater.nss "SpiritEater"
* \ref _SCInclude_MagicStone.nss "MagicStone"
* \ref _SCInclude_Healer.nss "Healer"
*
* &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; \ref _SCInclude_UnlimitedAmmo.nss "UnlimitedAmmo"
* \ref _SCInclude_WildEffects.nss "WildEffects"
* \ref _SCInclude_Graves.nss "Graves"
* \ref _SCInclude_IntWeapon.nss "IntWeapon"
* \ref _SCInclude_Light.nss "Light"
*
* &nbsp;&nbsp;&nbsp; <b>In Progress</b>
* \ref _SCInclude_Clock.nss "Clock"
* \ref _SCInclude_Effects.nss "Effects"
* \ref _SCInclude_Artillery.nss "Artillery"
* \ref _SCInclude_Weather.nss "Weather"
* \ref _SCInclude_Macro.nss "Macro"
* \ref _SCInclude_Mode.nss "Mode"
*
*
* @author Brian T. Meyer and others
*/ 
 
 
/** @defgroup  hkspell
* @name HK Spell Function Wrappers (hk)
* @brief Common Script Library Support spell includes
*
* <b>Includes</b> Basic Include files for implementing special features or to use instead of the default includes. ( Files are all named _SCInclude_*.nss )
*  
* <b>HkSpell Function Wrappers</b> Overriding the engine in spells to fix bugs and add new features.
*
* @author Brian T. Meyer and others
*/


/** @defgroup  NWScript
* @name NWScript.nss
* @brief NWScript.nss core engine functions and constants
*
* Reference for core nwscript functions
* \ref nwscript_i.nss "Includes"
* \ref nwscript_c.nss "Constants"
*
* @author Brian T. Meyer and others
*/

/**
* These are issues thrown up by the prc compiler to the default vanilla scripts
*@bug need to track this down - Compiling: ./hench_o0_ai.nss --> NscCodeGenerator.cpp:3539: failed assertion `pSymbol ->nOffset == 0', not sure which file is causing this
*@bug nx2_s0_hlfrblst.nss(55): Error: Undeclared identifier "EffectHellfireBlast"
*@bug nx2_s0_hlfrblst.nss(65): Error: Undeclared identifier "ConTooLow"
*
*/