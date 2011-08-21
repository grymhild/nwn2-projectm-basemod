/** @file
* @brief Include File for Reserve Magic Feats
*
* 
* 
*
* @ingroup scinclude
* @author Kaedrin, Brian T. Meyer and others
*/





/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
#include "_HkSpell"
#include "_CSLCore_Magic"
// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"

/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////




/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

int SCGetReserveFeatDamage(int iDice, int nDieType)
{

	int nReserveMeta = CSLGetPreferenceSwitch("EnableReserveMeta",FALSE);
	// 0 = Disabled
	// 1 = Empower
	// 2 = Max
	// 3 = Emp + Max
			
	int nDamage = 0;
	
	if (nReserveMeta)
	{
		int nReserveEmpower;
		int nReserveMaximize;
		int nReserveEmpPlusMax;	
		
		if (nReserveMeta == 3)
		{
			nReserveEmpPlusMax = 1;
			nReserveEmpower = 1;
			nReserveMaximize = 1;
		}
		else
		if (nReserveMeta == 2)
		{
			nReserveMaximize = 1;
		}	
		else
		{
			nReserveEmpower = 1;
		}			
		
		if (nReserveEmpower && !GetHasFeat(FEAT_EMPOWER_SPELL))
		{
			nReserveEmpower = 0;
		}
		if (nReserveMaximize && !GetHasFeat(FEAT_MAXIMIZE_SPELL))
		{
			nReserveMaximize = 0;
		}
		if (nReserveEmpower == 0 || nReserveMaximize == 0)
		{
			nReserveEmpPlusMax = 0;
		}
		
		if (nReserveEmpPlusMax)
		{
			if (nDieType == 6)
			{
				nDamage = (6 * iDice * 3) / 2;
			}
			else if (nDieType == 4)
			{
				nDamage = (4 * iDice * 3) / 2;
			}				
		}
		else
		if (nReserveMaximize)
		{
			if (nDieType == 6)
			{
				nDamage = 6 * iDice;
			}
			else if (nDieType == 4)
			{
				nDamage = 4 * iDice;
			}		
		}
		else
		if (nReserveEmpower)
		{
			if (nDieType == 6)
			{
				nDamage = (d6(iDice) * 3)/2;
			}
			else if (nDieType == 4)
			{
				nDamage = (d4(iDice) * 3)/2;
			}				
		}
		else // No valid metamagics available
		{
			if (nDieType == 6)
			{
				nDamage = d6(iDice);
			}
			else if (nDieType == 4)
			{
				nDamage = d4(iDice);
			}		
		}				
		
	}
	else
	{
		if (nDieType == 6)
		{
			nDamage = d6(iDice);
		}
		else if (nDieType == 4)
		{
			nDamage = d4(iDice);
		}
	}
	
	return nDamage;
}



// used for reserve feats -1 if none available at given level
int CSLGetHighestLevelByDescriptor( int iDescriptor, object oChar = OBJECT_SELF )
{
	if ( iDescriptor == SCMETA_DESCRIPTOR_NONE )
	{
		return -1;
	}
	else if ( iDescriptor == SCMETA_DESCRIPTOR_FIRE )
	{
		if( GetHasSpell( SPELL_METEOR_SWARM, oChar ) ) { return 9; }
		//if( GetHasSpell( SPELL_SHADES, oChar ) ) { return 9; } //  <-- this is not really a fire spell
		if( GetHasSpell( SPELL_ELEMENTAL_SWARM, oChar ) ) { return 9; }
		if( GetHasSpell( SPELL_INCENDIARY_CLOUD, oChar ) ) { return 8; }
		if( GetHasSpell( 2025, oChar ) ) { return 8; }
		if( GetHasSpell( SPELL_DELAYED_BLAST_FIREBALL, oChar ) ) { return 7; }
		if( GetHasSpell( SPELL_FIRE_STORM, oChar ) ) { return 7; }
		if( GetHasSpell( SPELL_FLAME_STRIKE, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_FIREBRAND, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_INFERNO, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_GREATER_FIREBURST, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_SHROUD_OF_FLAME, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_ELEMENTAL_SHIELD, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_WALL_OF_FIRE, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_Orb_Fire, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_ORB_OF_FIRE, oChar ) ) { return 4; }			
		if( GetHasSpell( SPELL_FIREBALL, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_FLAME_ARROW, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_Energized_Shield, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_Flame_Faith, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_Weapon_Energy, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_COMBUST, oChar ) ) { return 2; }
		if( GetHasSpell( SPELL_FLAME_WEAPON, oChar ) ) { return 2; }
		if( GetHasSpell( SPELL_FIREBURST, oChar ) ) { return 2; }
		if( GetHasSpell( SPELL_BODY_OF_THE_SUN, oChar ) ) { return 2; }
		if( GetHasSpell( SPELL_SCORCHING_RAY, oChar ) ) { return 2; } // This constant is not in nwscript, had to add it
		if( GetHasSpell( SPELL_Lesser_Energized_Shield, oChar ) ) { return 2; }
		if( GetHasSpell( SPELL_Heartfire, oChar ) ) { return 2; }
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_COLD )
	{
		
		if ( GetHasSpell(158) || GetHasSpell(1045))
		return 9;
			
	if (GetHasSpell(886))
		return 8;
			
	if (GetHasSpell(25))
		return 5;
			
	if ( GetHasSpell(47) || GetHasSpell(368) || GetHasSpell(1043) || GetHasSpell(SPELL_Orb_Cold) || GetHasSpell(1206) || GetHasSpell(SPELL_LESSER_AURA_COLD))
		return 4;	
															
	if ( GetHasSpell(1031) || GetHasSpell(1753) || GetHasSpell(SPELL_Weapon_Energy) )
		return 3;
		
	if ( GetHasSpell(1042) || GetHasSpell(1747) || GetHasSpell(2028))
		return 2;
		
		
		
		//SPELL_Lesser_Orb_Cold 
		if( GetHasSpell( SPELL_Orb_Cold, oChar ) ) { return 4; }
		
		
		
		
	}
	else if ( iDescriptor == SCMETA_DESCRIPTOR_ELECTRICAL )	
	{
		if( GetHasSpell( SPELL_STORM_OF_VENGEANCE, oChar ) ) { return 9; }
		if( GetHasSpell( SPELL_CHAIN_LIGHTNING, oChar ) ) { return 6; }
		if( GetHasSpell( SPELL_CALL_LIGHTNING_STORM, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_Orb_Electricity, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_ARC_OF_LIGHTNING, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_ORB_OF_ELECTRICITY, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_CALL_LIGHTNING, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_LIGHTNING_BOLT, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_SCINTILLATING_SPHERE, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_Energized_Shield, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_Weapon_Energy, oChar ) ) { return 3; }
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_SONIC )			
	{
		if( GetHasSpell( SPELL_GREATER_SHOUT, oChar ) ) { return 8; }
		if( GetHasSpell( SPELL_Lions_Roar, oChar ) ) { return 8; }
		if( GetHasSpell( SPELL_CACOPHONIC_BURST, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_Sonic_Shield, oChar ) ) { return 5; }
		if( GetHasSpell( 2027, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_Orb_Sound, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_SHOUT, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_Castigate, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_CASTIGATION, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_ORB_OF_SOUND, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_Energized_Shield, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_Resonating_Bolt, oChar ) ) { return 3; }
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_ACID )			
	{
		if( GetHasSpell( SPELL_STORM_OF_VENGEANCE, oChar ) ) { return 9; }
		// if( GetHasSpell( SPELL_GREATER_SHADOW_CONJURATION, oChar ) ) { return 7;	}
		if( GetHasSpell( SPELL_ACID_FOG, oChar ) ) { return 6; }
		if( GetHasSpell( SPELL_VITRIOLIC_SPHERE, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_Orb_Acid, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_ORB_OF_ACID, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_MESTILS_ACID_BREATH, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_Energized_Shield, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_Weapon_Energy, oChar ) ) { return 3; }
		if( GetHasSpell( SPELL_MELFS_ACID_ARROW, oChar ) ) { return 2; }
		if( GetHasSpell( SPELL_Lesser_Energized_Shield, oChar ) ) { return 2; }
	}
	/* // Just in case i need them for something else 
	else if ( iDescriptor == SCMETA_DESCRIPTOR_NEGATIVE )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_DIVINE )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_POSITIVE )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_MAGICAL )		
	{
	
	}
	*/	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_FORCE )			
	{
		if( GetHasSpell( SPELL_BIGBYS_CRUSHING_HAND, oChar ) ) { return 9; }
		if( GetHasSpell( SPELL_BIGBYS_CLENCHED_FIST, oChar ) ) { return 8; }
		if( GetHasSpell( SPELL_MORDENKAINENS_SWORD, oChar ) ) { return 7; }
		if( GetHasSpell( SPELL_BIGBYS_GRASPING_HAND, oChar ) ) { return 7; }
		if( GetHasSpell( SPELL_ISAACS_GREATER_MISSILE_STORM, oChar ) ) { return 6; }
		if( GetHasSpell( SPELL_BIGBYS_FORCEFUL_HAND, oChar ) ) { return 6; }
		if( GetHasSpell( SPELL_BIGBYS_INTERPOSING_HAND, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_Orb_Force, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_ISAACS_LESSER_MISSILE_STORM, oChar ) ) { return 4; }
	}
	else if ( iDescriptor == SCMETA_DESCRIPTOR_ENERGY )	// Protective Ward is wired into this, which is really abjuration but using energy now.
	{
		if( GetHasSpell( SPELL_FREEDOM_OF_MOVEMENT, oChar ) ) { return 4; }
		if( GetHasSpell( SPELL_PROTECTION_FROM_ENERGY, oChar ) ) { return 2; }
		if( GetHasSpell( SPELL_RESIST_ENERGY, oChar ) ) { return 2; }
	}
	else if ( iDescriptor == SCMETA_DESCRIPTOR_AIR )			
	{
		if( GetHasSpell( SPELL_ELEMENTAL_SWARM, oChar ) ) { return 9; }
		if( GetHasSpell( 2026, oChar ) ) { return 5; }
		if( GetHasSpell( SPELL_GUST_OF_WIND, oChar ) ) { return 2; }
	}
	/*	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_WATER )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_EARTH )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_LIGHT )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_DARKNESS )	
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_GOOD )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_EVIL )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_LAW )			
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_CHAOS )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_DEATH )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_DISEASE )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_POISON )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_MIND )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_FEAR )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_LANGUAGE )	
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_INVISIBILITY )	
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_GAS )			
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_SLEEP )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_ORGANIC )		
	{
	
	}	
	else if ( iDescriptor == SCMETA_DESCRIPTOR_METAL )		
	{
	
	}	
	*/
	return -1;

}


int GetWarReserveLevel()
{
	// This actually returns the DAMAGE_BONUS_x value and not the spell level
	// Needed for EffectDamageIncrease
	if (GetHasSpell(SPELL_POWER_WORD_KILL)) //Level 9
	{
		return 9;
	}
	if (GetHasSpell(SPELL_POWER_WORD_STUN)) //Level 8
	{
		return 8;		
	}
	if (GetHasSpell(SPELL_POWORD_BLIND)) //Level 7
	{
		return 7;	
	}
	if (GetHasSpell(SPELL_BLADE_BARRIER)) //Level 6
	{
		return 6;	
	}
	if (GetHasSpell(SPELL_FLAME_STRIKE)) //Level 5
	{
		return 5;	
	}
	if (GetHasSpell(SPELL_DIVINE_POWER)) //Level 4
	{
		return 4;																			
	}	
	return -1;
}

int GetNecroReserveLevel()
{

	if ( GetHasSpell(51) || GetHasSpell(190) )
		return 9;		

	if ( GetHasSpell(29) || GetHasSpell(367) || GetHasSpell(898) || GetHasSpell(1018) )
		return 8;						

	if ( GetHasSpell(28) || GetHasSpell(56) || GetHasSpell(366) || GetHasSpell(895) || 
		GetHasSpell(1032) || GetHasSpell(1796) )
		return 7;		
				
	if ( GetHasSpell(18) || GetHasSpell(30) || GetHasSpell(77) || GetHasSpell(528) || GetHasSpell(892) )
		return 6;
		
	if ( GetHasSpell(19) || GetHasSpell(23) || GetHasSpell(164) || GetHasSpell(1017) )
		return 5;					

	if ( GetHasSpell(38) || GetHasSpell(52) || GetHasSpell(435) || GetHasSpell(1773) )
		return 4;
		
	if ( GetHasSpell(2) || GetHasSpell(27) || GetHasSpell(54) || GetHasSpell(129) || GetHasSpell(188) || 
		GetHasSpell(434) || GetHasSpell(513) || GetHasSpell(1036) )
		return 3;
										
	return 0;
}

int GetReserveSpellSaveDC(int nSpellLevel, object oCaster)
{

	int iDC = 10;

	iDC += CSLGetDCBonusByLevel(oCaster);
	iDC += nSpellLevel;
	
	int nTemp = 0;
	int nInt = 0; //10,30
	nTemp += GetLevelByClass(10,oCaster);
	nTemp += GetLevelByClass(30,oCaster);
	nInt = nTemp;	

	nTemp = 0;			
	int nCha= 0; //1,9
	nTemp += GetLevelByClass(1,oCaster);
	nTemp += GetLevelByClass(9,oCaster);
	nCha = nTemp;

	nTemp = 0;					
	int nWis= 0; //2,3,6,7,31
	nTemp += GetLevelByClass(2,oCaster);
	nTemp += GetLevelByClass(3,oCaster);
	nTemp += GetLevelByClass(6,oCaster);
	nTemp += GetLevelByClass(7,oCaster);
	nTemp += GetLevelByClass(31,oCaster);
	nWis = nTemp;
	
	int nType = 0;	
	if (nInt > nCha)
	{	
		if (nInt > nWis)
		{
			iDC += GetAbilityModifier(ABILITY_INTELLIGENCE, oCaster);
		}
		else
		{
			iDC +=  GetAbilityModifier(ABILITY_WISDOM, oCaster);
		}
	}
	else
	{
		if (nCha > nWis)
		{
			iDC +=  GetAbilityModifier(ABILITY_CHARISMA, oCaster);	
		}
		else
		{
			iDC +=  GetAbilityModifier(ABILITY_WISDOM, oCaster);			
		}	
	}
	
	
	return iDC;
	
}


int GetDarkReserveLevel()
{

	if (GetHasSpell(110))
		return 8;
	if (GetHasSpell(160))
		return 7;		
	if (GetHasSpell(159))
		return 4;
/*
110	Mass Blindness and Deafness	8
159	Shadow Conjuration	4
160	Shadow Shield	7
*/
								
	return 0;
}