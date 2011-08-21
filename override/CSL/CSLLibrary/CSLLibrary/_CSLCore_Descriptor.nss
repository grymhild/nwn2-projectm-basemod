/** @file
* @brief Descriptor related functions
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/

/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////
/*
Dualities
Male and Female
Light and Darkness
Fire and Ice
Life and Death
Left and Right
Land and Sea
Sword and Sorcery
Truth and Deception
Yin and Yang
Active and Passive
Mental and Physical
Offense and Defense
Sun and Moon
*/





/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////






/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

// need to review these
//#include "_SCUtilityConstants"
#include "_CSLCore_Visuals_c"
#include "_CSLCore_Magic_c"
#include "_CSLCore_Strings"
#include "_CSLCore_Math"
#include "_CSLCore_Messages"
// not sure on this one, but might be useful
//#include "_SCInclude_MetaConstants"


/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////
// should shades version of delayed blast fireball have the mind descriptor?

// Curse and polymorph are made into a subschool per giant in the playground

const int SCMETA_DESCRIPTOR_NONE			= BIT0;
// basic damage types
const int SCMETA_DESCRIPTOR_FIRE			= BIT1;
const int SCMETA_DESCRIPTOR_COLD			= BIT2;
const int SCMETA_DESCRIPTOR_ELECTRICAL	= BIT3;
const int SCMETA_DESCRIPTOR_SONIC			= BIT4; // Audible
const int SCMETA_DESCRIPTOR_ACID 			= BIT5;
//better damage types
const int SCMETA_DESCRIPTOR_NEGATIVE		= BIT6;
const int SCMETA_DESCRIPTOR_POSITIVE		= BIT7;
const int SCMETA_DESCRIPTOR_DIVINE		= BIT8;
const int SCMETA_DESCRIPTOR_FORCE			= BIT9;
const int SCMETA_DESCRIPTOR_MAGICAL		= BIT10;
const int SCMETA_DESCRIPTOR_ENERGY		= BIT11;
// Elements and elemental planes
const int SCMETA_DESCRIPTOR_AIR			= BIT12;
const int SCMETA_DESCRIPTOR_WATER			= BIT13;
const int SCMETA_DESCRIPTOR_EARTH			= BIT14;
// light and dark
const int SCMETA_DESCRIPTOR_LIGHT			= BIT15;
const int SCMETA_DESCRIPTOR_DARKNESS		= BIT16;
// Alignment
const int SCMETA_DESCRIPTOR_GOOD			= BIT17;
const int SCMETA_DESCRIPTOR_EVIL			= BIT18;
const int SCMETA_DESCRIPTOR_LAW			= BIT19;
const int SCMETA_DESCRIPTOR_CHAOS			= BIT20;
// Other effects
const int SCMETA_DESCRIPTOR_DEATH			= BIT21;
const int SCMETA_DESCRIPTOR_DISEASE		= BIT22;
const int SCMETA_DESCRIPTOR_POISON		= BIT23;
const int SCMETA_DESCRIPTOR_MIND			= BIT24; // INTELLIGENT
const int SCMETA_DESCRIPTOR_FEAR			= BIT25;
const int SCMETA_DESCRIPTOR_LANGUAGE		= BIT26; // no spells but it's a real descriptor, hideous laughter should be this one
const int SCMETA_DESCRIPTOR_INVISIBILITY	= BIT27; // for invis purge.
const int SCMETA_DESCRIPTOR_GAS			= BIT28; // for gust of wind logic and Steam
const int SCMETA_DESCRIPTOR_SLEEP			= BIT29; // of sleep or related to dreams
const int SCMETA_DESCRIPTOR_ORGANIC 		= BIT30; // Wood or flesh or Plant, (natural)
const int SCMETA_DESCRIPTOR_METAL			= BIT31; // for man made and weapons (opposite of organic being natural, affects weapons and constructs)




/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

/*
int CSLGetIsElementalDescriptor( int iDescriptor );
int CSLGetIsDamageDescriptor( int iDescriptor );
int CSLGetDescriptorRemoveAllDamageTypes( int iDescriptor );
int CSLGetIsDamageTypeAndDescriptorMismatched( int iDamageType, int iDescriptor );
int CSLGetDamageTypeModifiedByDescriptor( int iDamageType, int iDescriptor );
int CSLGetDescriptorModifiedByDamageType( int iDescriptor, int iDamageType );
int CSLGetDescriptorByDamageType(int iDamageType);
int CSLGetDamagetypeByDescriptor( int iDescriptorMod, int iDamagetype = 0  );
int CSLGetImpactEffectByDescriptor( int iDescriptorMod, int iOriginalEffect = 0  );
int CSLGetHitEffectByDescriptor( int iDescriptorMod, int iOriginalEffect = VFX_HIT_SPELL_MAGIC  );
int CSLGetSaveTypeByDescriptor( int iDescriptorMod, int iSavingThrowType = SAVING_THROW_TYPE_ALL  );
int CSLGetBreathConeEffectByDescriptor( int iDescriptorMod, int iBreathConeEffect = 0  );
int CSLGetAOEEffectByDescriptor( int iDescriptorMod, int iOriginalEffect = VFX_HIT_AOE_EVOCATION  );
int CSLGetAOEExplodeByDescriptor( int iDescriptorMod, int iOriginalEffect = 0  );
int CSLGetAOEWallByDescriptor( int iDescriptorMod, int iOriginalEffect = 0  );
int CSLGetBeamEffectByDescriptor( int iDescriptorMod, int iOriginalEffect = VFX_BEAM_EVOCATION  );
int CSLGetMIRVEffectByDescriptor( int iDescriptorMod, int iMirEffect = VFX_IMP_MIRV  );
string CSLDescriptorsToString(int iDescriptor);
*/

/////////////////////////////////////////////////////
//////////// TEMPLATE FOR FUNCTIONS /////////////////
/////////////////////////////////////////////////////
/*
// * This is a template for other Desciptor functions
int CSLGetXXXXXXXXByDescriptor( int iDescriptorMod, int iOriginalEffect = 0  )
{
	if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return XXXXXX;
	// Other Damage Types
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return XXXXXX;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
	return iOriginalEffect;
}
*/



/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
string CSLDamagetypeToString(int iDamageType)
{
	if (iDamageType==DAMAGE_TYPE_ACID)       return "Acid";
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return "Negative";
	if (iDamageType==DAMAGE_TYPE_COLD)       return "Cold";
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return "Positive";
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return "Divine";
	if (iDamageType==DAMAGE_TYPE_SONIC)      return "Sonic";
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return "Electrical";
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return "Blunt";
	if (iDamageType==DAMAGE_TYPE_FIRE)       return "Fire";
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return "Piercing";
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return "Magical";
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return "Slashing";
	return "MissDamageType" + IntToString(iDamageType);
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetOppositeDamageType(int iDamageType )
{  // SC_SHAPE_AOEEXPLODE
	if (iDamageType==DAMAGE_TYPE_ACID)       return DAMAGE_TYPE_SONIC;
	if (iDamageType==DAMAGE_TYPE_COLD)       return DAMAGE_TYPE_FIRE;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return DAMAGE_TYPE_MAGICAL;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return DAMAGE_TYPE_SONIC;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return DAMAGE_TYPE_COLD;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return DAMAGE_TYPE_DIVINE;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return DAMAGE_TYPE_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return DAMAGE_TYPE_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return DAMAGE_TYPE_ACID; 
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return DAMAGE_TYPE_SLASHING;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return DAMAGE_TYPE_BLUDGEONING;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   {return DAMAGE_TYPE_BLUDGEONING;}
	return DAMAGE_TYPE_ALL;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSaveTypeByDamageType(int iDamageType)
{
	if (iDamageType==DAMAGE_TYPE_ACID)			return SAVING_THROW_TYPE_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)			return SAVING_THROW_TYPE_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)		return SAVING_THROW_TYPE_DIVINE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return SAVING_THROW_TYPE_ELECTRICITY;
	if (iDamageType==DAMAGE_TYPE_FIRE)			return SAVING_THROW_TYPE_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)		return SAVING_THROW_TYPE_ALL; // SAVING_THROW_TYPE_SPELL;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return SAVING_THROW_TYPE_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)		return SAVING_THROW_TYPE_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)			return SAVING_THROW_TYPE_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return SAVING_THROW_TYPE_ALL;
	if (iDamageType==DAMAGE_TYPE_PIERCING)		return SAVING_THROW_TYPE_ALL;
	if (iDamageType==DAMAGE_TYPE_SLASHING)		return SAVING_THROW_TYPE_ALL;
	if (iDamageType==DAMAGE_TYPE_ALL)			return SAVING_THROW_TYPE_ALL;
	return SAVING_THROW_TYPE_ALL;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsElementalDescriptor( int iDescriptor )
{
	
	if      ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )      { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_COLD )      { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL) { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_SONIC )     { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ACID )      { return TRUE; }
//	else if ( iDescriptor & SCMETA_DESCRIPTOR_MAGICAL )   { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_PIERCING )  { return TRUE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FORCE )     { return TRUE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_ENERGY )    { return TRUE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE )  { return FALSE; }		
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE )  { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DIVINE )    { return FALSE; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EARTH )     { return FALSE; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FEAR )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POISON )    { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DISEASE )   { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LAW )       { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DEATH )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DARKNESS )  { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LIGHT )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )       { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )     { return FALSE; }

// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LAW )       { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DEATH )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DARKNESS )  { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LIGHT )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )       { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )     { return FALSE; }
	return FALSE;
}




/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsDamageDescriptor( int iDescriptor )
{
	if      ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )      { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_COLD )      { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL) { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_SONIC )     { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ACID )      { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_MAGICAL )   { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_FORCE )     { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ENERGY )    { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE )  { return TRUE; }		
	else if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE )  { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_DIVINE )    { return TRUE; }	
//	else if ( iDescriptor & SCMETA_DESCRIPTOR_E//ARTH )     { return FALSE; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FEAR )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POISON )    { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DISEASE )   { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LAW )       { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DEATH )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DARKNESS )  { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LIGHT )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )       { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )     { return FALSE; }
	else { return FALSE; }
	return FALSE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetDescriptorRemoveAllDamageTypes( int iDescriptor )
{
	if ( iDescriptor == SCMETA_DESCRIPTOR_NONE )
	{
		return iDescriptor;
	}
	if ( iDescriptor & SCMETA_DESCRIPTOR_ACID )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_ACID;
	}
	if ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_FIRE;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_COLD )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_COLD;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_ELECTRICAL;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_SONIC )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_SONIC;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_MAGICAL )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_MAGICAL;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_NEGATIVE;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_POSITIVE;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_DIVINE )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_DIVINE;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_ENERGY )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_ENERGY;
	}	
	if ( iDescriptor & SCMETA_DESCRIPTOR_FORCE )
	{
		iDescriptor = iDescriptor - SCMETA_DESCRIPTOR_FORCE;
	}
	return iDescriptor;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetIsDamageTypeAndDescriptorMismatched( int iDamageType, int iDescriptor )
{
		// Ignore these situations
	if ( iDescriptor == SCMETA_DESCRIPTOR_NONE ) return FALSE;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return FALSE;
	if (iDamageType==DAMAGE_TYPE_PIERCING)		return FALSE;
	if (iDamageType==DAMAGE_TYPE_SLASHING)		return FALSE;
	if (iDamageType==DAMAGE_TYPE_ALL)			return FALSE;

	if (iDamageType==DAMAGE_TYPE_FIRE && !(iDescriptor & SCMETA_DESCRIPTOR_FIRE ) )					return TRUE;
	else if (iDamageType==DAMAGE_TYPE_COLD && !(iDescriptor & SCMETA_DESCRIPTOR_COLD ) )			return TRUE;
	else if (iDamageType==DAMAGE_TYPE_ELECTRICAL && !(iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL))	return TRUE;
	else if (iDamageType==DAMAGE_TYPE_ACID && !(iDescriptor & SCMETA_DESCRIPTOR_ACID ) )			return TRUE;
	else if (iDamageType==DAMAGE_TYPE_SONIC && !(iDescriptor & SCMETA_DESCRIPTOR_SONIC ) )			return TRUE;
	else if (iDamageType==DAMAGE_TYPE_DIVINE && !(iDescriptor & SCMETA_DESCRIPTOR_DIVINE ) )		return TRUE;
	else if (iDamageType==DAMAGE_TYPE_NEGATIVE && !(iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE ) )	return TRUE;
	else if (iDamageType==DAMAGE_TYPE_POSITIVE && !(iDescriptor & SCMETA_DESCRIPTOR_POSITIVE ) )	return TRUE;
	else if (iDamageType==DAMAGE_TYPE_MAGICAL )
	{
		if ( !(iDescriptor & SCMETA_DESCRIPTOR_MAGICAL || iDescriptor & SCMETA_DESCRIPTOR_FORCE || iDescriptor & SCMETA_DESCRIPTOR_ENERGY )  )
		{
			return TRUE;
		}
	}
	
	return FALSE;
}




/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetDescriptorByDamageType(int iDamageType)
{ // SC_SHAPE_SPELLCONE
	// These emanate from in front of the caster
	if (iDamageType==DAMAGE_TYPE_ACID)       return SCMETA_DESCRIPTOR_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return SCMETA_DESCRIPTOR_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return SCMETA_DESCRIPTOR_DIVINE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return SCMETA_DESCRIPTOR_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return SCMETA_DESCRIPTOR_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return SCMETA_DESCRIPTOR_MAGICAL;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return SCMETA_DESCRIPTOR_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return SCMETA_DESCRIPTOR_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return SCMETA_DESCRIPTOR_SONIC;
	//if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return SCMETA_DESCRIPTOR_NONE;
	//if (iDamageType==DAMAGE_TYPE_PIERCING)   return SCMETA_DESCRIPTOR_NONE;
	//if (iDamageType==DAMAGE_TYPE_SLASHING)   return SCMETA_DESCRIPTOR_NONE;
	return SCMETA_DESCRIPTOR_NONE;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetDamagetypeByDescriptor( int iDescriptorMod, int iDamagetype = 0  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iDamagetype;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return DAMAGE_TYPE_FIRE;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return DAMAGE_TYPE_COLD;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return DAMAGE_TYPE_ELECTRICAL;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return DAMAGE_TYPE_SONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return DAMAGE_TYPE_ACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return DAMAGE_TYPE_NEGATIVE;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return DAMAGE_TYPE_DIVINE;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return DAMAGE_TYPE_POSITIVE;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return DAMAGE_TYPE_MAGICAL;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return DAMAGE_TYPE_MAGICAL;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return DAMAGE_TYPE_MAGICAL;
	return iDamagetype;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetImpactEffectByDescriptor( int iDescriptorMod, int iOriginalEffect = 0  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return VFX_IMP_FLAME_M;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return VFX_IMP_FROST_S;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return VFX_IMP_LIGHTNING_S;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return VFX_HIT_SPELL_SONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return VFX_IMP_ACID_S;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return VFX_IMP_NEGATIVE_ENERGY;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return VFX_HIT_TURN_UNDEAD;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return VFX_IMP_GOOD_HELP;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return VFX_IMP_MAGBLUE;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return VFX_IMP_MAGBLUE;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return VFX_IMP_MAGBLUE;
	//if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return XXXXXX;
	if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return VFX_IMP_GOOD_HELP;
	//if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )		return XXXXXX;
	if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return VFX_IMP_NEGATIVE_ENERGY;
	if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return VFX_DUR_SPELL_BANE;
	if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return VFX_DUR_SPELL_BANE;
	//if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )		return XXXXXX;
	return iOriginalEffect;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetFaeryAuraByDescriptor( int iDescriptorMod, int iOriginalEffect = 0  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_FIRE;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_COLD;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return VFXSC_DUR_FAERYAURA_ELECTRICAL;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_SONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_ACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_NEGATIVE;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_WHITE;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_POSITIVE;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_MAGIC;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_POSITIVE;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_POSITIVE;
	if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_TEAL;
	if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_BLUE;
	if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_GREEN;
	if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_WHITE;
	if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_NEGATIVE;
	if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_YELLOW;
	if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_RED;
	if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_BLUE;
	if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_PURPLE;
	if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_NEGATIVE;
	if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_GREEN;
	if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_RED;
	if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_BLUE;
	if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )			return VFXSC_DUR_FAERYAURA_RED;
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )			return XXXXXX;
	if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return VFXSC_DUR_FAERYAURA_GREEN;
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )			return XXXXXX;
	return iOriginalEffect;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetHitEffectByDescriptor( int iDescriptorMod, int iOriginalEffect = VFX_HIT_SPELL_MAGIC  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return VFX_HIT_SPELL_FIRE;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return VFX_HIT_SPELL_ICE;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return VFX_HIT_SPELL_LIGHTNING;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return VFX_HIT_SPELL_SONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return VFX_HIT_SPELL_ACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return VFX_HIT_SPELL_NECROMANCY;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return VFX_HIT_SPELL_HOLY;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return VFX_HIT_SPELL_HOLY;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return VFX_HIT_SPELL_MAGIC;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return VFX_HIT_SPELL_MAGIC;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return VFX_HIT_SPELL_MAGIC;
	//if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return VFX_HIT_SPELL_HOLY;
	//if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return VFX_HIT_SPELL_ILLUSION;
	//if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )		return XXXXXX;
	return iOriginalEffect;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetSaveTypeByDescriptor( int iDescriptorMod, int iSavingThrowType = SAVING_THROW_TYPE_ALL  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iSavingThrowType;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return SAVING_THROW_TYPE_FIRE;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return SAVING_THROW_TYPE_COLD;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return SAVING_THROW_TYPE_ELECTRICITY;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return SAVING_THROW_TYPE_SONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return SAVING_THROW_TYPE_ACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return SAVING_THROW_TYPE_NEGATIVE;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return SAVING_THROW_TYPE_DIVINE;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return SAVING_THROW_TYPE_POSITIVE;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return SAVING_THROW_TYPE_ALL;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return SAVING_THROW_TYPE_ALL;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return SAVING_THROW_TYPE_ALL;
	//if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return XXXXXX;
	if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return SAVING_THROW_TYPE_GOOD;
	if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return SAVING_THROW_TYPE_EVIL;
	if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return SAVING_THROW_TYPE_LAW;
	if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )		return SAVING_THROW_TYPE_CHAOS;
	if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return SAVING_THROW_TYPE_DEATH;
	if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return SAVING_THROW_TYPE_DISEASE;
	if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return SAVING_THROW_TYPE_POISON;
	if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )		return SAVING_THROW_TYPE_MIND_SPELLS;
	if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )		return SAVING_THROW_TYPE_FEAR;
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )		return XXXXXX;
	return iSavingThrowType;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetBreathConeEffectByDescriptor( int iDescriptorMod, int iBreathConeEffect = 0  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iBreathConeEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return VFX_DUR_CONE_FIRE;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return VFX_DUR_CONE_ICE;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return VFX_DUR_CONE_LIGHTNING;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return VFX_DUR_CONE_SONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return VFX_DUR_CONE_ACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return VFX_DUR_CONE_EVIL;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return VFX_DUR_CONE_HOLY;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return VFX_DUR_CONE_MAGIC;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return VFX_DUR_CONE_MAGIC;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return VFX_DUR_CONE_MAGIC;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return VFX_DUR_CONE_MAGIC;
	if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return VFX_DUR_CONE_MAGIC;
	if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return VFX_DUR_CONE_EVIL;
	if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return VFX_DUR_CONE_HOLY;
	if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return VFX_DUR_CONE_EVIL;
	if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return VFX_DUR_CONE_EVIL;
	if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return VFX_DUR_CONE_EVIL;
	if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return VFX_DUR_CONE_ACID;
	if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return VFX_DUR_CONE_ACID;
	return iBreathConeEffect;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetAOEEffectByDescriptor( int iDescriptorMod, int iOriginalEffect = VFX_HIT_AOE_EVOCATION  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return VFX_HIT_AOE_FIRE;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return VFX_HIT_AOE_ICE;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return VFX_HIT_AOE_LIGHTNING;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return VFX_HIT_AOE_SONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return VFX_HIT_AOE_ACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return VFX_HIT_AOE_NECROMANCY;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return VFX_HIT_AOE_HOLY;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return VFX_HIT_AOE_DIVINATION;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return VFX_HIT_AOE_MAGIC;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return VFX_HIT_AOE_MAGIC;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return VFX_HIT_AOE_DIVINATION;
	//if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )		return XXXXXX;
	if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return VFX_HIT_AOE_NECROMANCY;
	//if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )		return XXXXXX;
	return iOriginalEffect;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetAOEExplodeByDescriptor( int iDescriptorMod, int iOriginalEffect = 0  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return VFX_FNF_FIREBALL; // 22 Works --
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return VFX_FNF_ICESTORM; // 231 --
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return VFX_FNF_ELECTRIC_EXPLOSION; // 459 --
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return VFXSC_HIT_AOE_CACOPHONICBURST; // VFX_FNF_SOUND_BURST is invalid 183 
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return VFX_FNF_GAS_EXPLOSION_ACID; // 257 --
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return VFX_FNF_GAS_EXPLOSION_EVIL; // 258 --
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return VFX_FNF_WORD; // 41
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return VFX_FNF_GAS_EXPLOSION_MIND; // 262 --
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return VFX_FNF_MYSTICAL_EXPLOSION; // 477 --
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return VFX_FNF_MYSTICAL_EXPLOSION; // 477 --
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return VFX_FNF_MYSTICAL_EXPLOSION; // 477 --
	if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return VFXSC_FNF_BURST_SMALL_SMOKEPUFF; // 263 -- Invalid
	//if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return XXXXXX;
	if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return VFX_FNF_GAS_EXPLOSION_EVIL; // 258 --
	//if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return XXXXXX;
	if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )		return VFX_FNF_GAS_EXPLOSION_MIND; // 262 --
	if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )		return VFX_FNF_GAS_EXPLOSION_EVIL; // 258 --
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return XXXXXX;
	if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return VFX_FNF_GAS_EXPLOSION_NATURE; // 259 --
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )		return XXXXXX;
	if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return VFX_FNF_GAS_EXPLOSION_NATURE; // 259 --
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )		return XXXXXX;
	return iOriginalEffect;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetAOEWallByDescriptor( int iDescriptorMod, int iOriginalEffect = 0  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return AOE_PER_WALLFIRE;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return AOE_PER_WALLCOLD;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return AOE_PER_WALLELECTRICAL;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return AOE_PER_WALLSONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return AOE_PER_WALLACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return AOE_PER_WALLNEGATIVE;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return AOE_PER_WALLPOSITIVE;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return AOE_PER_WALLPOSITIVE;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return AOE_PER_WALLPOSITIVE;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return AOE_PER_WALLPOSITIVE;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return AOE_PER_WALLPOSITIVE;
	//if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return XXXXXX;
	if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return AOE_PER_WALLNEGATIVE;
	//if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )		return XXXXXX;
	return iOriginalEffect;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetBeamEffectByDescriptor( int iDescriptorMod, int iOriginalEffect = VFX_BEAM_EVOCATION  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return VFX_BEAM_FIRE;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return VFX_BEAM_COLD;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return VFX_BEAM_LIGHTNING;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return VFX_BEAM_SONIC;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return VFX_BEAM_ACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return VFX_BEAM_NECROMANCY;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return VFX_BEAM_HOLY;
	if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return VFX_BEAM_HOLY;
	if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return VFX_BEAM_MAGIC;
	if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return VFX_BEAM_MAGIC;
	if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return VFX_BEAM_MAGIC;
	//if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return XXXXXX;
	if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return VFX_BEAM_BLACK;
	if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return VFX_BEAM_HOLY;
	if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return VFX_BEAM_EVIL;
	//if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return XXXXXX;
	if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )		return VFX_BEAM_EVOCATION;
	if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return VFX_BEAM_NECROMANCY;
	if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return VFX_BEAM_POISON;
	if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return VFX_BEAM_POISON;
	if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )		return VFX_BEAM_MIND;
	if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )		return VFX_BEAM_MAGIC;
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )		return XXXXXX;
	return VFX_BEAM_EVOCATION;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
// * This is a template for other functions
int CSLGetMIRVEffectByDescriptor( int iDescriptorMod, int iMirEffect = VFX_IMP_MIRV  )
{
	if ( SCMETA_DESCRIPTOR_NONE == iDescriptorMod )			return iMirEffect;
	// Main elemental Damage Types First
	if ( SCMETA_DESCRIPTOR_FIRE & iDescriptorMod )			return VFX_IMP_MIRV_FLAME;
	if ( SCMETA_DESCRIPTOR_COLD & iDescriptorMod )			return VFX_IMP_MIRV;
	if ( SCMETA_DESCRIPTOR_ELECTRICAL & iDescriptorMod )	return VFX_IMP_MIRV_ELECTRIC;
	if ( SCMETA_DESCRIPTOR_SONIC & iDescriptorMod )			return VFX_IMP_MIRV;
	if ( SCMETA_DESCRIPTOR_ACID & iDescriptorMod )			return VFX_DUR_MIRV_ACID;
	// Other Damage Types
	if ( SCMETA_DESCRIPTOR_NEGATIVE & iDescriptorMod )		return VFX_IMP_MIRV;
	if ( SCMETA_DESCRIPTOR_DIVINE & iDescriptorMod )		return VFX_IMP_MIRV;
	//if ( SCMETA_DESCRIPTOR_POSITIVE & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_MAGICAL & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_FORCE & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_ENERGY & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_AIR & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_WATER & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EARTH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LIGHT & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DARKNESS & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GOOD & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_EVIL & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LAW & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_CHAOS & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DEATH & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_DISEASE & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_POISON & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_MIND & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_FEAR & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_LANGUAGE & iDescriptorMod )	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_INVISIBILITY & iDescriptorMod)	return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_GAS & iDescriptorMod )			return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_SLEEP & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_ORGANIC & iDescriptorMod )		return XXXXXX;
	//if ( SCMETA_DESCRIPTOR_METAL & iDescriptorMod )		return XXXXXX;
	return iMirEffect;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
string CSLDescriptorsToString(int iDescriptor)
{
	string sDescriptor = "";
	if (iDescriptor==SCMETA_DESCRIPTOR_NONE ) return "None";
	if (iDescriptor & SCMETA_DESCRIPTOR_FIRE ) sDescriptor += "Fire ";
	if (iDescriptor & SCMETA_DESCRIPTOR_COLD ) sDescriptor += "Cold ";
	if (iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL ) sDescriptor += "Electrical ";
	if (iDescriptor & SCMETA_DESCRIPTOR_SONIC ) sDescriptor += "Sonic ";
	if (iDescriptor & SCMETA_DESCRIPTOR_ACID ) sDescriptor += "Acid ";
	if (iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE ) sDescriptor += "Negative ";
	if (iDescriptor & SCMETA_DESCRIPTOR_POSITIVE ) sDescriptor += "Positive ";
	if (iDescriptor & SCMETA_DESCRIPTOR_DIVINE ) sDescriptor += "Divine ";
	if (iDescriptor & SCMETA_DESCRIPTOR_FORCE ) sDescriptor += "Force ";
	if (iDescriptor & SCMETA_DESCRIPTOR_MAGICAL ) sDescriptor += "Magical ";
	if (iDescriptor & SCMETA_DESCRIPTOR_ENERGY ) sDescriptor += "Energy ";
	if (iDescriptor & SCMETA_DESCRIPTOR_AIR ) sDescriptor += "Air ";
	if (iDescriptor & SCMETA_DESCRIPTOR_WATER ) sDescriptor += "Water ";
	if (iDescriptor & SCMETA_DESCRIPTOR_EARTH ) sDescriptor += "Earth ";
	if (iDescriptor & SCMETA_DESCRIPTOR_LIGHT ) sDescriptor += "Light ";
	if (iDescriptor & SCMETA_DESCRIPTOR_DARKNESS ) sDescriptor += "Darkness ";
	if (iDescriptor & SCMETA_DESCRIPTOR_GOOD ) sDescriptor += "Good ";
	if (iDescriptor & SCMETA_DESCRIPTOR_EVIL ) sDescriptor += "Evil ";
	if (iDescriptor & SCMETA_DESCRIPTOR_LAW ) sDescriptor += "Law ";
	if (iDescriptor & SCMETA_DESCRIPTOR_CHAOS ) sDescriptor += "Chaos ";
	if (iDescriptor & SCMETA_DESCRIPTOR_DEATH ) sDescriptor += "Death ";
	if (iDescriptor & SCMETA_DESCRIPTOR_DISEASE ) sDescriptor += "Disease ";
	if (iDescriptor & SCMETA_DESCRIPTOR_POISON ) sDescriptor += "Poison ";
	if (iDescriptor & SCMETA_DESCRIPTOR_MIND ) sDescriptor += "Mind ";
	if (iDescriptor & SCMETA_DESCRIPTOR_FEAR ) sDescriptor += "Fear ";
	if (iDescriptor & SCMETA_DESCRIPTOR_LANGUAGE ) sDescriptor += "Language ";
	if (iDescriptor & SCMETA_DESCRIPTOR_INVISIBILITY ) sDescriptor += "Invisibility ";
	if (iDescriptor & SCMETA_DESCRIPTOR_GAS ) sDescriptor += "Gas ";
	if (iDescriptor & SCMETA_DESCRIPTOR_SLEEP ) sDescriptor += "Sleep ";
	if (iDescriptor & SCMETA_DESCRIPTOR_ORGANIC ) sDescriptor += "Organic ";
	if (iDescriptor & SCMETA_DESCRIPTOR_METAL ) sDescriptor += "Metal ";
	return CSLTrim( sDescriptor );
}


/*
int CSLXXXApplyShapeMods( int iShape, int iDescriptor=-1 )
{
//	// Custom Code by Modders Here
// 	if (iDescriptor==-1) { iDescriptor = SCGetDescriptor(); }
// 	
// 	
// 	This will be a later feature, change spheres to cubes, cones, walls, clouds and the like, or making AOE's bigger or smaller
// 	return iShape;
}

//int SC_SHAPE_SPELLCYLINDER = 0; // consider extending these soas to allow varied sizes as well
// int SC_SHAPE_BREATHCONE = 1;
// int SC_SHAPE_CUBE = 2;
// int SC_SHAPE_SPELLCONE = 3;
// int SC_SHAPE_SPHERE = 4;
// int SC_SHAPE_WALL = 5;
// int SC_SHAPE_CLOUD = 6;
// int SC_SHAPE_BEAM = 7;
// int SC_SHAPE_AURA = 8;



int CSLXXXGetDamagePower(int iDescriptor=-1 )
{
	// if (iDescriptor==-1) { iDescriptor = SCGetDescriptor(); }
	
	//if      ( iDescriptor & SCMETA_DESCRIPTOR_PIERCING )  { return DAMAGE_POWER_ENERGY; }
	if ( iDescriptor & SCMETA_DESCRIPTOR_FORCE )     { return DAMAGE_POWER_ENERGY; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ENERGY )    { return DAMAGE_POWER_ENERGY; }
//	else if ( iDescriptor & SCMETA_DESCRIPTOR_MAGICAL )   { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_COLD )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL) { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_SONIC )     { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_ACID )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE )  { return DAMAGE_POWER_NORMAL; }		
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE )  { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DIVINE )    { return DAMAGE_POWER_NORMAL; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EARTH )     { return DAMAGE_POWER_NORMAL; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FEAR )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POISON )    { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DISEASE )   { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LAW )       { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS )     { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DEATH )     { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DARKNESS )  { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LIGHT )    { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )  { return DAMAGE_POWER_NORMAL; }
	else { return DAMAGE_POWER_NORMAL; }
	return DAMAGE_POWER_NORMAL;
}

int CSLXXXGetIgnoreResistances(int iDescriptor=-1 )
{
	// if (iDescriptor==-1) { iDescriptor = SCGetDescriptor(); }
	// if      ( iDescriptor & SCMETA_DESCRIPTOR_PIERCING )  { return TRUE; }
	 if ( iDescriptor & SCMETA_DESCRIPTOR_FORCE )     { return TRUE; }
	else if ( iDescriptor & SCMETA_DESCRIPTOR_ENERGY )    { return TRUE; }
//	else if ( iDescriptor & SCMETA_DESCRIPTOR_MAGICAL )   { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_COLD )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL) { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_SONIC )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_ACID )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE )  { return FALSE; }		
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE )  { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DIVINE )    { return FALSE; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EARTH )     { return FALSE; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FEAR )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POISON )    { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DISEASE )   { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LAW )       { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DEATH )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DARKNESS )  { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LIGHT )     { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )       { return FALSE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )     { return FALSE; }
	else { return FALSE; }
	return FALSE;
}


int CSLXXXGetIgnoreSpellResist(int iDescriptor=-1 )
{
	// if (iDescriptor==-1) { iDescriptor = SCGetDescriptor(); }
	
	     if ( iDescriptor & SCMETA_DESCRIPTOR_ACID )      { return TRUE; }
//  else if ( iDescriptor & SCMETA_DESCRIPTOR_PIERCING )  { return TRUE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FORCE )     { return TRUE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_ENERGY )    { return TRUE; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MAGICAL )   { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FIRE )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_COLD )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_ELECTRICAL) { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_SONIC )     { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_ACID )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_NEGATIVE )  { return DAMAGE_POWER_NORMAL; }		
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POSITIVE )  { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DIVINE )    { return DAMAGE_POWER_NORMAL; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EARTH )     { return DAMAGE_POWER_NORMAL; }	
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_EVIL )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_GOOD )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_FEAR )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_POISON )    { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DISEASE )   { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LAW )       { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_CHAOS )     { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DEATH )     { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_DARKNESS )  { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_MIND )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_LIGHT )    { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_AIR )      { return DAMAGE_POWER_NORMAL; }
// 	else if ( iDescriptor & SCMETA_DESCRIPTOR_WATER )  { return DAMAGE_POWER_NORMAL; }
	else { return FALSE; }
	return FALSE;
}
*/

/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLGetWeaponEffectByDescriptor( int iDescriptorMod, int iWeaponType, int iOriginalEffect = 0  )
{
	
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_SPEAR ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_SPEAR_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_SPEAR_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_SPEAR_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_SPEAR_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_SPEAR_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_SPEAR_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_SPEAR_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_SPEAR_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_SPEAR_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_SPEAR_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_SPEAR_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_HAMMER ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_HAMMER_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_HAMMER_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_HAMMER_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_HAMMER_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_HAMMER_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_HAMMER_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_HAMMER_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_HAMMER_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_HAMMER_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_HAMMER_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_HAMMER_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_DAGGER ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_DAGGER_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_DAGGER_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_DAGGER_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_DAGGER_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_DAGGER_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_DAGGER_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_DAGGER_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_DAGGER_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_DAGGER_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_DAGGER_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_DAGGER_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_MACE ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_MACE_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_MACE_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_MACE_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_MACE_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_MACE_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_MACE_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_MACE_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_MACE_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_MACE_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_MACE_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_MACE_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_TRIDENT ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_TRIDENT_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_TRIDENT_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_TRIDENT_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_TRIDENT_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_TRIDENT_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_TRIDENT_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_TRIDENT_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_TRIDENT_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_TRIDENT_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_TRIDENT_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_TRIDENT_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_GLAIVE ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_GLAIVE_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_GLAIVE_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_GLAIVE_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_GLAIVE_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_GLAIVE_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_GLAIVE_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_GLAIVE_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_GLAIVE_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_GLAIVE_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_GLAIVE_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_GLAIVE_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_PITCHFORK ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_PITCHFORK_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_PITCHFORK_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_PITCHFORK_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_PITCHFORK_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_PITCHFORK_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_PITCHFORK_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_PITCHFORK_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_PITCHFORK_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_PITCHFORK_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_PITCHFORK_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_PITCHFORK_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_SCYTHE ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_SCYTHE_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_SCYTHE_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_SCYTHE_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_SCYTHE_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_SCYTHE_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_SCYTHE_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_SCYTHE_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_SCYTHE_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_SCYTHE_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_SCYTHE_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_SCYTHE_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_BATTLEAXE ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_BATTLEAXE_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_BOW ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_BOW_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_BOW_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_BOW_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_BOW_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_BOW_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_BOW_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_BOW_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_BOW_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_BOW_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_BOW_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_BOW_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_SHIELD ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_SHIELD_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_SHIELD_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_SHIELD_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_SHIELD_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_SHIELD_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_SHIELD_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_SHIELD_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_SHIELD_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_SHIELD_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_SHIELD_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_SHIELD_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_ARMOR ) // 
	{
		if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
		// Main elemental Damage Types First
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_ARMOR_FIRE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_ARMOR_COLD;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_ARMOR_ELECTRICAL;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_ARMOR_SONIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_ARMOR_ACID;
		// Other Damage Types
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_ARMOR_NEGATIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_ARMOR_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_ARMOR_POSITIVE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_ARMOR_MAGIC;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_ARMOR_FORCE;
		if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_ARMOR_POSITIVE;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
		//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
		return iOriginalEffect;
	}
	
	// default shape is sword
	if ( iDescriptorMod == SCMETA_DESCRIPTOR_NONE )			return iOriginalEffect;
	// Main elemental Damage Types First
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_FIRE )			return VFXSC_DUR_SPELLWEAP_SWORD_FIRE;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_COLD )			return VFXSC_DUR_SPELLWEAP_SWORD_COLD;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_ELECTRICAL )	return VFXSC_DUR_SPELLWEAP_SWORD_ELECTRICAL;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_SONIC )			return VFXSC_DUR_SPELLWEAP_SWORD_SONIC;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_ACID )			return VFXSC_DUR_SPELLWEAP_SWORD_ACID;
	// Other Damage Types
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_NEGATIVE  )		return VFXSC_DUR_SPELLWEAP_SWORD_NEGATIVE;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_DIVINE )		return VFXSC_DUR_SPELLWEAP_SWORD_POSITIVE;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_POSITIVE )		return VFXSC_DUR_SPELLWEAP_SWORD_POSITIVE;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_MAGICAL )		return VFXSC_DUR_SPELLWEAP_SWORD_MAGIC;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_FORCE )			return VFXSC_DUR_SPELLWEAP_SWORD_FORCE;
	if ( iDescriptorMod & SCMETA_DESCRIPTOR_ENERGY )		return VFXSC_DUR_SPELLWEAP_SWORD_POSITIVE;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_AIR )			return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_WATER )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EARTH )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LIGHT )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DARKNESS )	return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GOOD )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_EVIL )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LAW )			return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_CHAOS )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DEATH )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_DISEASE )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_POISON )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_MIND )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_FEAR )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_LANGUAGE )	return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_INVISIBILITY)	return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_GAS )			return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_SLEEP )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_ORGANIC )		return XXXXXX;
	//if ( iDescriptorMod & SCMETA_DESCRIPTOR_METAL )		return XXXXXX;
	return iOriginalEffect;
	
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// This compares the descriptor and damage type, if they don't match, it adjusts the damage type so it does
// If no descriptor it does nothing
// If non descriptor type, it does nothing
// It focuses first on elemental types, and kind of does energy types after that
// Then checks for more advanced types
int CSLGetDamageTypeModifiedByDescriptor( int iDamageType, int iDescriptor )
{
	if ( iDescriptor == SCMETA_DESCRIPTOR_NONE ) return iDamageType;
	if ( CSLGetIsDamageTypeAndDescriptorMismatched( iDamageType, iDescriptor ) )
	{
		if (DEBUGGING >= 4) { CSLDebug(  "MismatchedinAOE", OBJECT_SELF  ); }
		iDamageType = CSLGetDamagetypeByDescriptor( iDescriptor, iDamageType );
	}
	return iDamageType;
}


/**  
* @author
* @param 
* @see 
* @return 
*/
// This compares the descriptor and damage type, if they don't match, it adjusts the descriptor type so it does
// If no damagetype it does nothing
// If non descriptor type, it does nothing
// It focuses first on elemental types, and kind of does energy types after that
// Then checks for more advanced types
int CSLGetDescriptorModifiedByDamageType( int iDescriptor, int iDamageType )
{
	if ( iDamageType == 0 ) { return iDescriptor; }
	if ( iDamageType == DAMAGE_TYPE_ALL ) { return iDescriptor; }
	
	if ( CSLGetIsDamageTypeAndDescriptorMismatched( iDamageType, iDescriptor ) )
	{
		if (DEBUGGING >= 4) { CSLDebug(  "Mismatched", OBJECT_SELF  ); }

		// strip all damage type descriptors - we are CHANGING it from one damagetype to another
		iDescriptor = CSLGetDescriptorRemoveAllDamageTypes( iDescriptor );		
		iDescriptor = iDescriptor | CSLGetDescriptorByDamageType( iDamageType );
	}
	return iDescriptor;
}