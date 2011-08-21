/** @file
* @brief Visual related functions, related to visualeffects.2da, emotes, theatrics and some animations
*
* 
* 
*
* @ingroup cslcore
* @author Brian T. Meyer and others
*/

/*
This include covers mappings of information from visualeffects.2da,
with constants related to row nubmers from that file

Input a Desriptor or Damagetype, and
the type of shape you want, and then it returns an appropriate constant
which you can use with effectvisualeffect() (sp?), this is useful for energy
substitution, or for doing new spells where you really don't need to be
too specific. Or to allow the visual effect to vary as needed - perhaps 
so when underwater a different visual can be used.

The visualeffects.2da is a custom version based on the full Soz, and
includes community content

The light emitting and lady ashara's (sp??) versions are included to
varying degrees, or what they have done has been integrated into what
i've done.

Dracos wild magic effects are also included.

Kaedrins spell effects, and some of reerons are also included.

I've actually done new SEF's for cones, auras and exlodes to round out
what is available. I am alos implementing a low graphics version ( no
lights, less particles and simpler effects ) for those who have
challenged video cards.

Walls of fire, and clouds by necessity are implemented via vfx_persistent, 
so effects related to those return a reference to use with effectAreaOfEffect() (sp?)

*/
/////////////////////////////////////////////////////
//////////////// Notes /////////////////////////////
////////////////////////////////////////////////////





/////////////////////////////////////////////////////
///////////////// DESCRIPTION ///////////////////////
/////////////////////////////////////////////////////




/////////////////////////////////////////////////////
///////////////// Constants /////////////////////////
/////////////////////////////////////////////////////

#include "_CSLCore_Visuals_c"

#include "_CSLCore_Magic_c"

#include "_CSLCore_Items_c"

#include "_CSLCore_Objects"
#include "_CSLCore_Reputation"
/*
// Animation length and speed
const float CSL_ANIM_LOOPING_LENGTH = 4.0;
const float CSL_ANIM_LOOPING_SPEED = 1.0;

// Conversation file that holds the random one-liners for
// NPCs to speak when a PC comes into their home.
const string "x0_npc_homeconv" = "x0_npc_homeconv";

// Variable that holds the animation flags
const string "NW_ANIM_CONDITION" = "NW_ANIM_CONDITION";

// ***  Available animation flags  *** //

// If set, the NPC has been initialized
const int CSL_ANIM_FLAG_INITIALIZED             = 0x00000001;

// If set, the NPC will animate on every OnHeartbeat event.
// Otherwise, the NPC will animate only on every OnPerception event.
const int CSL_ANIM_FLAG_CONSTANT                = 0x00000002;

// If set, the NPC will use voicechats
const int CSL_ANIM_FLAG_CHATTER                 = 0x00000004;

// If set, the NPC has been triggered and should be animating
const int CSL_ANIM_FLAG_IS_ACTIVE               = 0x00000008;

// If set, the NPC is currently interacting with a placeable
const int CSL_ANIM_FLAG_IS_INTERACTING          = 0x00000010;

// If set, the NPC has gone inside an interior area.
const int CSL_ANIM_FLAG_IS_INSIDE               = 0x00000020;

// If set, the NPC has a home waypoint
const int CSL_ANIM_FLAG_HAS_HOME                = 0x00000040;

// If set, the NPC is currently talking
const int CSL_ANIM_FLAG_IS_TALKING              = 0x00000080;

// If set, the NPC is mobile
const int CSL_ANIM_FLAG_IS_MOBILE               = 0x00000100;

// If set, the NPC is mobile in a close-range
const int CSL_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE   = 0x00000200;

// If set, the NPC is civilized
const int CSL_ANIM_FLAG_IS_CIVILIZED            = 0x00000400;

// If set, the NPC will close doors
const int CSL_ANIM_FLAG_CLOSE_DOORS                             = 0x00001000;
*/


/////////////////////////////////////////////////////
//////////////// Includes ///////////////////////////
/////////////////////////////////////////////////////

#include "_CSLCore_Math"
#include "_CSLCore_Strings"
#include "_CSLCore_Position"
#include "_CSLCore_ObjectVars"


//////////////////////////
//////// VISUALS /////////
//////////////////////////


/////////////////////////////////////////////////////
//////////////// Prototypes /////////////////////////
/////////////////////////////////////////////////////

/*
int CSLGetHitEffectByDamageType(int iDamageType);
int CSLGetImpactEffectByDamageType(int iDamageType);
int CSLGetBreathConeEffectByDamageType(int iDamageType);
int CSLGetAOEEffectByDamageType(int iDamageType );
int CSLGetAOEExplodeByDamageType(int iDamageType, float fSize = RADIUS_SIZE_HUGE );
int CSLGetAOEWallByDamageType(int iDamageType );
int CSLGetBeamEffectByDamageType(int iDamageType );
int CSLGetMIRVEffectByDamageType( int iDamageType );
int CSLGetAOEWallByDamageType(int iDamageType );
int CSLGetWeaponEffectByDamageType(int iWeaponType, int iDamageType = DAMAGE_TYPE_ALL );

void CSLPlayCustomAnimation_Void(object oPC, string sAnimationName, int nLooping = FALSE, float fSpeed = 1.0f);
void CSLVoiceSound(object oPC, int nVoiceChat=0, string sSound="");

int CSLDontEmoteSpam(object oPC, float fDelay = 6.0);
*/

/////////////////////////////////////////////////////
//////////////// Implementation /////////////////////
/////////////////////////////////////////////////////



// this wraps screen fading with UI blocking to disable activity, this is just being tested
void CSLFadeScreenToBlack( object oCreature, float fSpeed=FADE_SPEED_MEDIUM, float fFailsafe=5.0, int nColor=0 )
{
	// this fades screen to black
	FadeToBlack( oCreature, fSpeed, fFailsafe, nColor);
	FadeFromBlack( oCreature, fSpeed );
	int bCommandable = FALSE;
	SetCommandable(bCommandable, oCreature);

	StopFade( oCreature);
	BlackScreen(oCreature, nColor );
	// blocks hotbars and throws up blocking UI

}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// imbue arrow
int CSLGetImpactEffectByDamageType(int iDamageType)
{
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFX_IMP_ACID_S;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFX_IMP_FROST_S;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFX_HIT_TURN_UNDEAD;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFX_IMP_LIGHTNING_S;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFX_IMP_FLAME_M;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFX_IMP_MAGBLUE;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFX_IMP_NEGATIVE_ENERGY;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFX_IMP_GOOD_HELP;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFX_IMP_SONIC; // VFX_HIT_SPELL_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFX_DUR_SPELL_BANE;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFX_DUR_SPELL_BANE;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFX_DUR_SPELL_BANE;
	return VFX_IMP_HEAD_ODD;
}






/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetHitEffectByDamageType(int iDamageType)
{
	if (iDamageType==DAMAGE_TYPE_ACID)			return VFX_HIT_SPELL_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)			return VFX_HIT_SPELL_ICE;
	if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFX_HIT_SPELL_HOLY; // VFX_HIT_SPELL_SEARING_LIGHT;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFX_HIT_SPELL_LIGHTNING;
	if (iDamageType==DAMAGE_TYPE_FIRE)			return VFX_HIT_SPELL_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFX_HIT_SPELL_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFX_HIT_SPELL_NECROMANCY; // VFX_HIT_SPELL_EVIL;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFX_HIT_SPELL_HOLY;
	if (iDamageType==DAMAGE_TYPE_SONIC)			return VFX_HIT_SPELL_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFX_HIT_SPELL_ENCHANTMENT; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFX_HIT_SPELL_ILLUSION; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFX_HIT_SPELL_DIVINATION; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_ALL)			return VFX_HIT_SPELL_MAGIC;
	return VFX_HIT_SPELL_MAGIC;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetContinuousDamageEffectByDamageType(int iDamageType)
{ // VFX_DUR_ELEMENTAL_SHIELD
	if (iDamageType==DAMAGE_TYPE_ACID)			return VFX_DUR_SPELL_MELFS_ACID_ARROW;
	//if (iDamageType==DAMAGE_TYPE_COLD)			return VFX_HIT_SPELL_ICE;
	//if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFX_HIT_SPELL_HOLY; // VFX_HIT_SPELL_SEARING_LIGHT;
	//if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFX_HIT_SPELL_LIGHTNING;
	if (iDamageType==DAMAGE_TYPE_FIRE)			return VFX_DUR_FIRE;
	//if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFX_HIT_SPELL_MAGIC;
	//if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFX_HIT_SPELL_NECROMANCY; // VFX_HIT_SPELL_EVIL;
	//if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFX_HIT_SPELL_HOLY;
	//if (iDamageType==DAMAGE_TYPE_SONIC)			return VFX_HIT_SPELL_SONIC;
	//if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFX_HIT_SPELL_ENCHANTMENT; // VFX_HIT_SPELL_MAGIC
	//if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFX_HIT_SPELL_ILLUSION; // VFX_HIT_SPELL_MAGIC
	//if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFX_HIT_SPELL_DIVINATION; // VFX_HIT_SPELL_MAGIC
	//if (iDamageType==DAMAGE_TYPE_ALL)			return VFX_HIT_SPELL_MAGIC;
	return VFX_DUR_SPELL_MELFS_ACID_ARROW;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetShieldEffectByDamageType(int iDamageType)
{ // 
	if (iDamageType==DAMAGE_TYPE_ACID)			{ return VFXSC_DUR_SPELLSHIELD_ACID; }
	if (iDamageType==DAMAGE_TYPE_COLD)			{ return VFXSC_DUR_SPELLSHIELD_COLD; }
	if (iDamageType==DAMAGE_TYPE_DIVINE)		{ return VFXSC_DUR_SPELLSHIELD_POSITIVE; }// VFX_HIT_SPELL_SEARING_LIGHT;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	{ return VFXSC_DUR_SPELLSHIELD_ELECTRICAL; }
	if (iDamageType==DAMAGE_TYPE_FIRE)			{ return VFXSC_DUR_SPELLSHIELD_FIRE; }
	if (iDamageType==DAMAGE_TYPE_MAGICAL)		{ return VFXSC_DUR_SPELLSHIELD_MAGIC; }
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)		{ return VFXSC_DUR_SPELLSHIELD_NEGATIVE; }// VFX_HIT_SPELL_EVIL;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)		{ return VFXSC_DUR_SPELLSHIELD_POSITIVE; }
	if (iDamageType==DAMAGE_TYPE_SONIC)			{ return VFXSC_DUR_SPELLSHIELD_SONIC; }
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	{ return VFXSC_DUR_SPELLSHIELD_BLOOD; }// VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_PIERCING)		{ return VFXSC_DUR_SPELLSHIELD_BLOOD; }// VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_SLASHING)		{ return VFXSC_DUR_SPELLSHIELD_BLOOD; }// VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_ALL)			{ return VFXSC_DUR_SPELLSHIELD_BLOOD; }
	return VFXSC_DUR_SPELLSHIELD_BLOOD;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSpellConeEffectByDamageType(int iDamageType)
{ // SC_SHAPE_SPELLCONE
	// These emanate from in front of the caster
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFXSC_DUR_SPELLCONELONG_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_DUR_SPELLCONELONG_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_DUR_SPELLCONELONG_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_DUR_SPELLCONELONG_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_DUR_SPELLCONELONG_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_DUR_SPELLCONELONG_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_DUR_SPELLCONELONG_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_DUR_SPELLCONELONG_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_DUR_SPELLCONELONG_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFXSC_DUR_SPELLCONELONG_MAGIC;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFXSC_DUR_SPELLCONELONG_MAGIC;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFXSC_DUR_SPELLCONELONG_MAGIC;
/* These emanate from the hand, which can look a little off
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFXSC_DUR_SPELLCONEHAND_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_DUR_SPELLCONEHAND_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_DUR_SPELLCONEHAND_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_DUR_SPELLCONEHAND_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_DUR_SPELLCONEHAND_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_DUR_SPELLCONEHAND_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_DUR_SPELLCONEHAND_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_DUR_SPELLCONEHAND_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_DUR_SPELLCONEHAND_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFXSC_DUR_SPELLCONEHAND_MAGIC;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFXSC_DUR_SPELLCONEHAND_MAGIC;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFXSC_DUR_SPELLCONEHAND_MAGIC;
*/
	return VFXSC_DUR_SPELLCONEHAND_MAGIC;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetShortConeShortEffectByDamageType(int iDamageType)
{ // SC_SHAPE_SPELLCONE
	
	// These emanate from in front of the caster
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFXSC_DUR_SPELLCONESHORT_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_DUR_SPELLCONESHORT_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_DUR_SPELLCONESHORT_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_DUR_SPELLCONESHORT_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_DUR_SPELLCONESHORT_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_DUR_SPELLCONESHORT_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_DUR_SPELLCONESHORT_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_DUR_SPELLCONESHORT_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_DUR_SPELLCONESHORT_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFXSC_DUR_SPELLCONESHORT_MAGIC;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFXSC_DUR_SPELLCONESHORT_MAGIC;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFXSC_DUR_SPELLCONESHORT_MAGIC;
/* These emanate from the hand, which can look a little off
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFXSC_DUR_SPELLCONEHAND_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_DUR_SPELLCONEHAND_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_DUR_SPELLCONEHAND_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_DUR_SPELLCONEHAND_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_DUR_SPELLCONEHAND_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_DUR_SPELLCONEHAND_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_DUR_SPELLCONEHAND_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_DUR_SPELLCONEHAND_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_DUR_SPELLCONEHAND_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFXSC_DUR_SPELLCONEHAND_MAGIC;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFXSC_DUR_SPELLCONEHAND_MAGIC;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFXSC_DUR_SPELLCONEHAND_MAGIC;
*/
	return VFXSC_DUR_SPELLCONESHORT_MAGIC;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetBreathConeEffectByDamageType(int iDamageType)
{ // SC_SHAPE_BREATHCONE
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFX_DUR_CONE_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFX_DUR_CONE_ICE;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFX_DUR_CONE_HOLY;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFX_DUR_CONE_LIGHTNING;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFX_DUR_CONE_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFX_DUR_CONE_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFX_DUR_CONE_EVIL;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFX_DUR_CONE_HOLY;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFX_DUR_CONE_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFX_DUR_CONE_MAGIC;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFX_DUR_CONE_MAGIC;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFX_DUR_CONE_MAGIC;
	return VFX_DUR_CONE_MAGIC;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAOEEffectByDamageType(int iDamageType )
{ // SC_SHAPE_AOE
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFX_HIT_AOE_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFX_HIT_AOE_ICE;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFX_HIT_AOE_HOLY;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFX_HIT_AOE_LIGHTNING;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFX_HIT_AOE_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFX_HIT_AOE_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFX_HIT_AOE_NECROMANCY;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFX_HIT_AOE_DIVINATION;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFX_HIT_AOE_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFX_HIT_AOE_EVOCATION;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFX_HIT_AOE_EVOCATION;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFX_HIT_AOE_EVOCATION;
	return VFX_HIT_AOE_EVOCATION;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetAOEExplodeByDamageType(int iDamageType, float fSize = RADIUS_SIZE_HUGE )
{  // SC_SHAPE_AOEEXPLODE
	
	if ( fSize >= RADIUS_SIZE_TREMENDOUS )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)       return  VFXSC_FNF_BURST_TREM_ACID; // 2300;
		if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_FNF_BURST_TREM_COLD; // 2301;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_FNF_BURST_TREM_ELECTRICAL; // 2302;
		if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_FNF_BURST_TREM_FIRE; // 2303;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_FNF_BURST_TREM_NEGATIVE; // 2304;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_FNF_BURST_TREM_POSITIVE; // 2305;
		if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_FNF_BURST_TREM_SONIC; // 2306;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_FNF_BURST_TREM_MAGIC; // 2307;
		if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_FNF_BURST_TREM_HOLY; // 2308;
		//const int VFXSC_FNF_BURST_TREM_BLESS; // 2309;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)  return VFXSC_FNF_BURST_TREM_ELDRITCH; // 2310;
		if (iDamageType==DAMAGE_TYPE_PIERCING)     return VFXSC_FNF_BURST_TREM_ELDRITCH; // 2310;
		if (iDamageType==DAMAGE_TYPE_SLASHING)     return VFXSC_FNF_BURST_TREM_ELDRITCH; // 2310;
		return VFXSC_FNF_BURST_TREM_SMOKEPUFF; // 2311
	}
	else if ( fSize >= RADIUS_SIZE_COLOSSAL )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)       return  VFXSC_FNF_BURST_COLOS_ACID; // 2315;
		if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_FNF_BURST_COLOS_COLD; // 2316;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_FNF_BURST_COLOS_ELECTRICAL; // 2317;
		if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_FNF_BURST_COLOS_FIRE; // 2318;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_FNF_BURST_COLOS_NEGATIVE; // 2319;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_FNF_BURST_COLOS_POSITIVE; // 2320;
		if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_FNF_BURST_COLOS_SONIC; // 2321;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_FNF_BURST_COLOS_MAGIC; // 2322;
		if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_FNF_BURST_COLOS_HOLY; // 2323;
		//const int VFXSC_FNF_BURST_COLOS_BLESS; // 2324;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)  return VFXSC_FNF_BURST_COLOS_ELDRITCH; // 2325;
		if (iDamageType==DAMAGE_TYPE_PIERCING)     return VFXSC_FNF_BURST_COLOS_ELDRITCH; // 2325;
		if (iDamageType==DAMAGE_TYPE_SLASHING)     return VFXSC_FNF_BURST_COLOS_ELDRITCH; // 2325;
		return VFXSC_FNF_BURST_COLOS_SMOKEPUFF; // 2326
	}
	else if ( fSize >= RADIUS_SIZE_HUGE )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)       return  VFXSC_FNF_BURST_HUGE_ACID; // 2330;
		if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_FNF_BURST_HUGE_COLD; // 2331;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_FNF_BURST_HUGE_ELECTRICAL; // 2332;
		if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_FNF_BURST_HUGE_FIRE; // 2333;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_FNF_BURST_HUGE_NEGATIVE; // 2334;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_FNF_BURST_HUGE_POSITIVE; // 2335;
		if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_FNF_BURST_HUGE_SONIC; // 2336;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_FNF_BURST_HUGE_MAGIC; // 2337;
		if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_FNF_BURST_HUGE_HOLY; // 2338;
		//const int VFXSC_FNF_BURST_HUGE_BLESS; // 2339;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)  return VFXSC_FNF_BURST_HUGE_ELDRITCH; // 2340;
		if (iDamageType==DAMAGE_TYPE_PIERCING)     return VFXSC_FNF_BURST_HUGE_ELDRITCH; // 2340;
		if (iDamageType==DAMAGE_TYPE_SLASHING)     return VFXSC_FNF_BURST_HUGE_ELDRITCH; // 2340;
		return VFXSC_FNF_BURST_HUGE_SMOKEPUFF; // 2341
	}
	else if ( fSize >= RADIUS_SIZE_MEDIUM )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)       return  VFXSC_FNF_BURST_MEDIUM_ACID; // 2345;
		if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_FNF_BURST_MEDIUM_COLD; // 2346;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_FNF_BURST_MEDIUM_ELECTRICAL; // 2347;
		if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_FNF_BURST_MEDIUM_FIRE; // 2348;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_FNF_BURST_MEDIUM_NEGATIVE; // 2349;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_FNF_BURST_MEDIUM_POSITIVE; // 2350;
		if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_FNF_BURST_MEDIUM_SONIC; // 2351;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_FNF_BURST_MEDIUM_MAGIC; // 2352;
		if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_FNF_BURST_MEDIUM_HOLY; // 2353;
		//const int VFXSC_FNF_BURST_MEDIUM_BLESS; // 2354;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)  return VFXSC_FNF_BURST_MEDIUM_ELDRITCH; // 2355;
		if (iDamageType==DAMAGE_TYPE_PIERCING)     return VFXSC_FNF_BURST_MEDIUM_ELDRITCH; // 2355;
		if (iDamageType==DAMAGE_TYPE_SLASHING)     return VFXSC_FNF_BURST_MEDIUM_ELDRITCH; // 2355;
		return VFXSC_FNF_BURST_MEDIUM_SMOKEPUFF; // 2356
	}
	else //if ( fSize >= RADIUS_SIZE_SMALL )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)       return  VFXSC_FNF_BURST_SMALL_ACID; // 2360;
		if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_FNF_BURST_SMALL_COLD; // 2361;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_FNF_BURST_SMALL_ELECTRICAL; // 2362;
		if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_FNF_BURST_SMALL_FIRE; // 2363;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_FNF_BURST_SMALL_NEGATIVE; // 2364;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_FNF_BURST_SMALL_POSITIVE; // 2365;
		if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_FNF_BURST_SMALL_SONIC; // 2366;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_FNF_BURST_SMALL_MAGIC; // 2367;
		if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_FNF_BURST_SMALL_HOLY; // 2368;
		//const int VFXSC_FNF_BURST_SMALL_BLESS; // 2369;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)  return VFXSC_FNF_BURST_SMALL_ELDRITCH; // 2370;
		if (iDamageType==DAMAGE_TYPE_PIERCING)     return VFXSC_FNF_BURST_SMALL_ELDRITCH; // 2370;
		if (iDamageType==DAMAGE_TYPE_SLASHING)     return VFXSC_FNF_BURST_SMALL_ELDRITCH; // 2370;
		return VFXSC_FNF_BURST_SMALL_SMOKEPUFF; // 2371
	}
	return VFXSC_FNF_BURST_MEDIUM_SMOKEPUFF;
	
	
	/*
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFXSC_FNF_EXPLODE_ACID; // 1610
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_FNF_EXPLODE_COLD; //  1611
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_FNF_EXPLODE_HOLY; // 1618
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_FNF_EXPLODE_ELECTRICAL; // 1612
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_FNF_EXPLODE_FIRE; // 1613
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_FNF_EXPLODE_MAGIC; // 1617
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_FNF_EXPLODE_NEGATIVE; // 1614
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_FNF_EXPLODE_POSITIVE; // 1615
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_FNF_EXPLODE_SONIC; // 1616 
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING) return VFXSC_FNF_EXPLODE_ELDRITCH; // 1620
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFXSC_FNF_EXPLODE_ELDRITCH; // 1620
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFXSC_FNF_EXPLODE_ELDRITCH; // 1620
	return VFX_FNF_SMOKE_PUFF;
	*/
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetCloudByDamageType(int iDamageType, float fSize = RADIUS_SIZE_HUGE )
{  // SC_SHAPE_AOEEXPLODE
	
	if ( fSize >= RADIUS_SIZE_TREMENDOUS )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)       return  VFXSC_CLOUD_TM_ACID; // 2300;
		if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_CLOUD_TM_COLD; // 2301;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_CLOUD_TM_ELECTRICAL; // 2302;
		if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_CLOUD_TM_FIRE; // 2303;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_CLOUD_TM_NEGATIVE; // 2304;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_CLOUD_TM_POSITIVE; // 2305;
		if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_CLOUD_TM_SONIC; // 2306;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_CLOUD_TM_MAGIC; // 2307;
		if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_CLOUD_TM_POSITIVE; // 2308;
		//const int VFXSC_FNF_BURST_TREM_BLESS; // 2309;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)  return VFXSC_CLOUD_TM_SMOKE; // 2310;
		if (iDamageType==DAMAGE_TYPE_PIERCING)     return VFXSC_CLOUD_TM_SMOKE; // 2310;
		if (iDamageType==DAMAGE_TYPE_SLASHING)     return VFXSC_CLOUD_TM_SMOKE; // 2310;
		return VFXSC_FNF_BURST_TREM_SMOKEPUFF; // 2311
	}
	else if ( fSize >= RADIUS_SIZE_COLOSSAL )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)       return  VFXSC_CLOUD_CL_ACID; // 2315;
		if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_CLOUD_CL_COLD; // 2316;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_CLOUD_CL_ELECTRICAL; // 2317;
		if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_CLOUD_CL_FIRE; // 2318;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_CLOUD_CL_NEGATIVE; // 2319;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_CLOUD_CL_POSITIVE; // 2320;
		if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_CLOUD_CL_SONIC; // 2321;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_CLOUD_CL_MAGIC; // 2322;
		if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_CLOUD_CL_POSITIVE; // 2323;
		//const int VFXSC_FNF_BURST_COLOS_BLESS; // 2324;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)  return VFXSC_CLOUD_CL_SMOKE; // 2325;
		if (iDamageType==DAMAGE_TYPE_PIERCING)     return VFXSC_CLOUD_CL_SMOKE; // 2325;
		if (iDamageType==DAMAGE_TYPE_SLASHING)     return VFXSC_CLOUD_CL_SMOKE; // 2325;
		return VFXSC_FNF_BURST_COLOS_SMOKEPUFF; // 2326
	}
	else ///if ( fSize >= RADIUS_SIZE_HUGE )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)       return  VFXSC_CLOUD_HG_ACID; // 2330;
		if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_CLOUD_HG_COLD; // 2331;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_CLOUD_HG_ELECTRICAL; // 2332;
		if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_CLOUD_HG_FIRE; // 2333;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_CLOUD_HG_NEGATIVE; // 2334;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_CLOUD_HG_POSITIVE; // 2335;
		if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_CLOUD_HG_SONIC; // 2336;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_CLOUD_HG_MAGIC; // 2337;
		if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_CLOUD_HG_POSITIVE; // 2338;
		//const int VFXSC_FNF_BURST_HUGE_BLESS; // 2339;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)  return VFXSC_CLOUD_HG_SMOKE; // 2340;
		if (iDamageType==DAMAGE_TYPE_PIERCING)     return VFXSC_CLOUD_HG_SMOKE; // 2340;
		if (iDamageType==DAMAGE_TYPE_SLASHING)     return VFXSC_CLOUD_HG_SMOKE; // 2340;
		return VFXSC_FNF_BURST_HUGE_SMOKEPUFF; // 2341
	}
	
	return VFXSC_CLOUD_HG_SMOKE;
}



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetFlameAuraByDamageType(int iDamageType )
{  // SC_SHAPE_AOEEXPLODE
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFXSC_DUR_SPELLFLAMES_ACID; // <-- put in 448 on visualeffects.2da as well
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_DUR_SPELLFLAMES_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_DUR_SPELLFLAMES_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_DUR_SPELLFLAMES_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_DUR_SPELLFLAMES_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_DUR_SPELLFLAMES_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_DUR_SPELLFLAMES_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_DUR_SPELLFLAMES_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_DUR_SPELLFLAMES_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFXSC_DUR_SPELLFLAMES_MAGIC;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFXSC_DUR_SPELLFLAMES_MAGIC;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFXSC_DUR_SPELLFLAMES_MAGIC;
	return VFXSC_DUR_SPELLFLAMES_MAGIC;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetFaeryAuraByDamageType(int iDamageType )
{  // SC_SHAPE_AOEEXPLODE
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFXSC_DUR_FAERYAURA_ACID; // <-- put in 448 on visualeffects.2da as well
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFXSC_DUR_FAERYAURA_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFXSC_DUR_FAERYAURA_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFXSC_DUR_FAERYAURA_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFXSC_DUR_FAERYAURA_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFXSC_DUR_FAERYAURA_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFXSC_DUR_FAERYAURA_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFXSC_DUR_FAERYAURA_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFXSC_DUR_FAERYAURA_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFXSC_DUR_FAERYAURA_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFXSC_DUR_FAERYAURA_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFXSC_DUR_FAERYAURA_POSITIVE;
	return VFXSC_DUR_FAERYAURA_POSITIVE;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetBeamEffectByDamageType(int iDamageType )
{ // SC_SHAPE_BEAM
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFX_BEAM_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFX_BEAM_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return VFX_BEAM_HOLY;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFX_BEAM_LIGHTNING;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFX_BEAM_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return VFX_BEAM_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return VFX_BEAM_NECROMANCY;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return VFX_BEAM_HOLY;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFX_BEAM_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)return VFX_BEAM_MAGIC;
	if (iDamageType==DAMAGE_TYPE_PIERCING)   return VFX_BEAM_MAGIC;
	if (iDamageType==DAMAGE_TYPE_SLASHING)   return VFX_BEAM_MAGIC;
	return VFX_BEAM_MAGIC;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetMIRVEffectByDamageType( int iDamageType )
{
	if (iDamageType==DAMAGE_TYPE_ACID)       return VFX_DUR_MIRV_ACID;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return VFX_IMP_MIRV_ELECTRIC;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return VFX_IMP_MIRV_FLAME;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return VFX_IMP_MIRV;
	if (iDamageType==DAMAGE_TYPE_COLD)       return VFX_IMP_MIRV;
	return VFX_IMP_MIRV;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// * gets a reference to vfx persistent so i can do walls ( need custom wall sefs and custom vfx persistent for this )
// * this refers to the ID of the area of effect
int CSLGetAOEWallByDamageType(int iDamageType )
{ // SC_SHAPE_WALL
	if (iDamageType==DAMAGE_TYPE_ACID)       return AOE_PER_WALLACID;
	if (iDamageType==DAMAGE_TYPE_COLD)       return AOE_PER_WALLCOLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)     return AOE_PER_WALLPOSITIVE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL) return AOE_PER_WALLELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)       return AOE_PER_WALLFIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)    return AOE_PER_WALLPOSITIVE;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)   return AOE_PER_WALLNEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)   return AOE_PER_WALLPOSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)      return AOE_PER_WALLSONIC;
	return AOE_PER_WALLFIRE;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
int CSLGetSkinEffectByDamageType(int iDamageType)
{ // 
	if (iDamageType==DAMAGE_TYPE_ACID)			return VFX_DUR_PROT_STONESKIN;
	if (iDamageType==DAMAGE_TYPE_COLD)			return VFX_DUR_ICESKIN;
	if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFX_DUR_PROT_STONESKIN; // VFX_HIT_SPELL_SEARING_LIGHT;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFX_DUR_PROT_STONESKIN;
	if (iDamageType==DAMAGE_TYPE_FIRE)			return VFX_DUR_PROT_STONESKIN;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFX_DUR_PROT_STONESKIN;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFX_DUR_DEATH_ARMOR; // VFX_HIT_SPELL_EVIL;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFX_DUR_PROT_STONESKIN;
	if (iDamageType==DAMAGE_TYPE_SONIC)			return VFX_DUR_PROT_STONESKIN;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFX_DUR_PROT_STONESKIN; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFX_DUR_PROT_STONESKIN; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFX_DUR_PROT_STONESKIN; // VFX_HIT_SPELL_MAGIC
	if (iDamageType==DAMAGE_TYPE_ALL)			return VFX_DUR_PROT_STONESKIN;
	return VFX_DUR_PROT_STONESKIN;
}

//VFX_DUR_PROT_SHADOW_ARMOR
//VFX_DUR_PROT_BARKSKIN
//VFX_DUR_ETHEREAL_VISAGE
//VFX_DUR_GHOSTLY_VISAGE



/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
/*
Virtual Weapons - Creates an illusionary weapon effect to allow spells to simulate a weapon attack, to be used in conjunction with animations of various sorts

Damage types
Fire, Cold, Electrical, Fire, Negative, Positive, Sonic, Magic, Force, Eldritch

Proposed weapons - generally oversized ones
Spear(glaive,trident), Dagger, Sword(s), Hammer(s), Mace, Trident, Glaive?, Scythe, Battleaxe, Bow, Shield, perhaps whip as an added feature ( for gedlee's electric whip )

*/
int CSLGetWeaponEffectByDamageType(int iWeaponType, int iDamageType = DAMAGE_TYPE_ALL ) // int iOriginalEffect = 0
{ // 
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_SPEAR ) // 
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_SPEAR_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_SPEAR_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_SPEAR_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_SPEAR_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_SPEAR_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_SPEAR_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_SPEAR_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_SPEAR_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_SPEAR_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_SPEAR;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_SPEAR;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_SPEAR;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_SPEAR;
		return VFXSC_DUR_SPELLWEAP_SPEAR;
	}
	
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_HAMMER ) // Spiritual Hammer
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_HAMMER_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_HAMMER_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_HAMMER_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_HAMMER_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_HAMMER_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_HAMMER_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_HAMMER_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_HAMMER_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_HAMMER_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_HAMMER;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_HAMMER;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_HAMMER;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_HAMMER;
		return VFXSC_DUR_SPELLWEAP_HAMMER;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_DAGGER ) // a weaker form mainly of the sword
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_DAGGER_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_DAGGER_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_DAGGER_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_DAGGER_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_DAGGER_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_DAGGER_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_DAGGER_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_DAGGER_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_DAGGER_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_DAGGER;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_DAGGER;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_DAGGER;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_DAGGER;
		return VFXSC_DUR_SPELLWEAP_DAGGER;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_MACE ) // for paladin spells ( disruption )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_MACE_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_MACE_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_MACE_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_MACE_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_MACE_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_MACE_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_MACE_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_MACE_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_MACE_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_MACE;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_MACE;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_MACE;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_MACE;
		return VFXSC_DUR_SPELLWEAP_MACE;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_TRIDENT ) // for underwater areas
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_TRIDENT_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_TRIDENT_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_TRIDENT_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_TRIDENT_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_TRIDENT_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_TRIDENT_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_TRIDENT_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_TRIDENT_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_TRIDENT_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_TRIDENT;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_TRIDENT;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_TRIDENT;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_TRIDENT;
		return VFXSC_DUR_SPELLWEAP_TRIDENT;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_GLAIVE ) // for the warlock glaive mainly
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_GLAIVE_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_GLAIVE_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_GLAIVE_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_GLAIVE_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_GLAIVE_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_GLAIVE_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_GLAIVE_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_GLAIVE_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_GLAIVE_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_GLAIVE;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_GLAIVE;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_GLAIVE;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_GLAIVE;
		return VFXSC_DUR_SPELLWEAP_GLAIVE;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_PITCHFORK ) // for demonic
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_PITCHFORK_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_PITCHFORK_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_PITCHFORK_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_PITCHFORK_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_PITCHFORK_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_PITCHFORK_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_PITCHFORK_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_PITCHFORK_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_PITCHFORK_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_PITCHFORK;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_PITCHFORK;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_PITCHFORK;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_PITCHFORK;
		return VFXSC_DUR_SPELLWEAP_PITCHFORK;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_SCYTHE )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_SCYTHE_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_SCYTHE_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_SCYTHE_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_SCYTHE_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_SCYTHE_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_SCYTHE_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_SCYTHE_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_SCYTHE_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_SCYTHE_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_SCYTHE;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_SCYTHE;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_SCYTHE;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_SCYTHE;
		return VFXSC_DUR_SPELLWEAP_SCYTHE;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_BATTLEAXE )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_BATTLEAXE_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_BATTLEAXE_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_BATTLEAXE_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_BATTLEAXE;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_BATTLEAXE;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_BATTLEAXE;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_BATTLEAXE;
		return VFXSC_DUR_SPELLWEAP_BATTLEAXE;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_BOW )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_BOW_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_BOW_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_BOW_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_BOW_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_BOW_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_BOW_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_BOW_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_BOW_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_BOW_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_BOW;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_BOW;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_BOW;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_BOW;
		return VFXSC_DUR_SPELLWEAP_BOW;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_SHIELD )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_SHIELD_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_SHIELD_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_SHIELD_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_SHIELD_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_SHIELD_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_SHIELD_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_SHIELD_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_SHIELD_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_SHIELD_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_SHIELD;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_SHIELD;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_SHIELD;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_SHIELD;
		return VFXSC_DUR_SPELLWEAP_SHIELD;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_ARMOR )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_ARMOR_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_ARMOR_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_ARMOR_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_ARMOR_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_ARMOR_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_ARMOR_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_ARMOR_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_ARMOR_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_ARMOR_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_ARMOR;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_ARMOR;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_ARMOR;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_ARMOR;
		return VFXSC_DUR_SPELLWEAP_ARMOR;
	}
	if ( iWeaponType == SC_SHAPE_SPELLWEAP_WHIP )
	{
		if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_WHIP_ACID;
		if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_WHIP_COLD;
		if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_WHIP_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_WHIP_ELECTRICAL;
		if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_WHIP_FIRE;
		if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_WHIP_MAGIC;
		if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_WHIP_NEGATIVE;
		if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_WHIP_POSITIVE;
		if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_WHIP_SONIC;
		if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_WHIP;
		if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_WHIP;
		if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_WHIP;
		if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_WHIP;
		return VFXSC_DUR_SPELLWEAP_WHIP;
	}
	// default is sword
	if (iDamageType==DAMAGE_TYPE_ACID)			return VFXSC_DUR_SPELLWEAP_SWORD_ACID;
	if (iDamageType==DAMAGE_TYPE_COLD)			return VFXSC_DUR_SPELLWEAP_SWORD_COLD;
	if (iDamageType==DAMAGE_TYPE_DIVINE)		return VFXSC_DUR_SPELLWEAP_SWORD_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_ELECTRICAL)	return VFXSC_DUR_SPELLWEAP_SWORD_ELECTRICAL;
	if (iDamageType==DAMAGE_TYPE_FIRE)			return VFXSC_DUR_SPELLWEAP_SWORD_FIRE;
	if (iDamageType==DAMAGE_TYPE_MAGICAL)		return VFXSC_DUR_SPELLWEAP_SWORD_MAGIC;
	if (iDamageType==DAMAGE_TYPE_NEGATIVE)		return VFXSC_DUR_SPELLWEAP_SWORD_NEGATIVE;
	if (iDamageType==DAMAGE_TYPE_POSITIVE)		return VFXSC_DUR_SPELLWEAP_SWORD_POSITIVE;
	if (iDamageType==DAMAGE_TYPE_SONIC)			return VFXSC_DUR_SPELLWEAP_SWORD_SONIC;
	if (iDamageType==DAMAGE_TYPE_BLUDGEONING)	return VFXSC_DUR_SPELLWEAP_SWORD;
	if (iDamageType==DAMAGE_TYPE_PIERCING)		return VFXSC_DUR_SPELLWEAP_SWORD;
	if (iDamageType==DAMAGE_TYPE_SLASHING)		return VFXSC_DUR_SPELLWEAP_SWORD;
	if (iDamageType==DAMAGE_TYPE_ALL)			return VFXSC_DUR_SPELLWEAP_SWORD;
	return VFXSC_DUR_SPELLWEAP_SWORD;
		
		
	
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Returns an interger for oWeapon coresponding to the sound type it makes.
int GetWeaponSoundType(object oWeapon)
{
	int nWeapon = GetBaseItemType(oWeapon);
	int nSound;
	
	switch (nWeapon)
	{
		case BASE_ITEM_ALLUSE_SWORD:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_BASTARDSWORD:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_BASTARDSWORD_R:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_BATTLEAXE:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_BATTLEAXE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_DOUBLEAXE:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_DWARVENWARAXE:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_DWARVENWARAXE_R:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_FALCHION:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_FALCHION_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_GREATAXE:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_GREATAXE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_GREATSWORD:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_GREATSWORD_R:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_HALBERD:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_HALBERD_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_HANDAXE:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_HANDAXE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_KAMA:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_KAMA_R:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_KATANA:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_KATANA_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_LONGSWORD:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_LONGSWORD_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_RAPIER:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_RAPIER_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SCIMITAR:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SCIMITAR_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SCYTHE:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SCYTHE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SHORTSPEAR:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SHORTSWORD:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SHORTSWORD_R:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SICKLE:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SICKLE_R:		nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SPEAR:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_SPEAR_R:			nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_TWOBLADEDSWORD:	nSound = SOUND_TYPE_BLADE;	break;
		case BASE_ITEM_CLUB:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_CLUB_R:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_DIREMACE:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_GREATCLUB:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_GREATCLUB_R:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_LIGHTHAMMER:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_LIGHTHAMMER_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_LIGHTMACE:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MACE:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MACE_R:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MAGICROD:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MAGICSTAFF:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MAGICSTAFF_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MORNINGSTAR:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_MORNINGSTAR_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_QUARTERSTAFF:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_QUARTERSTAFF_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_TRAINING_CLUB:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_TRAINING_CLUB_R:	nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_WARHAMMER:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_WARHAMMER_R:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_WARMACE:			nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_WARMACE_R:		nSound = SOUND_TYPE_BLUNT;	break;
		case BASE_ITEM_DART:			nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_GRENADE:			nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_HEAVYCROSSBOW:	nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_LIGHTCROSSBOW:	nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_LONGBOW:			nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_SHORTBOW:		nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_SHURIKEN:		nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_SLING:			nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_THROWINGAXE:		nSound = SOUND_TYPE_RANGED;	break;
		case BASE_ITEM_DAGGER:			nSound = SOUND_TYPE_DAGGER;	break;
		case BASE_ITEM_DAGGER_R:		nSound = SOUND_TYPE_DAGGER;	break;
		case BASE_ITEM_KUKRI:			nSound = SOUND_TYPE_DAGGER;	break;
		case BASE_ITEM_KUKRI_R:			nSound = SOUND_TYPE_DAGGER;	break;
		case BASE_ITEM_WHIP:			nSound = SOUND_TYPE_WHIP;	break; //Just in case anyone ever adds them, the sound file does actually exist.
		case BASE_ITEM_WHIP_R:			nSound = SOUND_TYPE_WHIP;	break;
		default:						nSound = SOUND_TYPE_INVALID;break;
	}
	
	return nSound;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Returns the material sound of oWeapon if GetWeaponSoundType returns SOUND_TYPE_BLUNT.
int GetBluntWeaponSound(object oWeapon)
{
	int nWeapon = GetBaseItemType(oWeapon);
	int nSound;
	
	switch (nWeapon)
	{
		case BASE_ITEM_DIREMACE:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_LIGHTHAMMER:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_LIGHTHAMMER_R:	nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_LIGHTMACE:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MACE:			nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MACE_R:			nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MAGICROD:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MORNINGSTAR:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_MORNINGSTAR_R:	nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_WARHAMMER:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_WARHAMMER_R:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_WARMACE:			nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_WARMACE_R:		nSound = SOUND_TYPE_METAL;	break;
		case BASE_ITEM_CLUB:			nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_CLUB_R:			nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_GREATCLUB:		nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_GREATCLUB_R:		nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_MAGICSTAFF:		nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_MAGICSTAFF_R:	nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_QUARTERSTAFF:	nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_QUARTERSTAFF_R:	nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_TRAINING_CLUB:	nSound = SOUND_TYPE_WOOD;	break;
		case BASE_ITEM_TRAINING_CLUB_R:	nSound = SOUND_TYPE_WOOD;	break;
		default:						nSound = SOUND_TYPE_INVALID;break;
	}
	
	return nSound;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
// Plays an OnHit sound corresponding to the appropriate item property.
// Unlike weapon damage sounds these can be played simultaneously.
// -oWeapon: The item we're getting properties from.
// -oFoe: Deterimines where the sound will be played.
void StrikeItemPropSound(object oWeapon, object oFoe)
{
	object oPC = OBJECT_SELF;
	location lFoe = GetLocation(oFoe);
	itemproperty iProp = GetFirstItemProperty(oWeapon);
	
	while (GetIsItemPropertyValid(iProp))
	{
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_DAMAGE_BONUS)
		{	
			switch (GetItemPropertySubType(iProp))
			{
				case IP_CONST_DAMAGETYPE_ACID:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_acid", lFoe); break;
				case IP_CONST_DAMAGETYPE_COLD:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_cold", lFoe); break;
				case IP_CONST_DAMAGETYPE_DIVINE:		CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_holy", lFoe); break;
				case IP_CONST_DAMAGETYPE_ELECTRICAL:	CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_elec", lFoe); break;
				case IP_CONST_DAMAGETYPE_FIRE:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_fire", lFoe); break;							
				case IP_CONST_DAMAGETYPE_NEGATIVE:		CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_DAMAGETYPE_POSITIVE:		CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_holy", lFoe); break;
				case IP_CONST_DAMAGETYPE_SONIC:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_holy", lFoe); break;
			}
		}		
/*		else if (GetItemPropertyType(iProp) == ITEM_PROPERTY_ON_HIT_PROPERTIES) //Commented out until I can make these sounds only active when the effect beats the DC.
		{
			switch (GetItemPropertySubType(iProp))
			{
				case IP_CONST_ONHIT_ABILITYDRAIN:		CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_BLINDNESS:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_CONFUSION:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_DAZE:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_DEAFNESS:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_DISEASE:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_acid", lFoe); break;
				case IP_CONST_ONHIT_DISPELMAGIC:		CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);  break;
				case IP_CONST_ONHIT_DOOM:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_FEAR:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_GREATERDISPEL:		CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);  break;
				case IP_CONST_ONHIT_HOLD:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_ITEMPOISON:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_acid", lFoe); break;
				case IP_CONST_ONHIT_KNOCK:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);  break;
				case IP_CONST_ONHIT_LESSERDISPEL:		CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);	 break;
				case IP_CONST_ONHIT_LEVELDRAIN:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_MORDSDISJUNCTION:	CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dis", lFoe);  break;
				case IP_CONST_ONHIT_SILENCE:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_SLEEP:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_SLOW:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_STUN:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_VORPAL:				CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
				case IP_CONST_ONHIT_WOUNDING:			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); break;
			}
		}*/
		
		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_HOLY_AVENGER)
		{
			CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_holy", lFoe);
		}

		if (GetItemPropertyType(iProp) == ITEM_PROPERTY_REGENERATION_VAMPIRIC)
		{
		 	CSLWrapperCreateObject(OBJECT_TYPE_CREATURE, "c_soundfx_i_dark", lFoe); 
		}

		iProp = GetNextItemProperty(oWeapon);
	}
}




/**  
* Returns duration of the given animation string, add any new animations ot this function as needed
* Based on listing provided by Cerea2 http://www.cerea2.com/index.php?option=com_openwiki&Itemid=50&id=players:animations&rev=1180528722
* @author
* @param sAnimationName Name of the animation
* @param iGender GENDER_MALE or GENDER_FEMALE
* @see 
* @return 
*/
float CSLGetAnimationDuration( string sAnimationName, int iGender )
{
	iGender = ( iGender != GENDER_FEMALE ) ? GENDER_MALE : GENDER_FEMALE;
	
	sAnimationName = GetStringLowerCase(sAnimationName); // make sure it's lower case
	
	//SendMessageToPC( GetFirstPC(), "For "+sAnimationName+" we return "+IntToString( CSLAlphabeticalSortConstant( sAnimationName ) ) );
	switch ( CSLAlphabeticalSortConstant( sAnimationName ) )
	{
		
		case CSL_LETTER_NA: // not a letter, can be number or a space
			if ( sAnimationName == "%" )	{ return ( iGender == GENDER_MALE ) ? 0.01f : 0.01f; }
			break;
		case CSL_LETTER_A:
			if ( sAnimationName == "activate" )	{ return ( iGender == GENDER_MALE ) ? 1.36f : 1.53f; }
			if ( sAnimationName == "annoyed" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "atk_cast" )	{ return ( iGender == GENDER_MALE ) ? 2.03f : 2.0f; }
			if ( sAnimationName == "atk_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "atk_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "attention" )	{ return ( iGender == GENDER_MALE ) ? 2.53f : 1.66f; }
			break;
		case CSL_LETTER_B:
			if ( sAnimationName == "bardsong" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "bored" )	{ return ( iGender == GENDER_MALE ) ? 16.03f : 6.66f; }
			if ( sAnimationName == "bow" )	{ return ( iGender == GENDER_MALE ) ? 3.93f : 2.33f; }
			if ( sAnimationName == "bsd_cast" )	{ return ( iGender == GENDER_MALE ) ? 1.33f : 1.33f; }
			if ( sAnimationName == "bsd_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "bsd_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "bsf_cast" )	{ return ( iGender == GENDER_MALE ) ? 1.33f : 1.33f; }
			if ( sAnimationName == "bsf_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "bsf_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "bsl_cast" )	{ return ( iGender == GENDER_MALE ) ? 1.33f : 1.33f; }
			if ( sAnimationName == "bsl_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "bsl_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "bss_cast" )	{ return ( iGender == GENDER_MALE ) ? 1.33f : 1.33f; }
			if ( sAnimationName == "bss_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "bss_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			break;
		case CSL_LETTER_C:
			if ( sAnimationName == "chuckle" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "clapping" )	{ return ( iGender == GENDER_MALE ) ? 3.46f : 3.33f; }
			if ( sAnimationName == "collapseb" )	{ return ( iGender == GENDER_MALE ) ? 2.26f : 2.66f; }
			if ( sAnimationName == "cooking01" )	{ return ( iGender == GENDER_MALE ) ? 5.83f : 5.83f; }
			if ( sAnimationName == "cooking02" )	{ return ( iGender == GENDER_MALE ) ? 4.0f : 4.0f; }
			if ( sAnimationName == "craft01" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "crying" )	{ return ( iGender == GENDER_MALE ) ? 8.16f : 8.16f; }
			if ( sAnimationName == "curtsey" )	{ return ( iGender == GENDER_MALE ) ? 1.33f : 1.33f; }
			break;
		case CSL_LETTER_D:
			if ( sAnimationName == "damage01" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "damage02" )	{ return ( iGender == GENDER_MALE ) ? 1.06f : 2.0f; }
			if ( sAnimationName == "dance01" )	{ return ( iGender == GENDER_MALE ) ? 4.06f : 4.0f; }
			if ( sAnimationName == "dance02" )	{ return ( iGender == GENDER_MALE ) ? 9.63f : 2.0f; }
			if ( sAnimationName == "death01" )	{ return ( iGender == GENDER_MALE ) ? 2.29f : 2.73f; }
			if ( sAnimationName == "death02" )	{ return ( iGender == GENDER_MALE ) ? 1.46f : 3.86f; }
			if ( sAnimationName == "def_cast" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "def_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "def_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "dejected" )	{ return ( iGender == GENDER_MALE ) ? 4.8f : 4.8f; }
			if ( sAnimationName == "disablefront" )	{ return ( iGender == GENDER_MALE ) ? 2.33f : 2.0f; }
			if ( sAnimationName == "disableground" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "drink" )	{ return ( iGender == GENDER_MALE ) ? 3.0f : 3.0f; }
			if ( sAnimationName == "drinkbeer" )	{ return ( iGender == GENDER_MALE ) ? 3.06f : 3.06f; }
			if ( sAnimationName == "drinkbeerfidget" )	{ return ( iGender == GENDER_MALE ) ? 6.0f : 6.0f; }
			if ( sAnimationName == "drinkbeeridle" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "drumrun" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 0.8f; }
			if ( sAnimationName == "drunk" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "dustoff" )	{ return ( iGender == GENDER_MALE ) ? 5.03 : 3.66f; }
			break;
		case CSL_LETTER_E:
			if ( sAnimationName == "eat" )	{ return ( iGender == GENDER_MALE ) ? 3.50f : 3.0f; }
			if ( sAnimationName == "emo_amused" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_angry" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_annoyed" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_depressed" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_frown" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_nervous" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_scared" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_smile" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_smilebig" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_surprised" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			if ( sAnimationName == "emo_thoughtful" )	{ return ( iGender == GENDER_MALE ) ? 0.03f : 0.03f; }
			break;
		case CSL_LETTER_F:
			if ( sAnimationName == "flirt" )	{ return ( iGender == GENDER_MALE ) ? 4.26f : 7.0f; }
			if ( sAnimationName == "fluterun" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 0.8f; }
			if ( sAnimationName == "forge01" )	{ return ( iGender == GENDER_MALE ) ? 3.4f : 3.36f; }
			if ( sAnimationName == "forge02" )	{ return ( iGender == GENDER_MALE ) ? 3.36f : 3.36f; }
			break;
		case CSL_LETTER_G:
			if ( sAnimationName == "gen_cast" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "gen_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "gen_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "getground" )	{ return ( iGender == GENDER_MALE ) ? 1.83f : 1.66f; }
			if ( sAnimationName == "gethigh" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "gettable" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "guitarrun" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 0.8f; }
			break;
		case CSL_LETTER_H:
			break;
		case CSL_LETTER_I:
			if ( sAnimationName == "idle" )	{ return ( iGender == GENDER_MALE ) ? 11.66f : 5.0f; }
			if ( sAnimationName == "idlecower" )	{ return ( iGender == GENDER_MALE ) ? 4.0f : 3.0f; }
			if ( sAnimationName == "idledrum" )	{ return ( iGender == GENDER_MALE ) ? 3.0f : 3.0f; }
			if ( sAnimationName == "idlefidgetdrum" )	{ return ( iGender == GENDER_MALE ) ? 3.0f : 3.0f; }
			if ( sAnimationName == "idlefidgetflute" )	{ return ( iGender == GENDER_MALE ) ? 5.33f : 5.33f; }
			if ( sAnimationName == "idlefidgetguitar" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "idlefidgetnervous" )	{ return ( iGender == GENDER_MALE ) ? 9.5f : 9.5f; }
			if ( sAnimationName == "idleflute" )	{ return ( iGender == GENDER_MALE ) ? 3.0f : 3.0f; }
			if ( sAnimationName == "idleguitar" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "idleinj" )	{ return ( iGender == GENDER_MALE ) ? 2.66f : 5.0f; }
			if ( sAnimationName == "intimidate" )	{ return ( iGender == GENDER_MALE ) ? 3.06f : 5.0f; }
			break;
		case CSL_LETTER_J:
			if ( sAnimationName == "jumpback" )	{ return ( iGender == GENDER_MALE ) ? 1.6f : 1.66f; }
			break;
		case CSL_LETTER_K:
			if ( sAnimationName == "kneelbow" )	{ return ( iGender == GENDER_MALE ) ? 2.59f : 2.0f; }
			if ( sAnimationName == "kneelclutch" )	{ return ( iGender == GENDER_MALE ) ? 1.06f : 1.0f; }
			if ( sAnimationName == "kneelclutchloop" )	{ return ( iGender == GENDER_MALE ) ? 5.23f : 1.66f; }
			if ( sAnimationName == "kneeldamage" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "kneeldeath" )	{ return ( iGender == GENDER_MALE ) ? 1.43f : 1.5f; }
			if ( sAnimationName == "kneeldown" )	{ return ( iGender == GENDER_MALE ) ? 1.36f : 1.0f; }
			if ( sAnimationName == "kneelfidget" )	{ return ( iGender == GENDER_MALE ) ? 5.19f : 4.0f; }
			if ( sAnimationName == "kneelidle" )	{ return ( iGender == GENDER_MALE ) ? 2.59f : 2.0f; }
			if ( sAnimationName == "kneeltalk" )	{ return ( iGender == GENDER_MALE ) ? 5.19f : 4.0f; }
			if ( sAnimationName == "kneelup" )	{ return ( iGender == GENDER_MALE ) ? 1.36f : 1.0f; }
			if ( sAnimationName == "knighting" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 12.6f; }
			if ( sAnimationName == "knockdownb" )	{ return ( iGender == GENDER_MALE ) ? 1.13f : 1.66f; }
			break;
		case CSL_LETTER_L:
			if ( sAnimationName == "laugh" )	{ return ( iGender == GENDER_MALE ) ? 2.5f : 2.5f; }
			if ( sAnimationName == "laydownb" )	{ return ( iGender == GENDER_MALE ) ? 2.33f : 2.33f; } //3.33 : 2.33f;
			if ( sAnimationName == "liftsworddown" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "liftswordloop" )	{ return ( iGender == GENDER_MALE ) ? 4.0f : 4.0f; }
			if ( sAnimationName == "liftswordup" )	{ return ( iGender == GENDER_MALE ) ? 1.16f : 1.16f; }
			if ( sAnimationName == "listen" )	{ return ( iGender == GENDER_MALE ) ? 16.03f : 15.0f; }
			if ( sAnimationName == "listeninjured" )	{ return ( iGender == GENDER_MALE ) ? 5.33f : 5.0f; }
			if ( sAnimationName == "lookleft" )	{ return ( iGender == GENDER_MALE ) ? 5.63f : 5.0f; }
			if ( sAnimationName == "lookleftback" )	{ return ( iGender == GENDER_MALE ) ? 0.60f : 1.0f; }
			if ( sAnimationName == "lookleftloop" )	{ return ( iGender == GENDER_MALE ) ? 4.43f : 3.0f; }
			if ( sAnimationName == "lookleftstart" )	{ return ( iGender == GENDER_MALE ) ? 0.60f : 1.0f; }
			if ( sAnimationName == "lookright" )	{ return ( iGender == GENDER_MALE ) ? 5.63f : 5.0f; }
			if ( sAnimationName == "lookrightback" )	{ return ( iGender == GENDER_MALE ) ? 0.60f : 1.0f; }
			if ( sAnimationName == "lookrightloop" )	{ return ( iGender == GENDER_MALE ) ? 4.43f : 3.0f; }
			if ( sAnimationName == "lookrightstart" )	{ return ( iGender == GENDER_MALE ) ? 0.60f : 1.0f; }
			break;
		case CSL_LETTER_M:
			if ( sAnimationName == "meditate" )	{ return ( iGender == GENDER_MALE ) ? 2.66f : 5.0f; }
			if ( sAnimationName == "mjr_cast" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "mjr_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "mjr_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			break;
		case CSL_LETTER_N:
			if ( sAnimationName == "nodno" )	{ return ( iGender == GENDER_MALE ) ? 1.6f : 1.5f; }
			if ( sAnimationName == "nodyes" )	{ return ( iGender == GENDER_MALE ) ? 1.6f : 1.5f; }
			break;
		case CSL_LETTER_O:
			if ( sAnimationName == "openchest" )	{ return ( iGender == GENDER_MALE ) ? 3.0f : 2.66f; }
			if ( sAnimationName == "opendoor" )	{ return ( iGender == GENDER_MALE ) ? 1.90f : 2.0f; }
			if ( sAnimationName == "openlock" )	{ return ( iGender == GENDER_MALE ) ? 3.0f : 2.33f; }
			if ( sAnimationName == "openlockloop" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 1.0f; }
			break;
		case CSL_LETTER_P:
			if ( sAnimationName == "playdrum" )	{ return ( iGender == GENDER_MALE ) ? 4.0f : 3.73f; }
			if ( sAnimationName == "playflute" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "playguitar" )	{ return ( iGender == GENDER_MALE ) ? 1.86f : 2.0f; }
			if ( sAnimationName == "point" )	{ return ( iGender == GENDER_MALE ) ? 1.66f : 2.0f; }
			if ( sAnimationName == "proneb" )	{ return ( iGender == GENDER_MALE ) ? 2.66f : 2.0f; }
			if ( sAnimationName == "pronedamageb" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "pronedeathb" )	{ return ( iGender == GENDER_MALE ) ? 1.29f : 1.53f; }
			if ( sAnimationName == "pty_cast" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "pty_conjure" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			if ( sAnimationName == "pty_conjureloop" )	{ return ( iGender == GENDER_MALE ) ? 1.0f : 1.0f; }
			break;
		case CSL_LETTER_Q:
			break;
		case CSL_LETTER_R:
			if ( sAnimationName == "raking" )	{ return ( iGender == GENDER_MALE ) ? 3.59f : 3.59f; }
			if ( sAnimationName == "read" )	{ return ( iGender == GENDER_MALE ) ? 6.0f : 4.0f; }
			if ( sAnimationName == "runafraid" )	{ return ( iGender == GENDER_MALE ) ? 0.83f : 0.8f; }
			if ( sAnimationName == "runinj" )	{ return ( iGender == GENDER_MALE ) ? 0.83f : 0.8f; }
			break;
		case CSL_LETTER_S:
			if ( sAnimationName == "salute" )	{ return ( iGender == GENDER_MALE ) ? 2.33f : 2.0f; }
			if ( sAnimationName == "scratchhead" )	{ return ( iGender == GENDER_MALE ) ? 2.16f : 2.16f; }
			if ( sAnimationName == "scrollrecite" )	{ return ( iGender == GENDER_MALE ) ? 4.0f : 4.0f; }
			if ( sAnimationName == "search" )	{ return ( iGender == GENDER_MALE ) ? 11.73f : 6.66f; }
			if ( sAnimationName == "shoveling" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "shrug" )	{ return ( iGender == GENDER_MALE ) ? 1.5f : 1.5f; }
			if ( sAnimationName == "sigh" )	{ return ( iGender == GENDER_MALE ) ? 3.56f : 3.0f; }
			if ( sAnimationName == "sitdeath" )	{ return ( iGender == GENDER_MALE ) ? 2.46f : 2.06f; }
			if ( sAnimationName == "sitdrink" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "sitdrinkidle" )	{ return ( iGender == GENDER_MALE ) ? 2.66f : 2.66f; }
			if ( sAnimationName == "siteat" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "sitfidget" )	{ return ( iGender == GENDER_MALE ) ? 5.33f : 5.33f; }
			if ( sAnimationName == "sitgrounddown" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "sitgroundidle" )	{ return ( iGender == GENDER_MALE ) ? 4.66f : 4.66f; }
			if ( sAnimationName == "sitgroundup" )	{ return ( iGender == GENDER_MALE ) ? 1.33f : 1.33f; }
			if ( sAnimationName == "sitidle" )	{ return ( iGender == GENDER_MALE ) ? 2.66f : 2.66f; }
			if ( sAnimationName == "sitread" )	{ return ( iGender == GENDER_MALE ) ? 5.33f : 5.33f; }
			if ( sAnimationName == "sittalk01" )	{ return ( iGender == GENDER_MALE ) ? 5.33f : 5.33f; }
			if ( sAnimationName == "sittalk02" )	{ return ( iGender == GENDER_MALE ) ? 5.33f : 5.33f; }
			if ( sAnimationName == "sleightofhand" )	{ return ( iGender == GENDER_MALE ) ? 1.76f : 1.76f; }
			if ( sAnimationName == "sneak" )	{ return ( iGender == GENDER_MALE ) ? 1.66f : 1.33f; }
			if ( sAnimationName == "sp_lightning" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "sp_spray" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "sp_thrown" )	{ return ( iGender == GENDER_MALE ) ? 1.9f : 1.83f; }
			if ( sAnimationName == "sp_touch" )	{ return ( iGender == GENDER_MALE ) ? 1.66f : 1.66f; }
			if ( sAnimationName == "sp_turnundead" )	{ return ( iGender == GENDER_MALE ) ? 1.66f : 1.66f; }
			if ( sAnimationName == "sp_warcry" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "standupb" )	{ return ( iGender == GENDER_MALE ) ? 3.0f : 2.66f; }
			break;
		case CSL_LETTER_T:
			if ( sAnimationName == "talkcheer" )	{ return ( iGender == GENDER_MALE ) ? 6.66f : 6.66f; }
			if ( sAnimationName == "talkforce" )	{ return ( iGender == GENDER_MALE ) ? 6.66f : 6.66f; }
			if ( sAnimationName == "talkforce01" )	{ return ( iGender == GENDER_MALE ) ? 2.16f : 2.16f; }
			if ( sAnimationName == "talkforce02" )	{ return ( iGender == GENDER_MALE ) ? 2.0f : 2.0f; }
			if ( sAnimationName == "talkforce03" )	{ return ( iGender == GENDER_MALE ) ? 3.66f : 3.66f; }
			if ( sAnimationName == "talkinjured" )	{ return ( iGender == GENDER_MALE ) ? 5.33f : 5.0f; }
			if ( sAnimationName == "talklaugh" )	{ return ( iGender == GENDER_MALE ) ? 6.66f : 6.66f; }
			if ( sAnimationName == "talknervous" )	{ return ( iGender == GENDER_MALE ) ? 6.66f : 6.66f; }
			if ( sAnimationName == "talknormal" )	{ return ( iGender == GENDER_MALE ) ? 16.0f : 15.0f; }
			if ( sAnimationName == "talknormal02" )	{ return ( iGender == GENDER_MALE ) ? 16.03f : 15.0f; }
			if ( sAnimationName == "talkplead" )	{ return ( iGender == GENDER_MALE ) ? 6.66f : 6.66f; }
			if ( sAnimationName == "talksad" )	{ return ( iGender == GENDER_MALE ) ? 6.66f : 6.66f; }
			if ( sAnimationName == "talkshout" )	{ return ( iGender == GENDER_MALE ) ? 6.66f : 6.66f; }
			if ( sAnimationName == "taunt" )	{ return ( iGender == GENDER_MALE ) ? 6.26f : 5.0f; }
			if ( sAnimationName == "throwarmsdown" )	{ return ( iGender == GENDER_MALE ) ? 0.66f : 0.66f; }
			if ( sAnimationName == "throwarmsloop" )	{ return ( iGender == GENDER_MALE ) ? 3.16f : 3.16f; }
			if ( sAnimationName == "throwarmsup" )	{ return ( iGender == GENDER_MALE ) ? 0.83f : 0.83f; }
			if ( sAnimationName == "tired" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			if ( sAnimationName == "torchidle" )	{ return ( iGender == GENDER_MALE ) ? 11.69f : 8.0f; }
			if ( sAnimationName == "torchlightfront" )	{ return ( iGender == GENDER_MALE ) ? 2.16f : 4.0f; }
			if ( sAnimationName == "torchlightground" )	{ return ( iGender == GENDER_MALE ) ? 2.16f : 4.0f; }
			if ( sAnimationName == "torchrun" )	{ return ( iGender == GENDER_MALE ) ? 0.83f : 0.8f; }
			if ( sAnimationName == "torchturnl" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 0.8f; }
			if ( sAnimationName == "torchturnr" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 0.8f; }
			if ( sAnimationName == "torchwalk" )	{ return ( iGender == GENDER_MALE ) ? 1.26f : 1.33f; }
			if ( sAnimationName == "torchwalkback" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 1.33f; }
			if ( sAnimationName == "torchwalkleft" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 1.33f; }
			if ( sAnimationName == "torchwalkright" )	{ return ( iGender == GENDER_MALE ) ? 0.0f : 1.33f; }
			if ( sAnimationName == "toss" )	{ return ( iGender == GENDER_MALE ) ? 1.50f : 0.0f; }
			if ( sAnimationName == "touchheart" )	{ return ( iGender == GENDER_MALE ) ? 3.0f : 3.0f; }
			if ( sAnimationName == "turnl" )	{ return ( iGender == GENDER_MALE ) ? 0.8f : 0.8f; }
			if ( sAnimationName == "turnr" )	{ return ( iGender == GENDER_MALE ) ? 0.8f : 0.8f; }
			break;
		case CSL_LETTER_U:
			if ( sAnimationName == "useitem" )	{ return ( iGender == GENDER_MALE ) ? 4.0f : 3.0f; }
			break;
		case CSL_LETTER_V:
			if ( sAnimationName == "victory" )	{ return ( iGender == GENDER_MALE ) ? 5.0f : 5.0f; }
			break;
		case CSL_LETTER_W:
			if ( sAnimationName == "walk" )	{ return ( iGender == GENDER_MALE ) ? 1.26f : 1.33f; }
			if ( sAnimationName == "walkback" )	{ return ( iGender == GENDER_MALE ) ? 1.26f : 1.33f; }
			if ( sAnimationName == "walkdrum" )	{ return ( iGender == GENDER_MALE ) ? 1.26f : 1.33f; }
			if ( sAnimationName == "walkflute" )	{ return ( iGender == GENDER_MALE ) ? 1.26f : 1.33f; }
			if ( sAnimationName == "walkguitar" )	{ return ( iGender == GENDER_MALE ) ? 1.26f : 1.33f; }
			if ( sAnimationName == "walkinj" )	{ return ( iGender == GENDER_MALE ) ? 1.26f : 1.33f; }
			if ( sAnimationName == "walkleft" )	{ return ( iGender == GENDER_MALE ) ? 1.06f : 1.06f; }
			if ( sAnimationName == "walkright" )	{ return ( iGender == GENDER_MALE ) ? 1.06f : 1.06f; }
			if ( sAnimationName == "wave" )	{ return ( iGender == GENDER_MALE ) ? 2.20f : 2.0f; }
			if ( sAnimationName == "waveshort" )	{ return ( iGender == GENDER_MALE ) ? 1.56f : 1.5f; }
			if ( sAnimationName == "wildshape" )	{ return ( iGender == GENDER_MALE ) ? 1.16f : 1.16f; }
			if ( sAnimationName == "worship" )	{ return ( iGender == GENDER_MALE ) ? 2.66f : 2.0f; }
			if ( sAnimationName == "wounded" )	{ return ( iGender == GENDER_MALE ) ? 8.33f : 8.33f; }
			break;
		case CSL_LETTER_X:
			break;
		case CSL_LETTER_Y:
			if ( sAnimationName == "yawn" )	{ return ( iGender == GENDER_MALE ) ? 3.13f : 3.0f; }
			break;
		case CSL_LETTER_Z:
			break;
		default:
			return 0.0f;
			break;
	}
			
	return 0.0f;
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLPlayCustomAnimation_Void(object oPC, string sAnimationName, int nLooping = FALSE, float fSpeed = 1.0f)
{
   PlayCustomAnimation(oPC, sAnimationName, nLooping, fSpeed);
}

// FAK - OEI 5/16/05
// Returns TRUE if it found an object to play a custom animation one
// oObject is the object to play the animation on
// sAnimationName is the name of the gr2 to play, and multiple ones can be comma delimited to run in sequence
// nLooping is 0 for one-off, 1 for loop
// fSpeed is the playback speed: 1.0 is default, < 0 is backwards
// remove sSecondAnimationName = "", string sThirdAnimationName  since delimters work on the first now to allow chaining emotes
void CSLPlayCustomAnimations( object oObject, string sAnimationName, int nLooping = FALSE, float fSpeed = 1.0f, float fMaxDuration = 0.0f, int nVoiceChat=0, string sSound="", string sDelimiter="," )
{
	//float fDuration = CSLGetAnimationDuration( sAnimationName, GetGender( oObject ) );
	//float fDuration2 = 0.0f;
	//float fDuration3 = 0.0f;
	
	float fTotalDuration = 0.0f;
	/// trying something out here to just have a single animation delimted
	int iAnimationCount = CSLNth_GetCount( sAnimationName, sDelimiter);
	int iCurrentAnimation = 1;
	string sCurrentAnimation; // = CSLNth_GetNthElement( sAnimationName, iCurrentAnimation, sDelimiter )
	float fDuration;
	while ( iCurrentAnimation < iAnimationCount )
	{
		sCurrentAnimation = CSLNth_GetNthElement( sAnimationName, iCurrentAnimation, sDelimiter );
		fDuration = CSLGetAnimationDuration( sCurrentAnimation, GetGender(oObject) );
		//if ( fTotalDuration > 0.0f )
		//{
			//SendMessageToPC( GetFirstPC(), "Playing Animation "+sCurrentAnimation+" with delay of "+CSLFormatFloat(fTotalDuration)+" for duration of "+CSLFormatFloat(fDuration)  );
			DelayCommand( fTotalDuration, AssignCommand(oObject, CSLPlayCustomAnimation_Void(oObject, sCurrentAnimation, FALSE, fSpeed)) );
		//}
		//else
		//{
		//	SendMessageToPC( GetFirstPC(), "Playing Animation "+sAnimationName+" with no delay for duration of "+CSLFormatFloat(fDuration)  );
		//	AssignCommand(oObject, CSLPlayCustomAnimation_Void(oObject, sCurrentAnimation, FALSE, fSpeed));
		//}
		fTotalDuration += fDuration;
		iCurrentAnimation++;
	}
	
	sCurrentAnimation = CSLNth_GetNthElement( sAnimationName, iCurrentAnimation, sDelimiter );
	fDuration = CSLGetAnimationDuration( sCurrentAnimation, GetGender( oObject ) );
	//if ( fTotalDuration > 0.0f )
	//{
		//SendMessageToPC( GetFirstPC(), "Playing Animation "+sCurrentAnimation+" with delay of "+CSLFormatFloat(fTotalDuration)+" for duration of "+CSLFormatFloat(fDuration)  );
		DelayCommand( fTotalDuration, AssignCommand(oObject, CSLPlayCustomAnimation_Void(oObject, sCurrentAnimation, nLooping, fSpeed)) );
	//}
	//else
	//{
	//	SendMessageToPC( GetFirstPC(), "Playing Animation "+sAnimationName+" with no delay for duration of "+CSLFormatFloat(fDuration)  );
	//	AssignCommand(oObject, CSLPlayCustomAnimation_Void(oObject, sCurrentAnimation, nLooping, fSpeed));
	//}
	fTotalDuration += fDuration;
	
	// what will ActionWait do
	if ( nLooping && fMaxDuration > 0.0f )
	{
		DelayCommand( CSLGetMaxf(fMaxDuration,fTotalDuration), AssignCommand(oObject, CSLPlayCustomAnimation_Void(oObject, "%" )) );
		
		AssignCommand(oObject, ActionWait( CSLGetMaxf(fMaxDuration,fTotalDuration) ) );
		
	}
	else
	{
		AssignCommand(oObject, ActionWait(fTotalDuration) );
	}
	
	if (nVoiceChat)
	{
		PlayVoiceChat(nVoiceChat, oObject);
	}
   	
   	if ( sSound != "" )
   	{
   		AssignCommand(oObject, PlaySound(sSound));
   	}
   
   
	/// end trial
	/*
	int nLoopingFirst = nLooping;
	int nLoopingSecond = FALSE;
	int nLoopingThird= FALSE;
	if ( sSecondAnimationName != "" )
	{
		fDuration2 = CSLGetAnimationDuration( sSecondAnimationName, GetGender( oObject ) );
		int nLoopingFirst = FALSE;
		int nLoopingSecond = nLooping;
		if ( sThirdAnimationName != "" )
		{
			fDuration3 = CSLGetAnimationDuration( sThirdAnimationName, GetGender( oObject ) );
			nLoopingSecond = FALSE;
			nLoopingThird = nLooping;
			if ( fDuration3 > 0.0f )
			{
				DelayCommand( fDuration+fDuration2, AssignCommand(oObject, CSLPlayCustomAnimation_Void(oObject, sThirdAnimationName, nLooping, fSpeed)) );
				fTotalDuration += fDuration3;
			}
		}
		if ( fDuration2 > 0.0f )
		{
			DelayCommand( fDuration, AssignCommand(oObject, CSLPlayCustomAnimation_Void(oObject, sSecondAnimationName, nLoopingSecond, fSpeed)) );
			fTotalDuration += fDuration2;
		}
	}
	
	if ( fDuration > 0.0f )
	{
		AssignCommand(oObject, CSLPlayCustomAnimation_Void(oObject, sAnimationName, nLoopingFirst, fSpeed));
		fTotalDuration += fDuration;
	}
	*/
	
	
	
	
	// PlayCustomAnimation( oObject, sAnimationName, nLooping, fSpeed );
	//return fTotalDuration;
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLVoiceSound(object oPC, int nVoiceChat=0, string sSound="")
{
   if (nVoiceChat) PlayVoiceChat(nVoiceChat, oPC);
   if (sSound!="") AssignCommand(oPC, PlaySound(sSound));
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDoFireForgetAnimation(object oPC, int nAnimation, int nVoiceChat=0, string sSound="")
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   CSLVoiceSound(oPC, nVoiceChat, sSound);
   AssignCommand(oPC, ActionPlayAnimation(nAnimation));
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLDoLoopAnimation(object oPC, int nAnimation, int nVoiceChat=0, string sSound="")
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   CSLVoiceSound(oPC, nVoiceChat, sSound);
   AssignCommand(oPC, ActionPlayAnimation(nAnimation, 1.0, 99.0));
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLNWN2Emote(object oPC, string sEmote, string sEmote2 = "", float fDelay = 0.0) {
   int nLoop = (sEmote2!="") ? 1 : 0;
   //nLoop = FALSE;
//   if (sEmote=="%" || sEmote2 != "") nLoop = 0; // IF THERE IS 2ND ANIMATION TO PLAY, THE FIRST SHOULD LOOP UNTIL 2ND IS READY
   CSLPlayCustomAnimation_Void(oPC, sEmote, nLoop);
   if (sEmote2 != "") DelayCommand(fDelay, CSLPlayCustomAnimation_Void(oPC, sEmote2, 0));
}

/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLNWN2EmoteWithSound(object oPC, string sAni, int nVoiceChat=0, string sSound="") {
   CSLVoiceSound(oPC, nVoiceChat, sSound);
   CSLNWN2Emote(oPC, sAni);
}


/**  
* Description
* @author
* @param 
* @see 
* @return 
*/
void CSLHSSVFX(object oPC, string sVFX, float fDuration = 0.0)
{
   effect eFirst = GetFirstEffect(oPC);
   while (GetIsEffectValid(eFirst)) {
      if (GetEffectSpellId(eFirst)==-899) {
         RemoveEffect(oPC, eFirst);
         break;
      }
      eFirst = GetNextEffect(oPC);
   }
   if (sVFX=="%") return;
   string sEffect = "fx_hss_" + sVFX;
   effect eProp = SupernaturalEffect(SetEffectSpellId(EffectNWN2SpecialEffectFile(sEffect), -899));
   if (fDuration==0.0) {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eProp, oPC);
   } else {
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eProp, oPC, fDuration);
   }
}



/**  
* @author
* @param 
* @see 
* @return 
*/
int CSLDontEmoteSpam(object oPC, float fDelay = 6.0)
{
   if (GetLocalInt(oPC, "DES")) 
   {
      // FloatingTextStringOnCreature("<color=red>*Emoting*</color>", oPC);
      return TRUE;
   }
   CSLTimedFlag(oPC, "DES", fDelay);
   return FALSE;
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoBored(object oPC, string sWhich = "")
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   PlayVoiceChat(VOICE_CHAT_BORED, oPC);
   if (sWhich=="1") CSLDoFireForgetAnimation(oPC, ANIMATION_FIREFORGET_PAUSE_BORED);
   else             CSLNWN2Emote(oPC, "bored");
}


/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoDrinkBeer(object oPC)
{
   if (CSLDontEmoteSpam(oPC, 22.0)) return;
   CSLHSSVFX(oPC, "drinkbeer", 22.0);
   
   CSLPlayCustomAnimations( oPC, "drinkbeer,drinkbeerfidget", TRUE, 1.0f, 7.0f );
   DelayCommand(6.0, AssignCommand(oPC, PlaySound(CSLPickOne("as_pl_x2rghtav1", "as_pl_x2rghtav2", "as_pl_x2rghtav3"))));

	DelayCommand(7.0, CSLPlayCustomAnimations( oPC, "drinkbeer,drinkbeeridle", TRUE, 1.0f, 7.0f ) );

	DelayCommand(14.0, CSLPlayCustomAnimations( oPC, "drinkbeer,drunk", TRUE, 1.0f, 8.0f ) );
	DelayCommand(18.0, CSLPlayCustomAnimations( oPC, "drinkbeer" ) );
   
   
   
   //CSLNWN2Emote(oPC, "drinkbeer", "drinkbeerfidget", 4.0);
   //DelayCommand(6.0, AssignCommand(oPC, PlaySound(CSLPickOne("as_pl_x2rghtav1", "as_pl_x2rghtav2", "as_pl_x2rghtav3"))));
   //DelayCommand(7.0, CSLNWN2Emote(oPC, "drinkbeer", "drinkbeeridle", 4.0));
   //DelayCommand(14.0, CSLNWN2Emote(oPC, "drinkbeer", "drunk", 4.0));
   DelayCommand(18.0, AssignCommand(oPC, PlaySound(CSLSexString(oPC, "as_pl_tavcallm2", "as_pl_tavcallf1"))));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoDrinkWine(object oPC)
{
	if (CSLDontEmoteSpam(oPC, 16.0)) return;
	CSLHSSVFX(oPC, "wine", 16.0);
	//CSLNWN2Emote(oPC, "drink", "drinkbeeridle", 4.0);
	CSLPlayCustomAnimations( oPC, "drink,drinkbeeridle", TRUE, 1.0f, 8.0f );
	//DelayCommand(4.0, CSLPlayCustomAnimations( oPC, "drink" );
	DelayCommand(4.0, CSLPlayCustomAnimations( oPC, "drink" ) );
	DelayCommand(8.0, CSLPlayCustomAnimations( oPC, "drinkbeer,drunk", TRUE, 1.0f, 8.0f ) );
	DelayCommand(12.0, CSLPlayCustomAnimations( oPC, "drinkbeer" ) );
	//DelayCommand(8.0, CSLNWN2Emote(oPC, "drinkbeer", "drunk", 4.0));
	DelayCommand(12.0, AssignCommand(oPC, PlaySound(CSLSexString(oPC, "as_pl_tavcallm1", "as_pl_tavlaughf1"))));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoCheer(object oPC, string sWhich = "")
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   PlayVoiceChat(VOICE_CHAT_CHEER, oPC);
   if      (sWhich=="1") AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0));
   else if (sWhich=="2") AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2, 1.0));
   else if (sWhich=="3") AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_VICTORY3, 1.0));
   else                  CSLNWN2Emote(oPC, "talkcheer");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoStopDropAndRoll(object oPC )
{
	CSLIncrementLocalInt( oPC, "CSL_STOPDROPANDROLL", 1 );
	DelayCommand( 6.0f, CSLDecrementLocalInt_Void(oPC, "CSL_STOPDROPANDROLL", 1, TRUE ) );
	
	// AssignCommand(oPC, ClearAllActions(TRUE));
	if ( d2() == 1 )
	{
		AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 1.0f));
		DelayCommand(1.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0f, 1.0f)));
		DelayCommand(2.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 1.0f)));
		DelayCommand(3.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0f, 1.0f)));
		DelayCommand(4.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 1.0f)));
		DelayCommand(5.0, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0f, 1.0f)));
	}
	else
	{
		AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 1.0f, 6.0f));	
	}
}
	
			
			
			
/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoConjure(object oPC, string sWhich = "")
{
	AssignCommand(oPC, ClearAllActions(TRUE));
	if (sWhich=="1")
	{
		//CSLNWN2Emote(oPC, "BSS_conjure", "BSS_conjureloop", 1.0);
		CSLPlayCustomAnimations( oPC, "BSS_conjure,BSS_conjureloop", TRUE, 1.0f, 1.0f );
	}
	else if (sWhich=="2")
	{
		//CSLNWN2Emote(oPC, "gen_conjure", "gen_conjureloop", 1.0);
		CSLPlayCustomAnimations( oPC, "gen_conjure,gen_conjureloop", TRUE, 1.0f, 1.0f );
		
	}
	else if (sWhich=="3")
	{
		CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_CONJURE1);
	}
	else
	{
		CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_CONJURE2);
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoCook(object oPC, string sWhich = "")
{
	if (CSLDontEmoteSpam(oPC, 11.0)) 
	{
		return;
	}
	CSLHSSVFX(oPC, "pan", 11.0);
	if   (sWhich=="1")
	{
		//CSLNWN2Emote(oPC, "cooking01", "%", 10.0);
		CSLPlayCustomAnimations( oPC, "cooking01", TRUE, 1.0f, 10.0f );
	}
	else
	{
		//CSLNWN2Emote(oPC, "cooking02", "%", 10.0);
		CSLPlayCustomAnimations( oPC, "cooking02", TRUE, 1.0f, 10.0f );
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoDance(object oPC, string sWhich = "")
{
   if   (sWhich=="1") CSLNWN2Emote(oPC, "dance01");
   else               CSLNWN2Emote(oPC, "dance02");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoDisable(object oPC, string sWhich = "")
{
   if   (CSLStringStartsWith(sWhich, "f") || sWhich=="1") CSLNWN2Emote(oPC, "disablefront");
   else                                                CSLNWN2Emote(oPC, "disadisableground");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoDeath(object oPC, string sWhich = "")
{
   if (CSLDontEmoteSpam(oPC)) return;
   AssignCommand(oPC, ClearAllActions(TRUE));
   if   (CSLStringStartsWith(sWhich, "f") || sWhich=="1") CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_DEAD_FRONT);
   else                                                CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_DEAD_BACK);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1_L.sef"), oPC);
   DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_red1.sef"), oPC));
   PlayVoiceChat(VOICE_CHAT_DEATH, oPC);
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoGet(object oPC, string sWhich = "")
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   if      (CSLStringStartsWith(sWhich, "g") || sWhich=="1") CSLNWN2Emote(oPC, "getground");
   else if (CSLStringStartsWith(sWhich, "l") || sWhich=="2") CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_GET_LOW);
   else if (CSLStringStartsWith(sWhich, "m") || sWhich=="3") CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_GET_MID);
   else if (CSLStringStartsWith(sWhich, "h") || sWhich=="4") CSLNWN2Emote(oPC, "gethigh");
   else                                                   CSLNWN2Emote(oPC, "gettable");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoForge(object oPC, string sWhich = "")
{
   if   (sWhich=="1") CSLNWN2Emote(oPC, "forge01");
   else               CSLNWN2Emote(oPC, "forge02");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoHello(object oPC, string sWhich = "", int bVC = FALSE)
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   if (bVC) PlayVoiceChat(VOICE_CHAT_HELLO, oPC);
   if      (sWhich=="1")                                  CSLDoFireForgetAnimation(oPC, ANIMATION_FIREFORGET_GREETING);
   else if (CSLStringStartsWith(sWhich, "s") || sWhich=="2") CSLNWN2Emote(oPC, "waveshort");
   else                                                   CSLNWN2Emote(oPC, "wave");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoIdle(object oPC, string sWhich = "")
{
   if      (CSLStringStartsWith(sWhich, "c") || sWhich=="1") CSLNWN2Emote(oPC, "idlecower");
   else if (CSLStringStartsWith(sWhich, "p") || sWhich=="2") CSLNWN2Emote(oPC, "idlepray");
   else                                                   CSLNWN2Emote(oPC, "idleinj");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoKneel(object oPC, string sWhich = "")
{
	if (CSLStringStartsWith(sWhich, "b") || sWhich=="1") 
	{
		//CSLNWN2Emote(oPC, "kneelbow");
		CSLPlayCustomAnimations( oPC, "kneelbow", TRUE, 1.0f );
	}
	else if (CSLStringStartsWith(sWhich, "d") || sWhich=="2")
 	{
		//CSLNWN2Emote(oPC, "kneeldown", "kneelidle", 1.0);
		CSLPlayCustomAnimations( oPC, "kneeldown,kneelidle", TRUE, 1.0f );
	}
	else if (CSLStringStartsWith(sWhich, "f") || sWhich=="3")
	{
  		//CSLNWN2Emote(oPC, "kneelfidget");
		CSLPlayCustomAnimations( oPC, "kneelfidget", TRUE, 1.0f );
  	}
  	else if (CSLStringStartsWith(sWhich, "i") || sWhich=="4")
  	{
   		//CSLNWN2Emote(oPC, "kneelidle");
		CSLPlayCustomAnimations( oPC, "kneelidle", TRUE, 1.0f );
	}
	else if (CSLStringStartsWith(sWhich, "t") || sWhich=="5")
	{
		//CSLNWN2Emote(oPC, "kneeltalk");
		CSLPlayCustomAnimations( oPC, "kneeltalk", TRUE, 1.0f );
	}
	else
	{
		//CSLNWN2Emote(oPC, "kneelup", "%", 0.1);
		CSLPlayCustomAnimations( oPC, "kneelup", TRUE, 1.0f, 1.0f );
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoLaugh(object oPC, string sWhich = "")
{
   PlayVoiceChat(VOICE_CHAT_LAUGH, oPC);
   if      (sWhich=="1") CSLNWN2Emote(oPC, "laugh");
   else                  CSLNWN2Emote(oPC, "talklaugh");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoMeditate(object oPC, string sWhich = "")
{
   if   (sWhich=="1") CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_MEDITATE);
   else               CSLNWN2Emote(oPC, "meditate");
   AssignCommand(oPC, PlaySound(CSLSexString(oPC, "as_pl_evilchantm", "whinny")));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoNo(object oPC)
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   PlayVoiceChat(VOICE_CHAT_NO, oPC);
   AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 0.25f));
   DelayCommand(0.15f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 0.25f)));
   DelayCommand(0.40f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 0.25f)));
   DelayCommand(0.65f, AssignCommand(oPC, PlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0, 0.25f)));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoPipeGlow(object oPC, float fDelay)
{
   AssignCommand(oPC, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_LIGHT_RED_5), oPC, 0.15)));
   AssignCommand(oPC, ActionWait(fDelay));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoPipe(object oPC, string sWhich = "")
{
   if (CSLDontEmoteSpam(oPC)) return;
   float fHeight = 1.7;
   float fDistance = 0.1;
   if (sWhich=="") sWhich = IntToString(d3());
   if      (sWhich=="2") sWhich = "*inhales from a bowl*";
   else if (sWhich=="3") sWhich = "*uses a hookah*";
   else                  sWhich = "*puffs on a pipe*";
   FloatingTextStringOnCreature(sWhich, oPC);
   if (GetGender(oPC)==GENDER_MALE)
   {
      switch (GetRacialType(oPC))
      {
         case RACIAL_TYPE_HUMAN:
         case RACIAL_TYPE_HALFELF: fHeight = 1.7; fDistance = 0.12; break;
         case RACIAL_TYPE_ELF: fHeight = 1.55; fDistance = 0.08; break;
         case RACIAL_TYPE_GNOME:
         case RACIAL_TYPE_HALFLING: fHeight = 1.15; fDistance = 0.12; break;
         case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.12; break;
         case RACIAL_TYPE_HALFORC: fHeight = 1.9; fDistance = 0.2; break;
      }
   }
   else
   { // FEMALES
      switch (GetRacialType(oPC))
      {
         case RACIAL_TYPE_HUMAN:
         case RACIAL_TYPE_HALFELF: fHeight = 1.6; fDistance = 0.12; break;
         case RACIAL_TYPE_ELF: fHeight = 1.45; fDistance = 0.12; break;
         case RACIAL_TYPE_GNOME:
         case RACIAL_TYPE_HALFLING: fHeight = 1.1; fDistance = 0.075; break;
         case RACIAL_TYPE_DWARF: fHeight = 1.2; fDistance = 0.1; break;
         case RACIAL_TYPE_HALFORC: fHeight = 1.8; fDistance = 0.13; break;
      }
   }
   location lAboveHead = CSLGetLocationAboveAndInFrontOf(oPC, fDistance, fHeight);
   CSLEmoteDoPipeGlow(oPC, 0.8);
   CSLEmoteDoPipeGlow(oPC, 1.0);
   if (Random(4)) // 25% CHANCE TO COUGH
   {
      sWhich = IntToString(Random(7)+1);
      AssignCommand(oPC, PlaySound(CSLSexString(oPC, "as_pl_coughf" + sWhich, "as_pl_coughm" + sWhich)));
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0, 5.0));
   }
   CSLEmoteDoPipeGlow(oPC, 0.8);
//   AssignCommand(oPC, ActionDoCommand(ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SMOKE_PUFF), lAboveHead)));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoPlay(object oPC, string sWhich = "")
{
   if (CSLDontEmoteSpam(oPC, 10.0)) return;
   sWhich = CSLNth_Shift(sWhich, " ");
   string sInst = CSLNth_GetLast();
   sWhich = CSLNth_Shift(sWhich, " ");
   string sModel = CSLNth_GetLast();
   sWhich = CSLNth_Shift(sWhich, " ");
   string sSong = CSLNth_GetLast();
   string sAction;
   float fDur;
   if ( CSLStringStartsWith(sInst, "d")) {
      sAction = "playdrum";
      if (sModel=="1") sInst = "druma";
      else             sInst = "drumb";
      if      (sSong=="1") { fDur = 13.0; sSong = "al_pl_x2wardrum1"; }
      else if (sSong=="2") { fDur =  8.0; sSong = "al_pl_x2wardrum2"; }
      else if (sSong=="3") { fDur =  2.0; sSong = "gui_drumsong01"; }
      else if (sSong=="4") { fDur =  2.0; sSong = "gui_drumsong02"; }
      else if (sSong=="5") { fDur =  2.0; sSong = "gui_drumsong03"; }
      else if (sSong=="6") { fDur =  2.0; sSong = "gui_drumsong04"; }
      else if (sSong=="7") { fDur =  8.0; sSong = "al_pl_x2bongolp1"; }
      else if (sSong=="8") { fDur =  8.0; sSong = "al_pl_x2bongolp2"; }
      else                 { fDur = 24.0; sSong = "al_pl_x2tablalp"; }

   } else if (CSLStringStartsWith(sInst, "f")) {
      sAction = "playflute";
      fDur =  5.0;
      if (sModel=="1") sInst = "flutea";
      else             sInst = "fluteb";
      if      (sSong=="1") sSong = "as_cv_flute1";
      else if (sSong=="2") sSong = "as_cv_flute2";
      else if (sSong=="3") sSong = "gui_flutesong01";
      else if (sSong=="4") sSong = "gui_flutesong02";
      else if (sSong=="5") sSong = "gui_flutesong03";
      else                 sSong = "gui_flutesong04";

   } else { //if (CSLStringStartsWith(sInst, "g")) {
      sAction = "playguitar";
      if      (sModel=="1") sInst = "mandolina";
      else if (sModel=="2") sInst = "mandolinb";
      else                  sInst = "mandolinc";
      if      (sSong=="1") { fDur = 5.0; sSong = "as_cv_lute1"; }
      else if (sSong=="2") { fDur = 5.0; sSong = "as_cv_lute1b"; }
      else if (sSong=="3") { fDur = 6.0; sSong = "as_n2_luteriff01"; }
      else if (sSong=="4") { fDur = 6.0; sSong = "as_n2_luteriff02"; }
      else if (sSong=="5") { fDur = 6.0; sSong = "as_n2_luteriff03"; }
      else if (sSong=="6") { fDur = 7.0; sSong = "as_n2_luteriff04"; }
      else if (sSong=="7") { fDur = 6.0; sSong = "as_n2_luteriff05"; }
      else if (sSong=="8") { fDur = 5.0; sSong = "as_n2_luteriff06"; }
      else if (sSong=="9") { fDur = 7.0; sSong = "as_n2_luteriff07"; }
      else if (sSong=="10") {fDur = 7.0; sSong = "as_n2_luteriff08"; }
      else if (sSong=="11") {fDur = 4.0; sSong = "bardsong_lute_01"; }
      else if (sSong=="12") {fDur = 3.0; sSong = "bardsong_lute_02"; }
      else                  {fDur = 4.0; sSong = "bardsong_lute_03"; }
   }
   CSLHSSVFX(oPC, sInst, fDur);
   CSLNWN2Emote(oPC, sAction, "%", fDur);
   AssignCommand(oPC, PlaySound(sSong));

   //SendMessageToPC(oPC, "sInst = " + sInst + " sAction = " + sAction + " sSong = " + sSong + " dur = " + FloatToString(fDur));

}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoPlead(object oPC, string sWhich = "")
{
   if      (sWhich=="1") CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_TALK_PLEADING);
   else                  CSLNWN2Emote(oPC, "talkplead");
}


/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoSigning(object oPC )
{
   CSLNWN2Emote(oPC, "talkplead");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoPuke(object oPC)
{
   if (CSLDontEmoteSpam(oPC, 3.0)) return;
   AssignCommand(oPC, ClearAllActions(TRUE));
   //DelayCommand(0.2, AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE )));
   DelayCommand(0.2, AssignCommand(oPC,  CSLPlayCustomAnimations(oPC, "meditate", FALSE, 1.0f, 0.35f ) ));
   DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_green1_L.sef"), oPC));
   DelayCommand(0.4, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectNWN2SpecialEffectFile("fx_blood_green1.sef"), oPC));
   DelayCommand(0.3, AssignCommand(oPC, SpeakString(CSLPickOne("Blaaarg!", "Raaaalphfff", "Bhhuaaarrggg"), TALKVOLUME_TALK)));
   DelayCommand(0.0, AssignCommand(oPC, PlaySound(CSLSexString(oPC, CSLPickOne("as_pl_spittingm2", "as_pl_coughm6"), CSLPickOne("as_pl_coughf5", "as_pl_coughf6")))));
   DelayCommand(0.5, AssignCommand(oPC,  CSLPlayCustomAnimation_Void(oPC, "%") ));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoRake(object oPC)
{
   if (CSLDontEmoteSpam(oPC, 11.0)) return;
   CSLHSSVFX(oPC, "rake", 11.0);
   //CSLNWN2Emote(oPC, "raking", "%", 10.0);
   
   CSLPlayCustomAnimations( oPC, "raking", TRUE, 1.0f, 10.0f );
   
}


/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoRead(object oPC, string sWhich = "")
{
   if      (sWhich=="1") CSLDoFireForgetAnimation(oPC, ANIMATION_FIREFORGET_READ);
   else if (sWhich=="2") CSLNWN2Emote(oPC, "read");
   else                  CSLNWN2Emote(oPC, "scrollrecite");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoSalute(object oPC, string sWhich = "")
{
   if   (sWhich=="1") CSLDoFireForgetAnimation(oPC, ANIMATION_FIREFORGET_SALUTE);
   else               CSLNWN2Emote(oPC, "salute");
   AssignCommand(oPC, PlaySound("as_pl_officerm1"));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoScratch(object oPC, string sWhich = "")
{
   if   (sWhich=="1") CSLDoFireForgetAnimation(oPC, ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
   else               CSLNWN2Emote(oPC, "scratchhead");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoShovel(object oPC)
{
   if (CSLDontEmoteSpam(oPC, 11.0)) return;
   CSLHSSVFX(oPC, "shovel", 11.0);
   // CSLNWN2Emote(oPC, "shoveling", "%", 10.0);
   CSLPlayCustomAnimations( oPC, "shoveling", TRUE, 1.0f, 10.0f );
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoSit(object oPC, string sWhich = "")
{
	if (sWhich=="1")
	{
		CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_SIT_CROSS);
	}
	else if (sWhich=="2")
	{
		//CSLNWN2Emote(oPC, "sitgroundup", "%", 1.0);
		CSLPlayCustomAnimations( oPC, "sitgroundup,%", TRUE );
	}
	else
	{
		//CSLNWN2Emote(oPC, "sitgrounddown", "sitgroundidle", 2.0);
		CSLPlayCustomAnimations( oPC, "sitgrounddown,sitgroundidle", TRUE );
	}
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoSleep(object oPC)
{
	AssignCommand(oPC, ClearAllActions(TRUE));
	//CSLNWN2Emote(oPC, "laydownB", "proneB", 2.3);
	
	CSLPlayCustomAnimations( oPC, "laydownB,proneB", TRUE );
	
	AssignCommand(oPC, PlaySound(CSLSexString(oPC, "as_pl_yawningm1", "as_pl_yawningf1")));
	DelayCommand(4.0, AssignCommand(oPC, PlaySound(CSLSexString(oPC, CSLPickOne("as_pl_snoringm1", "as_pl_snoringm2"), "as_pl_snoringf1"))));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoSong(object oPC, string sWhich = "")
{
   if (CSLDontEmoteSpam(oPC)) return;
   CSLNWN2Emote(oPC, "bardsong");
   if      (sWhich=="1") sWhich = CSLSexString(oPC, "as_pl_tavsongm1", "as_n2_singpuri01");
   else if (sWhich=="2") sWhich = CSLSexString(oPC, "as_pl_tavsongm2", "as_n2_singpuri02");
   else if (sWhich=="3") sWhich = CSLSexString(oPC, "as_pl_tavsongm2", "as_n2_singpuri03");
   else                  sWhich = CSLSexString(oPC, "as_pl_tavsongm3", "as_n2_singpuri04");
   AssignCommand(oPC, PlaySound(sWhich));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoScream(object oPC, string sWhich = "")
{
   CSLNWN2Emote(oPC, "talkshout");
   if      (sWhich=="1") sWhich = CSLSexString(oPC, "as_pl_x2screamm1", "as_pl_x2screamf1");
   else if (sWhich=="2") sWhich = CSLSexString(oPC, "as_pl_x2screamm2", "as_pl_x2screamf2");
   else if (sWhich=="3") sWhich = CSLSexString(oPC, "as_pl_x2screamm3", "as_pl_x2screamf3");
   else if (sWhich=="4") sWhich = CSLSexString(oPC, "as_pl_x2screamm4", "as_pl_x2screamf4");
   else                  sWhich = CSLSexString(oPC, "as_pl_x2screamm5", "as_pl_x2screamf5");
   AssignCommand(oPC, PlaySound(sWhich));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoTalk(object oPC, string sWhich = "")
{
   if      (CSLStringStartsWith(sWhich, "c")  || sWhich=="1")  CSLNWN2Emote(oPC, "talkcheer");
   else if (CSLStringStartsWith(sWhich, "f")  || sWhich=="2")  CSLNWN2Emote(oPC, "talkforce");
   else if (CSLStringStartsWith(sWhich, "f1") || sWhich=="3")  CSLNWN2Emote(oPC, "talkforce01");
   else if (CSLStringStartsWith(sWhich, "f2") || sWhich=="4")  CSLNWN2Emote(oPC, "talkforce02");
   else if (CSLStringStartsWith(sWhich, "f3") || sWhich=="5")  CSLNWN2Emote(oPC, "talkforce03");
   else if (CSLStringStartsWith(sWhich, "i")  || sWhich=="6")  CSLNWN2Emote(oPC, "talkinjured");
   else if (CSLStringStartsWith(sWhich, "l")  || sWhich=="7")  CSLNWN2Emote(oPC, "talklaugh");
   else if (CSLStringStartsWith(sWhich, "n")  || sWhich=="8")  CSLNWN2Emote(oPC, "talknervous");
   else if (CSLStringStartsWith(sWhich, "p")  || sWhich=="9")  CSLNWN2Emote(oPC, "talkplead");
   else if (CSLStringStartsWith(sWhich, "s")  || sWhich=="10") CSLNWN2Emote(oPC, "talkshout");
   else if (CSLStringStartsWith(sWhich, "o")  || sWhich=="11") CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_TALK_NORMAL);
   else                                                     CSLNWN2Emote(oPC, "talknormal02");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoTaunt(object oPC, string sWhich = "")
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   PlayVoiceChat(VOICE_CHAT_TAUNT, oPC);
   if   (sWhich=="1") PlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0);
   else               CSLNWN2Emote(oPC, "taunt");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoWhistle(object oPC, string sWhich = "")
{
   if      (sWhich=="1") sWhich = "as_pl_whistle1";
   else if (sWhich=="2") sWhich = "as_pl_whistle2";
   else if (sWhich=="3") sWhich = "gui_whistlesong01";
   else if (sWhich=="4") sWhich = "gui_whistlesong02";
   else if (sWhich=="5") sWhich = "gui_whistlesong03";
   else                  sWhich = "gui_whistlesong04";
   AssignCommand(oPC, PlaySound(sWhich));
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteDoWorship(object oPC, string sWhich = "")
{
   AssignCommand(oPC, ClearAllActions(TRUE));
   if   (sWhich=="1") CSLDoLoopAnimation(oPC, ANIMATION_LOOPING_WORSHIP);
   else               CSLNWN2Emote(oPC, "worship");
}

/**  
* @author
* @param 
* @see 
* @return 
*/
void CSLEmoteRollDie(object oPlayer, int nDie)
{
   int iRoll;
   string sDie;
   switch (nDie)
   {
      case 4: iRoll = d4(); sDie = "D4"; break;
      case 6: iRoll = d6(); sDie = "D6"; break;
      case 8: iRoll = d8(); sDie = "D8"; break;
      case 10: iRoll = d10(); sDie = "D10"; break;
      case 12: iRoll = d12(); sDie = "D12"; break;
      case 20: iRoll = d20(); sDie = "D20"; break;
      case 100: iRoll = d100(); sDie = "D100"; break;
   }
   string sName = GetName(oPlayer);
   string sRoll = IntToString(iRoll);
   AssignCommand(oPlayer, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 3.0, 3.0));
   DelayCommand(2.0, AssignCommand(oPlayer, SpeakString("&&"+"<color=white>"+sName+" rolled a ["+"</color>"+"<color=palegreen>"+sDie+"</color>"+"<color=white>"+"] and got a: ["+"</color>"+"<color=cornflowerblue>"+sRoll+"</color>"+"]")));
   if(iRoll==nDie)
   {
      DelayCommand(3.5, AssignCommand(oPlayer, SpeakString("&&"+"<color=cornflowerblue>"+"Wow! Nice roll!"+"</color>")));
      DelayCommand(3.5, AssignCommand(oPlayer, ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1, 1.0, 0.0)));
      DelayCommand(3.5, PlayVoiceChat(VOICE_CHAT_CHEER, oPlayer));
   }
}


/*
This will have various functions related to visual effects, and relate those visuals with descriptors, damage types and the like.


// Play the background music for oArea.
void MusicBackgroundPlay(object oArea);

// Stop the background music for oArea.
void MusicBackgroundStop(object oArea);

// Set the delay for the background music for oArea.
// - oArea
// - nDelay: delay in milliseconds
void MusicBackgroundSetDelay(object oArea, int nDelay);

// Change the background day track for oArea to nTrack.
// - oArea
// - nTrack
void MusicBackgroundChangeDay(object oArea, int nTrack);

// Change the background night track for oArea to nTrack.
// - oArea
// - nTrack
void MusicBackgroundChangeNight(object oArea, int nTrack);

// Play the battle music for oArea.
void MusicBattlePlay(object oArea);

// Stop the battle music for oArea.
void MusicBattleStop(object oArea);

// Change the battle track for oArea.
// - oArea
// - nTrack
void MusicBattleChange(object oArea, int nTrack);

// Play the ambient sound for oArea.
void AmbientSoundPlay(object oArea);

// Stop the ambient sound for oArea.
void AmbientSoundStop(object oArea);


// Change the ambient day track for oArea to nTrack.
// - oArea
// - nTrack
void AmbientSoundChangeDay(object oArea, int nTrack);

// Change the ambient night track for oArea to nTrack.
// - oArea
// - nTrack
void AmbientSoundChangeNight(object oArea, int nTrack);


// Get the Day Track for oArea.
int MusicBackgroundGetDayTrack(object oArea);

// Get the Night Track for oArea.
int MusicBackgroundGetNightTrack(object oArea);

// Get the duration (in seconds) of the sound attached to nStrRef
// * Returns 0.0f if no duration is stored or if no sound is attached
float GetStrRefSoundDuration(int nStrRef);

// Set the ambient day volume for oArea to nVolume.
// - oArea
// - nVolume: 0 - 100
void AmbientSoundSetDayVolume(object oArea, int nVolume);

// Set the ambient night volume for oArea to nVolume.
// - oArea
// - nVolume: 0 - 100
void AmbientSoundSetNightVolume(object oArea, int nVolume);

// Get the Battle Track for oArea.
int MusicBackgroundGetBattleTrack(object oArea);

// This will play a sound that is associated with a stringRef, it will be a mono sound from the location of the object running the command.
// if nRunAsAction is off then the sound is forced to play intantly.
void PlaySoundByStrRef(int nStrRef, int nRunAsAction = TRUE );


// Changes the current Day/Night cycle for this player to night - Note: This only works for areas that don't use the DayNight Cycle
// - oPlayer: which player to change the sky for
// - fTransitionTime: how long the transition should take(not currently used)
void DayToNight(object oPlayer, float fTransitionTime=0.0f);

// Changes the current Day/Night cycle for this player to daylight - Note: This only works for areas that don't use the DayNight Cycle
// - oPlayer: which player to change the sky for
// - fTransitionTime: how long the transition should take (not currently used)
void NightToDay(object oPlayer, float fTransitionTime=0.0f);



//RWT-OEI 05/11/05
//This function creates a 'Particle Effect' effect.
//It can then be applied to an object or location
effect EffectNWN2ParticleEffect();

//RWT-OEI 05/11/05
//This function returns an effect for a particle emitter with a given
//definition file. Since the file contains most of the parameters,
//fewer parameters are set in the function
effect EffectNWN2ParticleEffectFile( string sDefinitionFile );

//RWT-OEI 05/31/05
//This function creates a Special Effects File effect that can
//then be applied to an object or a location
//For effects that just need a single location (or source object),
//such as particle emitters, the source loc or object comes from
//using ApplyEffectToObject and ApplyEffectToLocation
//For Point-to-Point effects, like beams and lightning, oTarget
//is the target object for the other end of the effect. If oTarget
//is OBJECT_INVALID, then the position located in vTargetPosition
//is used instead. 
effect EffectNWN2SpecialEffectFile( string sFileName, object oTarget=OBJECT_INVALID, vector vTargetPosition=[0.0,0.0,0.0]  );


//RWT-OEI 06/07/05
//This function removes 1 instance of a SEF from an object. Since
//an object can only have 1 instance of a specific SEF running on it
//at once, this should effectively remove 'all' instances of the
//specified SEF from the object
void RemoveSEFFromObject( object oObject, string sSEFName );

// Set the fog properties for oTarget.
// - oTarget: if this is GetModule(), all areas will be modified by the
//   fog settings. If it is an area, only that area will be modified.
// - nFogType: FOG_TYPE*
//   -> FOG_TYPE_SUN, FOG_TYPE_MOON, FOG_TYPE_BOTH
// - nColor: FOG_COLOR*
//   -> You can also pass in a hex RGB number that corresponds to the fog color.
// - fFogStart
//   -> The distance at which the fog starts.
// - fFogEnd
//   -> The distance at which the fog ends and is at its full color.
// - fFarClipPlaneDistance
//   -> The distance at which the world dissapears into the skybox.
// * Note that this function has changed in NWN2.
// * Note that you can use FOG_TYPE_BOTH for the nFogType parameters to set both the MOON and
//	 SUN fog types.
void SetFog( object oTarget, int nFogType, int nColor, float fFogStart, float fFogEnd, float fFarClipPlaneDistance);


// Set the fog properties for oTarget.
// - oTarget: if this is GetModule(), all areas will be modified by the
//   fog settings. If it is an area, only that area will be modified.
// - nFogType: FOG_TYPE*
//   -> FOG_TYPE_SUN, FOG_TYPE_MOON, FOG_TYPE_BOTH
// - nColor: FOG_COLOR*
//   -> You can also pass in a hex RGB number that corresponds to the fog color.
// - fFogStart
//   -> The distance at which the fog starts.
// - fFogEnd
//   -> The distance at which the fog ends and is at its full color.
// - fFarClipPlaneDistance
//   -> The distance at which the world dissapears into the skybox.
// * Note that this function has changed in NWN2.
// * Note that you can use FOG_TYPE_BOTH for the nFogType parameters to set both the MOON and
//	 SUN fog types.
void SetNWN2Fog( object oTarget, int nFogType, int nColor, float fFogStart, float fFogEnd);
void ResetNWN2Fog(object oTarget, int nFogType);


// Brock H. - OEI 04/12/06
// Creates a projectile that uses effects values based on a spell.  This does not actually do damage or have any combat impact, 
// it simply creates a visual effect. 
// Use PROJECTILE_PATH_TYPE_DEFAULT to use the pathing values for that spell
void SpawnSpellProjectile( object oSource, object oTaget, location lSource, location lTarget, int iSpellId, int iProjectilePathType );


// Brock H. - OEI 04/12/06
// Creates a projectile that uses the models and effects for weapons. This does not actually do damage or have any combat impact, 
// it simply creates a visual effect. 
// Currently, the only damage type flags supported are Acid, Cold, Electrical, Fire, and Sonic. 
// nBaseItemID - This is the row in the baseitemtypes.2DA that defines the launcher for this projectile. It is used to determine the ammunition type for the projectile
// iProjectilePathType - must be PROJECTILE_PATH_TYPE_* from above
// iAttackType - This must be OVERRIDE_ATTACK_RESULT_HIT_SUCCESSFUL, PARRIED, CRITICAL_HIT, or MISS             
// nDamageTypeFlag - Used to attach a visual to the projectile. Supported types are DAMAGE_TYPE_ACID, COLD, ELECTRICAL, FIRE, DIVINE, SONIC     
void SpawnItemProjectile( object oSource, object oTaget, location lSource, location lTarget, int nBaseItemID, int iProjectilePathType, int iAttackType, int nDamageTypeFlag );

// Brock H. - OEI 04/21/06
// This will calculate the length of time it will take for a projectile to 
// to travel between the locations. If you specify PROJECTILE_PATH_TYPE_SPELL
// and a valid spell ID, it will look up the spell's projectile path type from 
// the Spell 2DA
float GetProjectileTravelTime( location lSource, location lTarget, int iProjectilePathType, int iSpellId=-1 );




// The action subject will fake casting a spell at oTarget; the conjure and cast
// animations and visuals will occur, nothing else.
// - iSpellId
// - oTarget
// - iProjectilePathType: PROJECTILE_PATH_TYPE_*
void ActionCastFakeSpellAtObject(int iSpellId, object oTarget, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT);

// The action subject will fake casting a spell at lLocation; the conjure and
// cast animations and visuals will occur, nothing else.
// - iSpellId
// - lTarget
// - iProjectilePathType: PROJECTILE_PATH_TYPE_*
void ActionCastFakeSpellAtLocation(int iSpellId, location lTarget, int iProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT);


// Set the weather for oTarget.
// - oTarget: if this is GetModule(), all outdoor areas will be modified by the
//   weather constant. If it is an area, oTarget will play the weather only if
//   it is an outdoor area.
// - nWeather: WEATHER_TYPE*
//   -> WEATHER_TYPE_RAIN, WEATHER_TYPE_SNOW, WEATHER_TYPE_LIGHTNING are the weather
//   -> patterns you can set.
// - nPower: WEATHER_POWER_*
//   -> WEATHER_POWER_USE_AREA_SETTINGS will set the area back to use the area's weather pattern.
//   -> WEATHER_POWER_OFF, WEATHER_POWER_WEAK, WEATHER_POWER_LIGHT, WEATHER_POWER_MEDIUM,
//   -> WEATHER_POWER_HEAVY, WEATHER_POWER_STORMY are the different weather pattern settings.
// * Note that this function has changed in NWN2.
void SetWeather(object oTarget, int nWeatherType, int nPower = WEATHER_POWER_MEDIUM);


// FAK - OEI 5/16/05
// Returns TRUE if it found an object to play a custom animation one
// oObject is the object to play the animation on
// sAnimationName is the name of the gr2 to play
// nLooping is 0 for one-off, 1 for loop
// fSpeed is the playback speed: 1.0 is default, < 0 is backwards
int PlayCustomAnimation( object oObject, string sAnimationName, int nLooping, float fSpeed = 1.0f );

// Brock H. - OEI 10/19/06
// This will create a "blood" effect as if the creature has taken damage. 
// oCreature -  The creature that the blood is spawned from. This will
//              creature's blood type will be looked up based on the 
//              creature's appearance. 
// bCritical -  This controls whether the blood being spawned is standard, or 
//              mimics a "Critical Hit"
// oAttacker -  This represents the creature that would be damaging the target
//              creature, which may alter the trajectory of the particles. 
//              OBJECT_INVALID can be used here. 
void SpawnBloodHit( object oCreature, int bCriticalHit, object oAttacker );



// AFW-OEI 02/13/2007
// Returns an effect that adds an effect icon to a character portrait.
// * nEffectIconId comes from the effecticon.2da
effect EffectEffectIcon(int nEffectIconId);


//RWT-OEI 04/03/07
//Toggle whether or not water is being rendered in the specified
//area
// - oArea: The area to toggle the setting in
// - bRender: Whether or not to render the water in that area
void SetRenderWaterInArea( object oArea, int bRender );


//RWT-OEI 01/14/08
//Change the scale of an object. This doesn't apply a scale effect like
//the EffectSetScale function is used for, but rather changes the base
//scale of the target. If the target object has any SetScale effects
//on it, the end result is likely to be different than the values set
//with this.
// - oObject - Must be creature or placeable.
// - fX, fY, fZ - The 3 scales to set
void SetScale( object oObject, float fX, float fY, float fZ );

//RWT-OEI 01/14/08
//Get the scale of the object based on which axis is looked up.
//Does not take into account any EffectSetScale effects that might
//be altering the scale of the object. 
// - oObject - Must be creature or placeable
// - nAxis: Use SCALE_X, SCALE_Y, SCALE_Z
float GetScale( object oObject, int nAxis );


//RWT-OEI 09/03/08
//Returns the duration of a sound file in milliseconds
// sSound - Name of the sound file. No extention.
//Returns 0 if the sound file was not found
int GetSoundFileDuration( string sSoundFile ); 





*/


// simtools here
string GetVFXName(int nVFX)
{
    string sReturn = "";
    switch (nVFX/100)
    {
        case 0:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 0: sReturn = "VFX_DUR_BLUR"; break;
case 1: sReturn = "VFX_DUR_DARKNESS"; break;
case 2: sReturn = "VFX_DUR_ENTANGLE"; break;
case 3: sReturn = "VFX_DUR_FREEDOM_OF_MOVEMENT"; break;
case 4: sReturn = "VFX_DUR_GLOBE_INVULNERABILITY"; break;
case 5: sReturn = "VFX_DUR_BLACKOUT"; break;
case 6: sReturn = "VFX_DUR_INVISIBILITY"; break;
case 7: sReturn = "VFX_DUR_MIND_AFFECTING_NEGATIVE"; break;
case 8: sReturn = "VFX_DUR_MIND_AFFECTING_POSITIVE"; break;
case 9: sReturn = "VFX_DUR_GHOSTLY_VISAGE"; break;
case 10: sReturn = "VFX_DUR_ETHEREAL_VISAGE"; break;
case 11: sReturn = "VFX_DUR_PROT_BARKSKIN"; break;
case 12: sReturn = "VFX_DUR_PROT_GREATER_STONESKIN"; break;
case 13: sReturn = "VFX_DUR_PROT_PREMONITION"; break;
case 14: sReturn = "VFX_DUR_PROT_SHADOW_ARMOR"; break;
case 15: sReturn = "VFX_DUR_PROT_STONESKIN"; break;
case 16: sReturn = "VFX_DUR_SANCTUARY"; break;
case 17: sReturn = "VFX_DUR_WEB"; break;
case 18: sReturn = "VFX_FNF_BLINDDEAF"; break;
case 19: sReturn = "VFX_FNF_DISPEL"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 20: sReturn = "VFX_FNF_DISPEL_DISJUNCTION"; break;
case 21: sReturn = "VFX_FNF_DISPEL_GREATER"; break;
case 22: sReturn = "VFX_FNF_FIREBALL"; break;
case 23: sReturn = "VFX_FNF_FIRESTORM"; break;
case 24: sReturn = "VFX_FNF_IMPLOSION"; break;
//case 25: sReturn = "VFX_FNF_MASS_HASTE"; break;
case 26: sReturn = "VFX_FNF_MASS_HEAL"; break;
case 27: sReturn = "VFX_FNF_MASS_MIND_AFFECTING"; break;
case 28: sReturn = "VFX_FNF_METEOR_SWARM"; break;
case 29: sReturn = "VFX_FNF_NATURES_BALANCE"; break;
case 30: sReturn = "VFX_FNF_PWKILL"; break;
case 31: sReturn = "VFX_FNF_PWSTUN"; break;
case 32: sReturn = "VFX_FNF_SUMMON_GATE"; break;
case 33: sReturn = "VFX_FNF_SUMMON_MONSTER_1"; break;
case 34: sReturn = "VFX_FNF_SUMMON_MONSTER_2"; break;
case 35: sReturn = "VFX_FNF_SUMMON_MONSTER_3"; break;
case 36: sReturn = "VFX_FNF_SUMMON_UNDEAD"; break;
case 37: sReturn = "VFX_FNF_SUNBEAM"; break;
case 38: sReturn = "VFX_FNF_TIME_STOP"; break;
case 39: sReturn = "VFX_FNF_WAIL_O_BANSHEES"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 40: sReturn = "VFX_FNF_WEIRD"; break;
case 41: sReturn = "VFX_FNF_WORD"; break;
case 42: sReturn = "VFX_IMP_AC_BONUS"; break;
case 43: sReturn = "VFX_IMP_ACID_L"; break;
case 44: sReturn = "VFX_IMP_ACID_S"; break;
//case 45: sReturn = "VFX_IMP_ALTER_WEAPON"; break;
case 46: sReturn = "VFX_IMP_BLIND_DEAF_M"; break;
case 47: sReturn = "VFX_IMP_BREACH"; break;
case 48: sReturn = "VFX_IMP_CONFUSION_S"; break;
case 49: sReturn = "VFX_IMP_DAZED_S"; break;
case 50: sReturn = "VFX_IMP_DEATH"; break;
case 51: sReturn = "VFX_IMP_DISEASE_S"; break;
case 52: sReturn = "VFX_IMP_DISPEL"; break;
case 53: sReturn = "VFX_IMP_DISPEL_DISJUNCTION"; break;
case 54: sReturn = "VFX_IMP_DIVINE_STRIKE_FIRE"; break;
case 55: sReturn = "VFX_IMP_DIVINE_STRIKE_HOLY"; break;
case 56: sReturn = "VFX_IMP_DOMINATE_S"; break;
case 57: sReturn = "VFX_IMP_DOOM"; break;
case 58: sReturn = "VFX_IMP_FEAR_S"; break;
//case 59: sReturn = "VFX_IMP_FLAME_L"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 60: sReturn = "VFX_IMP_FLAME_M"; break;
case 61: sReturn = "VFX_IMP_FLAME_S"; break;
case 62: sReturn = "VFX_IMP_FROST_L"; break;
case 63: sReturn = "VFX_IMP_FROST_S"; break;
case 64: sReturn = "VFX_IMP_GREASE"; break;
case 65: sReturn = "VFX_IMP_HASTE"; break;
case 66: sReturn = "VFX_IMP_HEALING_G"; break;
case 67: sReturn = "VFX_IMP_HEALING_L"; break;
case 68: sReturn = "VFX_IMP_HEALING_M"; break;
case 69: sReturn = "VFX_IMP_HEALING_S"; break;
case 70: sReturn = "VFX_IMP_HEALING_X"; break;
case 71: sReturn = "VFX_IMP_HOLY_AID"; break;
case 72: sReturn = "VFX_IMP_KNOCK"; break;
case 73: sReturn = "VFX_BEAM_LIGHTNING"; break;
case 74: sReturn = "VFX_IMP_LIGHTNING_M"; break;
case 75: sReturn = "VFX_IMP_LIGHTNING_S"; break;
case 76: sReturn = "VFX_IMP_MAGBLUE"; break;
//case 77: sReturn = "VFX_IMP_MAGBLUE2"; break;
//case 78: sReturn = "VFX_IMP_MAGBLUE3"; break;
//case 79: sReturn = "VFX_IMP_MAGBLUE4"; break;
            }
            break;
            case 4:
            switch (nVFX)
            {
//case 80: sReturn = "VFX_IMP_MAGBLUE5"; break;
case 81: sReturn = "VFX_IMP_NEGATIVE_ENERGY"; break;
case 82: sReturn = "VFX_DUR_PARALYZE_HOLD"; break;
case 83: sReturn = "VFX_IMP_POISON_L"; break;
case 84: sReturn = "VFX_IMP_POISON_S"; break;
case 85: sReturn = "VFX_IMP_POLYMORPH"; break;
case 86: sReturn = "VFX_IMP_PULSE_COLD"; break;
case 87: sReturn = "VFX_IMP_PULSE_FIRE"; break;
case 88: sReturn = "VFX_IMP_PULSE_HOLY"; break;
case 89: sReturn = "VFX_IMP_PULSE_NEGATIVE"; break;
case 90: sReturn = "VFX_IMP_RAISE_DEAD"; break;
case 91: sReturn = "VFX_IMP_REDUCE_ABILITY_SCORE"; break;
case 92: sReturn = "VFX_IMP_REMOVE_CONDITION"; break;
case 93: sReturn = "VFX_IMP_SILENCE"; break;
case 94: sReturn = "VFX_IMP_SLEEP"; break;
case 95: sReturn = "VFX_IMP_SLOW"; break;
case 96: sReturn = "VFX_IMP_SONIC"; break;
case 97: sReturn = "VFX_IMP_STUN"; break;
case 98: sReturn = "VFX_IMP_SUNSTRIKE"; break;
case 99: sReturn = "VFX_IMP_UNSUMMON"; break;
            }
            break;
        }
        break;
        case 1:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 100: sReturn = "VFX_COM_SPECIAL_BLUE_RED"; break;
case 101: sReturn = "VFX_COM_SPECIAL_PINK_ORANGE"; break;
case 102: sReturn = "VFX_COM_SPECIAL_RED_WHITE"; break;
case 103: sReturn = "VFX_COM_SPECIAL_RED_ORANGE"; break;
case 104: sReturn = "VFX_COM_SPECIAL_WHITE_BLUE"; break;
case 105: sReturn = "VFX_COM_SPECIAL_WHITE_ORANGE"; break;
case 106: sReturn = "VFX_COM_BLOOD_REG_WIMP"; break;
case 107: sReturn = "VFX_COM_BLOOD_LRG_WIMP"; break;
case 108: sReturn = "VFX_COM_BLOOD_CRT_WIMP"; break;
case 109: sReturn = "VFX_COM_BLOOD_REG_RED"; break;
case 110: sReturn = "VFX_COM_BLOOD_REG_GREEN"; break;
case 111: sReturn = "VFX_COM_BLOOD_REG_YELLOW"; break;
case 112: sReturn = "VFX_COM_BLOOD_LRG_RED"; break;
case 113: sReturn = "VFX_COM_BLOOD_LRG_GREEN"; break;
case 114: sReturn = "VFX_COM_BLOOD_LRG_YELLOW"; break;
case 115: sReturn = "VFX_COM_BLOOD_CRT_RED"; break;
case 116: sReturn = "VFX_COM_BLOOD_CRT_GREEN"; break;
case 117: sReturn = "VFX_COM_BLOOD_CRT_YELLOW"; break;
case 118: sReturn = "VFX_COM_SPARKS_PARRY"; break;
//case 119: sReturn = "VFX_COM_GIB"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 120: sReturn = "VFX_COM_UNLOAD_MODEL"; break;
case 121: sReturn = "VFX_COM_CHUNK_RED_SMALL"; break;
case 122: sReturn = "VFX_COM_CHUNK_RED_MEDIUM"; break;
case 123: sReturn = "VFX_COM_CHUNK_GREEN_SMALL"; break;
case 124: sReturn = "VFX_COM_CHUNK_GREEN_MEDIUM"; break;
case 125: sReturn = "VFX_COM_CHUNK_YELLOW_SMALL"; break;
case 126: sReturn = "VFX_COM_CHUNK_YELLOW_MEDIUM"; break;
/*case 127: sReturn = "VFX_ITM_ACID"; break;
case 128: sReturn = "VFX_ITM_FIRE"; break;
case 129: sReturn = "VFX_ITM_FROST"; break;
case 130: sReturn = "VFX_ITM_ILLUMINATED_BLUE"; break;
case 131: sReturn = "VFX_ITM_ILLUMINATED_PURPLE"; break;
case 132: sReturn = "VFX_ITM_ILLUMINATED_RED"; break;
case 133: sReturn = "VFX_ITM_LIGHTNING"; break;
case 134: sReturn = "VFX_ITM_PULSING_BLUE"; break;
case 135: sReturn = "VFX_ITM_PULSING_PURPLE"; break;
case 136: sReturn = "VFX_ITM_PULSING_RED"; break;
case 137: sReturn = "VFX_ITM_SMOKING"; break;*/
case 138: sReturn = "VFX_DUR_SPELLTURNING"; break;
case 139: sReturn = "VFX_IMP_IMPROVE_ABILITY_SCORE"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 140: sReturn = "VFX_IMP_CHARM"; break;
case 141: sReturn = "VFX_IMP_MAGICAL_VISION"; break;
//case 142: sReturn = "VFX_IMP_LAW_HELP"; break;
//case 143: sReturn = "VFX_IMP_CHAOS_HELP"; break;
case 144: sReturn = "VFX_IMP_EVIL_HELP"; break;
case 145: sReturn = "VFX_IMP_GOOD_HELP"; break;
case 146: sReturn = "VFX_IMP_DEATH_WARD"; break;
case 147: sReturn = "VFX_DUR_ELEMENTAL_SHIELD"; break;
case 148: sReturn = "VFX_DUR_LIGHT"; break;
case 149: sReturn = "VFX_IMP_MAGIC_PROTECTION"; break;
case 150: sReturn = "VFX_IMP_SUPER_HEROISM"; break;
case 151: sReturn = "VFX_FNF_STORM"; break;
case 152: sReturn = "VFX_IMP_ELEMENTAL_PROTECTION"; break;
case 153: sReturn = "VFX_DUR_LIGHT_BLUE_5"; break;
case 154: sReturn = "VFX_DUR_LIGHT_BLUE_10"; break;
case 155: sReturn = "VFX_DUR_LIGHT_BLUE_15"; break;
case 156: sReturn = "VFX_DUR_LIGHT_BLUE_20"; break;
case 157: sReturn = "VFX_DUR_LIGHT_YELLOW_5"; break;
case 158: sReturn = "VFX_DUR_LIGHT_YELLOW_10"; break;
case 159: sReturn = "VFX_DUR_LIGHT_YELLOW_15"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 160: sReturn = "VFX_DUR_LIGHT_YELLOW_20"; break;
case 161: sReturn = "VFX_DUR_LIGHT_PURPLE_5"; break;
case 162: sReturn = "VFX_DUR_LIGHT_PURPLE_10"; break;
case 163: sReturn = "VFX_DUR_LIGHT_PURPLE_15"; break;
case 164: sReturn = "VFX_DUR_LIGHT_PURPLE_20"; break;
case 165: sReturn = "VFX_DUR_LIGHT_RED_5"; break;
case 166: sReturn = "VFX_DUR_LIGHT_RED_10"; break;
case 167: sReturn = "VFX_DUR_LIGHT_RED_15"; break;
case 168: sReturn = "VFX_DUR_LIGHT_RED_20"; break;
case 169: sReturn = "VFX_DUR_LIGHT_ORANGE_5"; break;
case 170: sReturn = "VFX_DUR_LIGHT_ORANGE_10"; break;
case 171: sReturn = "VFX_DUR_LIGHT_ORANGE_15"; break;
case 172: sReturn = "VFX_DUR_LIGHT_ORANGE_20"; break;
case 173: sReturn = "VFX_DUR_LIGHT_WHITE_5"; break;
case 174: sReturn = "VFX_DUR_LIGHT_WHITE_10"; break;
case 175: sReturn = "VFX_DUR_LIGHT_WHITE_15"; break;
case 176: sReturn = "VFX_DUR_LIGHT_WHITE_20"; break;
case 177: sReturn = "VFX_DUR_LIGHT_GREY_5"; break;
case 178: sReturn = "VFX_DUR_LIGHT_GREY_10"; break;
case 179: sReturn = "VFX_DUR_LIGHT_GREY_15"; break;
            }
            break;
            case 4:
            switch (nVFX)
            {
case 180: sReturn = "VFX_DUR_LIGHT_GREY_20"; break;
case 181: sReturn = "VFX_IMP_MIRV"; break;
case 182: sReturn = "VFX_DUR_DARKVISION"; break;
case 183: sReturn = "VFX_FNF_SOUND_BURST"; break;
case 184: sReturn = "VFX_FNF_STRIKE_HOLY"; break;
case 185: sReturn = "VFX_FNF_LOS_EVIL_10"; break;
case 186: sReturn = "VFX_FNF_LOS_EVIL_20"; break;
case 187: sReturn = "VFX_FNF_LOS_EVIL_30"; break;
case 188: sReturn = "VFX_FNF_LOS_HOLY_10"; break;
case 189: sReturn = "VFX_FNF_LOS_HOLY_20"; break;
case 190: sReturn = "VFX_FNF_LOS_HOLY_30"; break;
case 191: sReturn = "VFX_FNF_LOS_NORMAL_10"; break;
case 192: sReturn = "VFX_FNF_LOS_NORMAL_20"; break;
case 193: sReturn = "VFX_FNF_LOS_NORMAL_30"; break;
case 194: sReturn = "VFX_IMP_HEAD_ACID"; break;
case 195: sReturn = "VFX_IMP_HEAD_FIRE"; break;
case 196: sReturn = "VFX_IMP_HEAD_SONIC"; break;
case 197: sReturn = "VFX_IMP_HEAD_ELECTRICITY"; break;
case 198: sReturn = "VFX_IMP_HEAD_COLD"; break;
case 199: sReturn = "VFX_IMP_HEAD_HOLY"; break;
            }
            break;
        }
        break;
        case 2:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 200: sReturn = "VFX_IMP_HEAD_NATURE"; break;
case 201: sReturn = "VFX_IMP_HEAD_HEAL"; break;
case 202: sReturn = "VFX_IMP_HEAD_MIND"; break;
case 203: sReturn = "VFX_IMP_HEAD_EVIL"; break;
case 204: sReturn = "VFX_IMP_HEAD_ODD"; break;
case 205: sReturn = "VFX_DUR_CESSATE_NEUTRAL"; break;
case 206: sReturn = "VFX_DUR_CESSATE_POSITIVE"; break;
case 207: sReturn = "VFX_DUR_CESSATE_NEGATIVE"; break;
case 208: sReturn = "VFX_DUR_MIND_AFFECTING_DISABLED"; break;
case 209: sReturn = "VFX_DUR_MIND_AFFECTING_DOMINATED"; break;
case 210: sReturn = "VFX_BEAM_FIRE"; break;
case 211: sReturn = "VFX_BEAM_COLD"; break;
case 212: sReturn = "VFX_BEAM_HOLY"; break;
case 213: sReturn = "VFX_BEAM_MIND"; break;
case 214: sReturn = "VFX_BEAM_EVIL"; break;
case 215: sReturn = "VFX_BEAM_ODD"; break;
case 216: sReturn = "VFX_BEAM_FIRE_LASH"; break;
case 217: sReturn = "VFX_IMP_DEATH_L"; break;
case 218: sReturn = "VFX_DUR_MIND_AFFECTING_FEAR"; break;
case 219: sReturn = "VFX_FNF_SUMMON_CELESTIAL"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 220: sReturn = "VFX_DUR_GLOBE_MINOR"; break;
case 221: sReturn = "VFX_IMP_RESTORATION_LESSER"; break;
case 222: sReturn = "VFX_IMP_RESTORATION"; break;
case 223: sReturn = "VFX_IMP_RESTORATION_GREATER"; break;
case 224: sReturn = "VFX_DUR_PROTECTION_ELEMENTS"; break;
case 225: sReturn = "VFX_DUR_PROTECTION_GOOD_MINOR"; break;
case 226: sReturn = "VFX_DUR_PROTECTION_GOOD_MAJOR"; break;
case 227: sReturn = "VFX_DUR_PROTECTION_EVIL_MINOR"; break;
case 228: sReturn = "VFX_DUR_PROTECTION_EVIL_MAJOR"; break;
case 229: sReturn = "VFX_DUR_MAGICAL_SIGHT"; break;
case 230: sReturn = "VFX_DUR_WEB_MASS"; break;
case 231: sReturn = "VFX_FNF_ICESTORM"; break;
case 232: sReturn = "VFX_DUR_PARALYZED"; break;
case 233: sReturn = "VFX_IMP_MIRV_FLAME"; break;
case 234: sReturn = "VFX_IMP_DESTRUCTION"; break;
case 235: sReturn = "VFX_COM_CHUNK_RED_LARGE"; break;
case 236: sReturn = "VFX_COM_CHUNK_BONE_MEDIUM"; break;
case 237: sReturn = "VFX_COM_BLOOD_SPARK_SMALL"; break;
case 238: sReturn = "VFX_COM_BLOOD_SPARK_MEDIUM"; break;
case 239: sReturn = "VFX_COM_BLOOD_SPARK_LARGE"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 240: sReturn = "VFX_DUR_GHOSTLY_PULSE"; break;
case 241: sReturn = "VFX_FNF_HORRID_WILTING"; break;
case 242: sReturn = "VFX_DUR_BLINDVISION"; break;
case 243: sReturn = "VFX_DUR_LOWLIGHTVISION"; break;
case 244: sReturn = "VFX_DUR_ULTRAVISION"; break;
case 245: sReturn = "VFX_DUR_MIRV_ACID"; break;
case 246: sReturn = "VFX_IMP_HARM"; break;
case 247: sReturn = "VFX_DUR_BLIND"; break;
case 248: sReturn = "VFX_DUR_ANTI_LIGHT_10"; break;
case 249: sReturn = "VFX_DUR_MAGIC_RESISTANCE"; break;
case 250: sReturn = "VFX_IMP_MAGIC_RESISTANCE_USE"; break;
case 251: sReturn = "VFX_IMP_GLOBE_USE"; break;
case 252: sReturn = "VFX_IMP_WILL_SAVING_THROW_USE"; break;
case 253: sReturn = "VFX_IMP_SPIKE_TRAP"; break;
case 254: sReturn = "VFX_IMP_SPELL_MANTLE_USE"; break;
case 255: sReturn = "VFX_IMP_FORTITUDE_SAVING_THROW_USE"; break;
case 256: sReturn = "VFX_IMP_REFLEX_SAVE_THROW_USE"; break;
case 257: sReturn = "VFX_FNF_GAS_EXPLOSION_ACID"; break;
case 258: sReturn = "VFX_FNF_GAS_EXPLOSION_EVIL"; break;
case 259: sReturn = "VFX_FNF_GAS_EXPLOSION_NATURE"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 260: sReturn = "VFX_FNF_GAS_EXPLOSION_FIRE"; break;
case 261: sReturn = "VFX_FNF_GAS_EXPLOSION_GREASE"; break;
case 262: sReturn = "VFX_FNF_GAS_EXPLOSION_MIND"; break;
case 263: sReturn = "VFX_FNF_SMOKE_PUFF"; break;
case 264: sReturn = "VFX_IMP_PULSE_WATER"; break;
case 265: sReturn = "VFX_IMP_PULSE_WIND"; break;
case 266: sReturn = "VFX_IMP_PULSE_NATURE"; break;
case 267: sReturn = "VFX_DUR_AURA_COLD"; break;
case 268: sReturn = "VFX_DUR_AURA_FIRE"; break;
case 269: sReturn = "VFX_DUR_AURA_POISON"; break;
case 270: sReturn = "VFX_DUR_AURA_DISEASE"; break;
case 271: sReturn = "VFX_DUR_AURA_ODD"; break;
case 272: sReturn = "VFX_DUR_AURA_SILENCE"; break;
case 273: sReturn = "VFX_IMP_AURA_HOLY"; break;
case 274: sReturn = "VFX_IMP_AURA_UNEARTHLY"; break;
case 275: sReturn = "VFX_IMP_AURA_FEAR"; break;
case 276: sReturn = "VFX_IMP_AURA_NEGATIVE_ENERGY"; break;
case 277: sReturn = "VFX_DUR_BARD_SONG"; break;
case 278: sReturn = "VFX_FNF_HOWL_MIND"; break;
case 279: sReturn = "VFX_FNF_HOWL_ODD"; break;
            }
            break;
            case 4:
            switch (nVFX)
            {
case 280: sReturn = "VFX_COM_HIT_FIRE"; break;
case 281: sReturn = "VFX_COM_HIT_FROST"; break;
case 282: sReturn = "VFX_COM_HIT_ELECTRICAL"; break;
case 283: sReturn = "VFX_COM_HIT_ACID"; break;
case 284: sReturn = "VFX_COM_HIT_SONIC"; break;
case 285: sReturn = "VFX_FNF_HOWL_WAR_CRY"; break;
case 286: sReturn = "VFX_FNF_SCREEN_SHAKE"; break;
case 287: sReturn = "VFX_FNF_SCREEN_BUMP"; break;
case 288: sReturn = "VFX_COM_HIT_NEGATIVE"; break;
case 289: sReturn = "VFX_COM_HIT_DIVINE"; break;
case 290: sReturn = "VFX_FNF_HOWL_WAR_CRY_FEMALE"; break;
case 291: sReturn = "VFX_DUR_AURA_DRAGON_FEAR"; break;
            }
            break;
        }
        break;
        case 3:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 303: sReturn = "VFX_DUR_FLAG_RED"; break;
case 304: sReturn = "VFX_DUR_FLAG_BLUE"; break;
case 305: sReturn = "VFX_DUR_FLAG_PURPLE_FIXED"; break;
case 306: sReturn = "VFX_DUR_FLAG_GOLD_FIXED"; break;
case 307: sReturn = "VFX_BEAM_SILENT_LIGHTNING"; break;
case 308: sReturn = "VFX_BEAM_SILENT_FIRE"; break;
case 309: sReturn = "VFX_BEAM_SILENT_COLD"; break;
case 310: sReturn = "VFX_BEAM_SILENT_HOLY"; break;
case 311: sReturn = "VFX_BEAM_SILENT_MIND"; break;
case 312: sReturn = "VFX_BEAM_SILENT_EVIL"; break;
case 313: sReturn = "VFX_BEAM_SILENT_ODD"; break;
case 314: sReturn = "VFX_DUR_BIGBYS_INTERPOSING_HAND"; break;
case 315: sReturn = "VFX_IMP_BIGBYS_FORCEFUL_HAND"; break;
case 316: sReturn = "VFX_DUR_BIGBYS_CLENCHED_FIST"; break;
case 317: sReturn = "VFX_DUR_BIGBYS_CRUSHING_HAND"; break;
case 318: sReturn = "VFX_DUR_BIGBYS_GRASPING_HAND"; break;
case 319: sReturn = "VFX_DUR_CALTROPS"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 320: sReturn = "VFX_DUR_SMOKE"; break;
case 321: sReturn = "VFX_DUR_PIXIEDUST"; break;
case 322: sReturn = "VFX_FNF_DECK"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 346: sReturn = "VFX_DUR_TENTACLE"; break;
case 351: sReturn = "VFX_DUR_PETRIFY"; break;
case 352: sReturn = "VFX_DUR_FREEZE_ANIMATION"; break;
case 353: sReturn = "VFX_COM_CHUNK_STONE_SMALL"; break;
case 354: sReturn = "VFX_COM_CHUNK_STONE_MEDIUM"; break;
case 355: sReturn = "VFX_DUR_CUTSCENE_INVISIBILITY"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 360: sReturn = "VFX_EYES_RED_FLAME_HUMAN_MALE"; break;
case 361: sReturn = "VFX_EYES_RED_FLAME_HUMAN_FEMALE"; break;
case 362: sReturn = "VFX_EYES_RED_FLAME_DWARF_MALE"; break;
case 363: sReturn = "VFX_EYES_RED_FLAME_DWARF_FEMALE"; break;
case 364: sReturn = "VFX_EYES_RED_FLAME_ELF_MALE"; break;
case 365: sReturn = "VFX_EYES_RED_FLAME_ELF_FEMALE"; break;
case 366: sReturn = "VFX_EYES_RED_FLAME_GNOME_MALE"; break;
case 367: sReturn = "VFX_EYES_RED_FLAME_GNOME_FEMALE"; break;
case 368: sReturn = "VFX_EYES_RED_FLAME_HALFLING_MALE"; break;
case 369: sReturn = "VFX_EYES_RED_FLAME_HALFLING_FEMALE"; break;
case 370: sReturn = "VFX_EYES_RED_FLAME_HALFORC_MALE"; break;
case 371: sReturn = "VFX_EYES_RED_FLAME_HALFORC_FEMALE"; break;
case 372: sReturn = "VFX_EYES_RED_FLAME_TROGLODYTE"; break;
            }
            break;
        }
        break;
        case 4:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 403: sReturn = "VFX_DUR_IOUNSTONE"; break;
case 407: sReturn = "VFX_IMP_TORNADO"; break;
case 408: sReturn = "VFX_DUR_GLOW_LIGHT_BLUE"; break;
case 409: sReturn = "VFX_DUR_GLOW_PURPLE"; break;
case 410: sReturn = "VFX_DUR_GLOW_BLUE"; break;
case 411: sReturn = "VFX_DUR_GLOW_RED"; break;
case 412: sReturn = "VFX_DUR_GLOW_LIGHT_RED"; break;
case 413: sReturn = "VFX_DUR_GLOW_YELLOW"; break;
case 414: sReturn = "VFX_DUR_GLOW_LIGHT_YELLOW"; break;
case 415: sReturn = "VFX_DUR_GLOW_GREEN"; break;
case 416: sReturn = "VFX_DUR_GLOW_LIGHT_GREEN"; break;
case 417: sReturn = "VFX_DUR_GLOW_ORANGE"; break;
case 418: sReturn = "VFX_DUR_GLOW_LIGHT_ORANGE"; break;
case 419: sReturn = "VFX_DUR_GLOW_BROWN"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 420: sReturn = "VFX_DUR_GLOW_LIGHT_BROWN"; break;
case 421: sReturn = "VFX_DUR_GLOW_GREY"; break;
case 422: sReturn = "VFX_DUR_GLOW_WHITE"; break;
case 423: sReturn = "VFX_DUR_GLOW_LIGHT_PURPLE"; break;
case 424: sReturn = "VFX_DUR_GHOST_TRANSPARENT"; break;
case 425: sReturn = "VFX_DUR_GHOST_SMOKE"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 445: sReturn = "VFX_DUR_GLYPH_OF_WARDING"; break;
case 446: sReturn = "VFX_FNF_SOUND_BURST_SILENT"; break;
case 459: sReturn = "VFX_FNF_ELECTRIC_EXPLOSION"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 460: sReturn = "VFX_IMP_DUST_EXPLOSION"; break;
case 461: sReturn = "VFX_IMP_PULSE_HOLY_SILENT"; break;
case 463: sReturn = "VFX_DUR_DEATH_ARMOR"; break;
case 465: sReturn = "VFX_DUR_ICESKIN"; break;
case 473: sReturn = "VFX_FNF_SWINGING_BLADE"; break;
case 474: sReturn = "VFX_DUR_INFERNO"; break;
case 475: sReturn = "VFX_FNF_DEMON_HAND"; break;
case 476: sReturn = "VFX_DUR_STONEHOLD"; break;
case 477: sReturn = "VFX_FNF_MYSTICAL_EXPLOSION"; break;
case 478: sReturn = "VFX_DUR_GHOSTLY_VISAGE_NO_SOUND"; break;
case 479: sReturn = "VFX_DUR_GHOST_SMOKE_2"; break;
            }
            break;
            case 4:
            switch (nVFX)
            {
case 480: sReturn = "VFX_DUR_FLIES"; break;
case 481: sReturn = "VFX_FNF_SUMMONDRAGON"; break;
case 482: sReturn = "VFX_BEAM_FIRE_W"; break;
case 483: sReturn = "VFX_BEAM_FIRE_W_SILENT"; break;
case 484: sReturn = "VFX_BEAM_CHAIN"; break;
case 485: sReturn = "VFX_BEAM_BLACK"; break;
case 486: sReturn = "VFX_IMP_WALLSPIKE"; break;
case 487: sReturn = "VFX_FNF_GREATER_RUIN"; break;
case 488: sReturn = "VFX_FNF_UNDEAD_DRAGON"; break;
case 495: sReturn = "VFX_DUR_PROT_EPIC_ARMOR"; break;
case 496: sReturn = "VFX_FNF_SUMMON_EPIC_UNDEAD"; break;
case 497: sReturn = "VFX_DUR_PROT_EPIC_ARMOR_2"; break;
case 498: sReturn = "VFX_DUR_INFERNO_CHEST"; break;
case 499: sReturn = "VFX_DUR_IOUNSTONE_RED"; break;
            }
            break;
        }
        break;
        case 5:
        switch ((nVFX%100)/20)
        {
            case 0:
            switch (nVFX)
            {
case 500: sReturn = "VFX_DUR_IOUNSTONE_BLUE"; break;
case 501: sReturn = "VFX_DUR_IOUNSTONE_YELLOW"; break;
case 502: sReturn = "VFX_DUR_IOUNSTONE_GREEN"; break;
case 503: sReturn = "VFX_IMP_MIRV_ELECTRIC"; break;
case 504: sReturn = "VFX_COM_CHUNK_RED_BALLISTA"; break;
case 505: sReturn = "VFX_DUR_INFERNO_NO_SOUND"; break;
case 512: sReturn = "VFX_DUR_AURA_PULSE_RED_WHITE"; break;
case 513: sReturn = "VFX_DUR_AURA_PULSE_BLUE_WHITE"; break;
case 514: sReturn = "VFX_DUR_AURA_PULSE_GREEN_WHITE"; break;
case 515: sReturn = "VFX_DUR_AURA_PULSE_YELLOW_WHITE"; break;
case 516: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_WHITE"; break;
case 517: sReturn = "VFX_DUR_AURA_PULSE_CYAN_WHITE"; break;
case 518: sReturn = "VFX_DUR_AURA_PULSE_ORANGE_WHITE"; break;
case 519: sReturn = "VFX_DUR_AURA_PULSE_BROWN_WHITE"; break;
            }
            break;
            case 1:
            switch (nVFX)
            {
case 520: sReturn = "VFX_DUR_AURA_PULSE_PURPLE_WHITE"; break;
case 521: sReturn = "VFX_DUR_AURA_PULSE_GREY_WHITE"; break;
case 522: sReturn = "VFX_DUR_AURA_PULSE_GREY_BLACK"; break;
case 523: sReturn = "VFX_DUR_AURA_PULSE_BLUE_GREEN"; break;
case 524: sReturn = "VFX_DUR_AURA_PULSE_RED_BLUE"; break;
case 525: sReturn = "VFX_DUR_AURA_PULSE_RED_YELLOW"; break;
case 526: sReturn = "VFX_DUR_AURA_PULSE_GREEN_YELLOW"; break;
case 527: sReturn = "VFX_DUR_AURA_PULSE_RED_GREEN"; break;
case 528: sReturn = "VFX_DUR_AURA_PULSE_BLUE_YELLOW"; break;
case 529: sReturn = "VFX_DUR_AURA_PULSE_BLUE_BLACK"; break;
case 530: sReturn = "VFX_DUR_AURA_PULSE_RED_BLACK"; break;
case 531: sReturn = "VFX_DUR_AURA_PULSE_GREEN_BLACK"; break;
case 532: sReturn = "VFX_DUR_AURA_PULSE_YELLOW_BLACK"; break;
case 533: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_BLACK"; break;
case 534: sReturn = "VFX_DUR_AURA_PULSE_CYAN_BLACK"; break;
case 535: sReturn = "VFX_DUR_AURA_PULSE_ORANGE_BLACK"; break;
case 536: sReturn = "VFX_DUR_AURA_PULSE_BROWN_BLACK"; break;
case 537: sReturn = "VFX_DUR_AURA_PULSE_PURPLE_BLACK"; break;
case 538: sReturn = "VFX_DUR_AURA_PULSE_CYAN_GREEN"; break;
case 539: sReturn = "VFX_DUR_AURA_PULSE_CYAN_BLUE"; break;
            }
            break;
            case 2:
            switch (nVFX)
            {
case 540: sReturn = "VFX_DUR_AURA_PULSE_CYAN_RED"; break;
case 541: sReturn = "VFX_DUR_AURA_PULSE_CYAN_YELLOW"; break;
case 542: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_BLUE"; break;
case 543: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_RED"; break;
case 544: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_GREEN"; break;
case 545: sReturn = "VFX_DUR_AURA_PULSE_MAGENTA_YELLOW"; break;
case 546: sReturn = "VFX_DUR_AURA_PULSE_RED_ORANGE"; break;
case 547: sReturn = "VFX_DUR_AURA_PULSE_YELLOW_ORANGE"; break;
case 548: sReturn = "VFX_DUR_AURA_RED"; break;
case 549: sReturn = "VFX_DUR_AURA_GREEN"; break;
case 550: sReturn = "VFX_DUR_AURA_BLUE"; break;
case 551: sReturn = "VFX_DUR_AURA_MAGENTA"; break;
case 552: sReturn = "VFX_DUR_AURA_YELLOW"; break;
case 553: sReturn = "VFX_DUR_AURA_WHITE"; break;
case 554: sReturn = "VFX_DUR_AURA_ORANGE"; break;
case 555: sReturn = "VFX_DUR_AURA_BROWN"; break;
case 556: sReturn = "VFX_DUR_AURA_PURPLE"; break;
case 557: sReturn = "VFX_DUR_AURA_CYAN"; break;
case 558: sReturn = "VFX_DUR_AURA_GREEN_DARK"; break;
case 559: sReturn = "VFX_DUR_AURA_GREEN_LIGHT"; break;
            }
            break;
            case 3:
            switch (nVFX)
            {
case 560: sReturn = "VFX_DUR_AURA_RED_DARK"; break;
case 561: sReturn = "VFX_DUR_AURA_RED_LIGHT"; break;
case 562: sReturn = "VFX_DUR_AURA_BLUE_DARK"; break;
case 563: sReturn = "VFX_DUR_AURA_BLUE_LIGHT"; break;
case 564: sReturn = "VFX_DUR_AURA_YELLOW_DARK"; break;
case 565: sReturn = "VFX_DUR_AURA_YELLOW_LIGHT"; break;
case 566: sReturn = "VFX_DUR_BUBBLES"; break;
case 567: sReturn = "VFX_EYES_GREEN_HUMAN_MALE"; break;
case 568: sReturn = "VFX_EYES_GREEN_HUMAN_FEMALE"; break;
case 569: sReturn = "VFX_EYES_GREEN_DWARF_MALE"; break;
case 570: sReturn = "VFX_EYES_GREEN_DWARF_FEMALE"; break;
case 571: sReturn = "VFX_EYES_GREEN_ELF_MALE"; break;
case 572: sReturn = "VFX_EYES_GREEN_ELF_FEMALE"; break;
case 573: sReturn = "VFX_EYES_GREEN_GNOME_MALE"; break;
case 574: sReturn = "VFX_EYES_GREEN_GNOME_FEMALE"; break;
case 575: sReturn = "VFX_EYES_GREEN_HALFLING_MALE"; break;
case 576: sReturn = "VFX_EYES_GREEN_HALFLING_FEMALE"; break;
case 577: sReturn = "VFX_EYES_GREEN_HALFORC_MALE"; break;
case 578: sReturn = "VFX_EYES_GREEN_HALFORC_FEMALE"; break;
case 579: sReturn = "VFX_EYES_GREEN_TROGLODYTE"; break;
            }
            break;
        }
        break;
    }
    return sReturn;
}

void DoVFX(object oPC, string sText, object oTarget, int nLocation = FALSE) //dm_fx vfx# 2 300 E
{                                                                           //255 2 300 E
    int nPos = FindSubString(sText+" ", " ");//3
    int nDur;
    float fDur;
    int nExtraordinaryEffect = FALSE;
    int nSupernaturalEffect = FALSE;
    string sVFX = GetStringLeft(sText, nPos);
    int nVFX = StringToInt(sVFX);
    string sVFXName = GetVFXName(nVFX);
    sVFXName = GetStringRight(sVFXName, GetStringLength(sVFXName) - 4);//cut off the VFX_
    string sType = GetStringLeft(sVFXName, 4);//read vfx type
    if (GetStringRight(sVFX, 4)==".sef") sType = "SEF";
    sText = GetStringRight(sText, GetStringLength(sText) - (nPos+1));//clear the vfx number and space //2 300 E
    nPos = FindSubString(sText, " ");//find the next break - if not -1, must be for duration type, and time - will be 1
    if (nPos == 1)// duration type //1
    {
        nDur = StringToInt(GetStringLeft(sText, nPos));//get the duration - will be 0, 1, or 2
        sText = GetStringRight(sText, GetStringLength(sText) - 2); //clear type and space  //300 E
        int nPos2 = FindSubString(sText, " ");//3
        if (nPos2 == -1) fDur = StringToFloat(sText);//they didnt specify supernatural or extraordinary
        else
        {
            fDur = StringToFloat(GetStringLeft(sText, nPos2));//300
            sText = GetStringRight(sText, GetStringLength(sText) - (nPos2+1));
            if (sText == "E") nExtraordinaryEffect = TRUE;
            else if (sText == "S") nSupernaturalEffect = TRUE;
            else if (sText == "SE" || sText == "ES")
            {
                nExtraordinaryEffect = TRUE;
                nSupernaturalEffect = TRUE;
            }
            FloatingTextStringOnCreature("<color=indianred>"+"Invalid Command! Specify S, E, or SE for supernatural or extraordinary effect."+"</color>", oPC, FALSE);
        }
    }
    effect eVFX;
    if (sType == "SEF")
    {
        eVFX = EffectNWN2SpecialEffectFile(sVFX);
        if (nExtraordinaryEffect) eVFX = ExtraordinaryEffect(eVFX);
        if (nSupernaturalEffect) eVFX = SupernaturalEffect(eVFX);
        if (nLocation) ApplyEffectAtLocation(nDur, eVFX, GetLocation(oTarget), fDur);
        else ApplyEffectToObject(nDur, eVFX, oTarget, fDur);
    }
    else if (sType == "DUR_")
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nExtraordinaryEffect) eVFX = ExtraordinaryEffect(eVFX);
        if (nSupernaturalEffect) eVFX = SupernaturalEffect(eVFX);
        if (nLocation) ApplyEffectAtLocation(nDur, eVFX, GetLocation(oTarget), fDur);
        else ApplyEffectToObject(nDur, eVFX, oTarget, fDur);
    }
    else if (sType == "BEAM")
    {
        eVFX = EffectBeam(nVFX, oPC, BODY_NODE_CHEST);
        if (nExtraordinaryEffect) eVFX = ExtraordinaryEffect(eVFX);
        if (nSupernaturalEffect) eVFX = SupernaturalEffect(eVFX);
        if (nLocation) ApplyEffectAtLocation(nDur, eVFX, GetLocation(oTarget), fDur);
        else ApplyEffectToObject(nDur, eVFX, oTarget, fDur);
    }
    else if (sType == "EYES")
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nExtraordinaryEffect) eVFX = ExtraordinaryEffect(eVFX);
        if (nSupernaturalEffect) eVFX = SupernaturalEffect(eVFX);
        ApplyEffectToObject(nDur, eVFX, oTarget, fDur);
    }
    else if (sType == "IMP_")//none
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nLocation) ApplyEffectAtLocation(0, eVFX, GetLocation(oTarget));
        else ApplyEffectToObject(0, eVFX, oTarget);
    }
    else if (sType == "COM_")//none
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nLocation) ApplyEffectAtLocation(0, eVFX, GetLocation(oTarget));
        else ApplyEffectToObject(0, eVFX, oTarget);
    }
    else if (sType == "FNF_")//none
    {
        eVFX = EffectVisualEffect(nVFX);
        if (nLocation) ApplyEffectAtLocation(0, eVFX, GetLocation(oTarget));
        else ApplyEffectToObject(0, eVFX, oTarget);
    }
    else FloatingTextStringOnCreature("<color=indianred>"+"Invalid VFX#!"+"</color>", oPC, FALSE);
}

void ListFX(object oPC, string sType) // dur, bea, eye, imp, com, fnf
{
    sType = "VFX_" + GetStringUpperCase(sType);
    int nX;
    string sMessage = "";
    string sName;
    for (nX = 0; nX < 580; nX++)
    {
        sName = GetVFXName(nX);
        if (GetStringLeft(sName, 7) == sType) sMessage += "<color=purple>" + IntToString(nX) + ": " + sName + "</color>" + "\n";
    }
    SendMessageToPC(oPC, sMessage);
}

// Debugging function. Will be commented out for final.
void SCAnimDebug(string sMsg)
{
    //ActionSpeakString("ANIM: " + GetName(OBJECT_SELF) + " " + sMsg);
    //PrintString("ANIM: " + GetName(OBJECT_SELF) + ": " + sMsg);
}



// Returns TRUE if the creature is busy talking or interacting
// with a placeable.
int SCGetIsBusyWithAnimation(object oCreature)
{
    int bReturn = CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_TALKING, oCreature)
        || CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_INTERACTING, oCreature)
        || GetCurrentAction(oCreature) != ACTION_INVALID;

//    if (bReturn == TRUE)     AssignCommand(oCreature, SpeakString("Busy with anim"));
    return bReturn;
}


// * PRIVATE: Test to see if valid to return this voice
int CSLVoiceTest(int nVoice, int bAlways)
{
    if ((d100() > (100 - nVoice) ) || bAlways == TRUE)
        return TRUE;
    return FALSE;
}

void SCVoiceCanDo(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_CANDO, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_CANDO);
}

void SCVoiceCannotDo(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_CANNOTDO, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_CANTDO);
}

void SCVoicePicklock(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_PICKLOCK, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_PICKLOCK);
}

void SCVoiceTaskComplete(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_TASKDONE, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_TASKCOMPLETE);
}

void SCVoiceStop(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_STOP, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_STOP);
}

void SCVoiceCuss(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_CUSS, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_CUSS);
}

void SCVoiceHealMe(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_HEAL, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_HEALME);
}

void SCVoiceHello(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_HELLO, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_HELLO);
}
void SCVoiceGoodbye(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_BYE, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_GOODBYE);
}
void SCVoiceYes(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_YES, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_YES);
}

void SCVoiceNo(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_NO, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_NO);
}


void SCVoiceLaugh(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_LAUGH, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_LAUGH);
}

void SCVoicePoisoned(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_POISON, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_POISONED);
}

void SCVoiceBadIdea(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_BADIDEA, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_BADIDEA);
}

void SCVoiceThreaten(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_THREAT, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_THREATEN);
}

void SCVoiceFlee(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_FLEE, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_FLEE);
}

void SCVoiceNearDeath(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_DEATH, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_NEARDEATH);
}

void SCVoiceLookHere(int bAlways=FALSE)
{
    if (CSLVoiceTest(CSL_VOICE_LOOKHERE, bAlways) == TRUE)
        PlayVoiceChat(VOICE_CHAT_LOOKHERE);
}



// Randomly move away from an object the specified distance.
// This is mainly because ActionMoveAwayFromLocation isn't working.
void SCAnimActionRandomMoveAway(object oSource, float fDistance, object oCharacter = OBJECT_SELF)
{
    location lTarget = CSLGetRandomLocation(GetArea(oCharacter), oSource, fDistance);
    ActionMoveToLocation(lTarget);
}

// Play animation of shaking head "no" to left & right
void SCAnimActionShakeHead()
{
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 3.0);
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 3.0);
}

// Play animation of looking to left and right
void SCAnimActionLookAround()
{
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 0.75);
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 0.75);
}





// Play a random animation.
void SCAnimActionPlayRandomAnimation()
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionPlayRandomAnimation Start", GetFirstPC() ); }
    int nRoll;
    int bInTavern=FALSE;
    int bInHome=FALSE;
    int bNearAltar=FALSE;

    object oWay = GetNearestObjectByTag("NW_TAVERN");
    if (GetIsObjectValid(oWay)) {
        bInTavern = TRUE;
    } else {
        oWay = GetNearestObjectByTag("NW_HOME");
        if (GetIsObjectValid(oWay)) {
            bInHome = TRUE;
        } else {
            oWay = GetNearestObjectByTag("NW_ALTAR");
            if (GetIsObjectValid(oWay) && GetDistanceToObject(oWay) < SC_DISTANCE_SHORT) {
                bNearAltar = TRUE;
            }
        }
    }

    if (bInTavern) {
        nRoll = Random(15);
        switch (nRoll) {
        case 0:
        case 1:
            ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK); break;
        case 2:
            if (CSLGetAnimationCondition(CSL_ANIM_FLAG_CHATTER)) {
                SCVoicePoisoned();
            }
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 3:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 4:
            ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1); break;
        case 5:
            ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2); break;
        case 6:
            ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3); break;
        case 7:
        case 8:
            if (CSLGetAnimationCondition(CSL_ANIM_FLAG_CHATTER)) {
                SCVoiceLaugh();
            }
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 9:
        case 10:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED); break;
        case 11:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD); break;
        case 12:
        case 13:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 14:
            SCAnimActionLookAround(); break;
        }
    } else if (bNearAltar) {
        nRoll = Random(10);
        switch (nRoll) {
        case 0:
            ActionPlayAnimation(ANIMATION_FIREFORGET_READ); break;
        case 1:
        case 2:
        case 3:
            ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH * 2);
            break;
        case 4:
        case 5:
            ActionPlayAnimation(ANIMATION_LOOPING_WORSHIP,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH * 2);
            break;
        case 6:
            ActionPlayAnimation(ANIMATION_LOOPING_LISTEN,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 7:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 8:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 9:
            SCAnimActionLookAround(); break;
        }
    } else if (bInHome) {
        nRoll = Random(6);
        switch (nRoll) {
        case 0:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 1:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 2:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 3:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED); break;
        case 4:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD); break;
        case 5:
            SCAnimActionLookAround(); break;
        }
    } else {
        // generic set, for the street
        nRoll = Random(8);
        switch (nRoll) {
        case 0:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 1:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE2,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 2:
            /* Bk Feb 2003: Looks dumb
            ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;*/
        case 3:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED); break;
        case 4:
            ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD); break;
        case 5:
            ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_TIRED,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 6:
            ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
            break;
        case 7:
            SCAnimActionLookAround(); break;
        }
    }
    return;
}


// Interact with a placeable object.
// This will activate/deactivate the placeable object if a valid
// one is passed in.
// KLUDGE: If a placeable object without an inventory should
//         still be opened/shut instead of de/activated, set
//         its Will Save to 1.
void SCAnimActionPlayRandomInteractAnimation(object oPlaceable, object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionPlayRandomInteractAnimation Start", GetFirstPC() ); }
    int nRoll = Random(5);

    if (nRoll == 0) {
        ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD);
        return;
    }

    // See where the placeable is in relation to us, height-wise
    vector vPos = GetPosition(oPlaceable);
    vector vMyPos = GetPosition(oCharacter);
    float fZDiff = vMyPos.z - vPos.z;
    if ( fZDiff > 0.0 ) {
        // we're above the placeable
        ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW,
                            CSL_ANIM_LOOPING_SPEED,
                            CSL_ANIM_LOOPING_LENGTH);
    } else {
        ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,
                            CSL_ANIM_LOOPING_SPEED,
                            CSL_ANIM_LOOPING_LENGTH);
    }

    // KLUDGE! KLUDGE! KLUDGE!
    // Because of placeables like the trap doors, etc, that should be
    // "opened" rather than "activated", but don't have an inventory,
    // we use this ugly hack: set the "Will" saving throw of a placeable
    // to the value 1 if it should be opened rather than activated.
    if (GetHasInventory(oPlaceable) || GetWillSavingThrow(oPlaceable) == 1) {
        if (GetIsOpen(oPlaceable)) {
            AssignCommand(oPlaceable,
                          DelayCommand(CSL_ANIM_LOOPING_LENGTH,
                                       ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE)));
        } else {
            AssignCommand(oPlaceable,
                          DelayCommand(CSL_ANIM_LOOPING_LENGTH,
                                       ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN)));
        }
    } else {
        int bIsActive = GetLocalInt(oPlaceable, "NW_ANIM_PLACEABLE_ACTIVE");
        if (bIsActive) {
            AssignCommand(oPlaceable,
                          DelayCommand(CSL_ANIM_LOOPING_LENGTH,
                                       ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
            SetLocalInt(oPlaceable, "NW_ANIM_PLACEABLE_ACTIVE", FALSE);
        } else {
            AssignCommand(oPlaceable,
                          DelayCommand(CSL_ANIM_LOOPING_LENGTH,
                                       ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
            SetLocalInt(oPlaceable, "NW_ANIM_PLACEABLE_ACTIVE", TRUE);
        }
    }

    return;
}


// Play a greeting animation and possibly voicechat.
// If a negative hit dice difference (HD caller - HD greeted) is
// passed in, the caller will bow.
void SCAnimActionPlayRandomGreeting(int nHDiff=0)
{
    if (Random(2) == 0 && CSLGetAnimationCondition(CSL_ANIM_FLAG_CHATTER)) {
        SCVoiceHello();
    }

    if (nHDiff < 0 || Random(4) == 0)
        ActionPlayAnimation(ANIMATION_FIREFORGET_BOW);
    else
        ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING);
}

// Play a random farewell animation and possibly voicechat.
// If a negative hit dice difference is passed in, the
// caller will bow.
void SCAnimActionPlayRandomGoodbye(int nHDiff)
{
    if (Random(2) == 0 && CSLGetAnimationCondition(CSL_ANIM_FLAG_CHATTER)) {
        SCVoiceGoodbye();
    }

    if (nHDiff < 0 || Random(4) == 0)
        ActionPlayAnimation(ANIMATION_FIREFORGET_BOW);
    else
        ActionPlayAnimation(ANIMATION_FIREFORGET_GREETING);
}




// Start interacting with a placeable object
void SCAnimActionStartInteracting(object oPlaceable)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionStartInteracting Start", GetFirstPC() ); }
    CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_INTERACTING);

    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE)
        || CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE))
    {
        ActionMoveToObject(oPlaceable, FALSE, SC_DISTANCE_TINY);
    }
    ActionDoCommand(SetFacingPoint(GetPosition(oPlaceable)));
    CSLSetCurrentInteractionTarget(oPlaceable);

    SCAnimActionPlayRandomInteractAnimation(oPlaceable);
}

// Stop interacting with a placeable object
void SCAnimActionStopInteracting( object oCharacter = OBJECT_SELF )
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionStopInteracting Start", GetFirstPC() ); }
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE)) {
        SCAnimActionRandomMoveAway(CSLGetCurrentInteractionTarget( oCharacter ), SC_DISTANCE_LARGE);
    }
    CSLSetCurrentInteractionTarget(OBJECT_INVALID);

    CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_INTERACTING, FALSE);

    SCAnimActionPlayRandomAnimation();
}

// Start talking with a friend
void SCAnimActionStartTalking(object oFriend, int nHDiff=0)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionStartTalking Start", GetFirstPC() ); }
    //SCAnimDebug("started talking to " + GetName(oFriend));
    object oMe = OBJECT_SELF;

    // Say hello and move to each other if we're not immobile
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE)
        || CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE))
    {
        ActionMoveToObject(oFriend, FALSE, SC_DISTANCE_TINY);
        SCAnimActionPlayRandomGreeting(nHDiff);
    }
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE, oFriend)
        || CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE_CLOSE_RANGE, oFriend))
    {
        AssignCommand(oFriend,
                      ActionMoveToObject(oMe, FALSE, SC_DISTANCE_TINY));
        AssignCommand(oFriend, SCAnimActionPlayRandomGreeting(0 - nHDiff));
    }

    CSLSetCurrentFriend(oFriend);
    AssignCommand(oFriend, CSLSetCurrentFriend(oMe));
    ActionDoCommand(SetFacingPoint(GetPosition(oFriend)));
    AssignCommand(oFriend, ActionDoCommand(SetFacingPoint(GetPosition(oMe))));
    CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_TALKING);
    CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_TALKING, TRUE, oFriend);
}

// Stop talking to the given friend
void SCAnimActionStopTalking(object oFriend, int nHDiff=0)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionStopTalking Start", GetFirstPC() ); }
    object oMe = OBJECT_SELF;

    // Say goodbye and move away if we're not immobile
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE)) {
        SCAnimActionPlayRandomGoodbye(nHDiff);
        SCAnimActionRandomMoveAway(oFriend, SC_DISTANCE_LARGE);
    } else {
        SCAnimActionPlayRandomAnimation();
    }

    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_MOBILE, oFriend)) {
        AssignCommand(oFriend, SCAnimActionPlayRandomGoodbye(0 - nHDiff));
        AssignCommand(oFriend,
                      SCAnimActionRandomMoveAway(oMe, SC_DISTANCE_HUGE));
    } else {
        AssignCommand(oFriend, SCAnimActionPlayRandomAnimation());
    }

    CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_TALKING, FALSE);
    CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_TALKING, FALSE, oFriend);

}




// Go through a door and close it behind you,
// then walk a short distance away.
// This assumes the door exists, is unlocked, etc.
void SCAnimActionGoThroughDoor(object oDoor)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionGoThroughDoor Start", GetFirstPC() ); }
    SetLocalInt(oDoor, "BEING_CLOSED", TRUE);
    object oDest = GetTransitionTarget(oDoor);
    ActionMoveToObject(oDest);
    ActionDoCommand(AssignCommand(oDest, ActionCloseDoor(oDest)));
    ActionDoCommand(AssignCommand(oDoor, ActionCloseDoor(oDoor)));
    ActionDoCommand(SetLocalInt(oDoor, "BEING_CLOSED", FALSE));
    DelayCommand(10.0, SetLocalInt(oDoor, "BEING_CLOSED", FALSE));
    SCAnimActionRandomMoveAway(oDest, SC_DISTANCE_MEDIUM);
}


// If there's an open door nearby, possibly go close it,
// then come back to our current spot.
int SCAnimActionCloseRandomDoor( object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 6) { CSLDebug(  "SCAnimActionCloseRandomDoor Start", GetFirstPC() ); }
    
    if (Random(4) != 0) return FALSE;

    int nNth = 1;
    
    location locCurrent = GetLocation(oCharacter);
    object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
    while (GetIsObjectValid(oDoor) && nNth < 30 )
    {
        //DEBUGGING// igDebugLoopCounter += 1;
        // make sure everyone doesn't run to close the same door
        if (GetIsOpen(oDoor) && !GetLocalInt(oDoor, "BEING_CLOSED"))
        {

            SetLocalInt(oDoor, "BEING_CLOSED", TRUE);
            ActionCloseDoor(oDoor);
            ActionDoCommand(SetLocalInt(oDoor, "BEING_CLOSED", FALSE));
            ActionMoveToLocation(locCurrent);
			//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCAnimActionCloseRandomDoor End", GetFirstPC() ); }
            return TRUE;
        }
        
        nNth++;
        oDoor = GetNearestObject(OBJECT_TYPE_DOOR, oCharacter, nNth);
    }
	//DEBUGGING// if (DEBUGGING >= 11) { CSLDebug(  "SCAnimActionCloseRandomDoor End", GetFirstPC() ); }
    return FALSE;
}

// Sit in a random nearby chair if available.
// Looks for items with tag: Chair
int SCAnimActionSitInChair(float fMaxDistance)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionSitInChair Start", GetFirstPC() ); }
    
    object oChair = CSLGetRandomObjectByTag("Chair", fMaxDistance);
    if (GetIsObjectValid(oChair) && !GetIsObjectValid(GetSittingCreature(oChair))) {
        ActionSit(oChair);
        CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_INTERACTING);
        return TRUE;
    }
    return FALSE;
}

// Get up from a chair if we're sitting
int SCAnimActionGetUpFromChair()
{
	//DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionGetUpFromChair Start", GetFirstPC() ); }
	
    if (GetCurrentAction() == ACTION_SIT)
    {
        ClearAllActions();
        CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_INTERACTING, FALSE);
        SCAnimActionRandomMoveAway(GetNearestObject(OBJECT_TYPE_PLACEABLE), SC_DISTANCE_SHORT);
        return TRUE;
    }
    return FALSE;
}

// Go through a nearby door if appropriate.
// This will be done if the door is unlocked and
// the area the door leads to contains a waypoint
// with one of these tags:
//             NW_TAVERN, NW_SHOP
int SCAnimActionGoInside( object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionGoInside Start", GetFirstPC() ); }
    
    // Don't go inside a second area, since we'll never get
    // back to our original one if we do that.
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_INSIDE)) {

        return FALSE;
    }

    object oDoor = CSLGetRandomObjectByType(OBJECT_TYPE_DOOR, 1000.0);
    if (!GetIsObjectValid(oDoor) || GetLocked(oDoor)) {

        return FALSE;
    }

    object oDest = GetTransitionTarget(oDoor);

    object oWay = GetNearestObjectByTag("NW_TAVERN", oDest);
    if (!GetIsObjectValid(oWay))
        oWay = GetNearestObjectByTag("NW_SHOP", oDest);
    if (GetIsObjectValid(oWay)) {

        SCAnimActionGoThroughDoor(oDoor);
        CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_INSIDE);
        SetLocalObject(oCharacter, "NW_ANIM_DOOR", oDest);
        return TRUE;
    }

    return FALSE;
}

// Leave area if appropriate.
// This only works for NPCs that entered an area that
// has a waypoint with one of these tags:
//             NW_TAVERN, NW_SHOP
// If the NPC entered through a door, they will exit through
// that door.
int SCAnimActionGoOutside( object oCharacter = OBJECT_SELF)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionGoOutside Start", GetFirstPC() ); }
    
    if (CSLGetAnimationCondition(CSL_ANIM_FLAG_IS_INSIDE)) {
        object oDoor = GetLocalObject(oCharacter, "NW_ANIM_DOOR");
        if (GetIsObjectValid(oDoor)) {
            DeleteLocalObject(oCharacter, "NW_ANIM_DOOR");
            SCAnimActionGoThroughDoor(oDoor);
            CSLSetAnimationCondition(CSL_ANIM_FLAG_IS_INSIDE, FALSE);
            return TRUE;
        }
    }
    return FALSE;
}

// Go to a nearby waypoint or placeable marked with the
// tag "NW_STOP".
int SCAnimActionGoToStop(float fMaxDistance)
{
    //DEBUGGING// if (DEBUGGING >= 10) { CSLDebug(  "SCAnimActionGoToStop Start", GetFirstPC() ); }
    
    object oStop = CSLGetRandomStop(fMaxDistance);
    if (GetIsObjectValid(oStop)) {
        ClearAllActions();
        ActionMoveToObject(oStop, FALSE, SC_DISTANCE_SHORT);
        return TRUE;
    }
    return FALSE;
}


// Play a random talk gesture animation.
// If a hit dice difference (should be the hit dice of the caller
// minus the hit dice of the person being talked to) is passed in,
// the caller will play slightly different animations if they are
// weaker.
void SCAnimActionPlayRandomTalkAnimation(int nHDiff, object oCharacter = OBJECT_SELF )
{
	// 0-2 subtracted from random roll, angry stuff at end.
	int iSerenity = GetLocalInt(oCharacter, "Serenity");
	
    int nRoll = Random(9 - iSerenity);
	//SpeakString("Talk " + IntToString(nRoll));
    switch (nRoll) {
    case 0:
        if (CSLGetAnimationCondition(CSL_ANIM_FLAG_CHATTER)) {
            SCVoiceYes();
        }
        // deliberate fall-through!
    case 1:
        ActionPlayAnimation(ANIMATION_LOOPING_LISTEN,
                            CSL_ANIM_LOOPING_SPEED,
                            CSL_ANIM_LOOPING_LENGTH);
        break;
    case 2:
    case 3:
        ActionPlayAnimation(ANIMATION_LOOPING_TALK_NORMAL,
                            CSL_ANIM_LOOPING_SPEED,
                            CSL_ANIM_LOOPING_LENGTH);
        break;
    case 4:
        if (nHDiff < 0)
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_PLEADING,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
        else {
            if (Random(2) == 0 && CSLGetAnimationCondition(CSL_ANIM_FLAG_CHATTER)) {
                SCVoiceLaugh();
            }
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
        }
        break;
    case 5:
        if (CSLGetAnimationCondition(CSL_ANIM_FLAG_CHATTER)) {
            SCVoiceNo();
        }
        // deliberate fall-through!
    case 6:
        SCAnimActionShakeHead();
        break;
    case 7:
        // BK Feb 2003 Salutes look stupid
      //  if (nHDiff < 0)
      //      ActionPlayAnimation(ANIMATION_FIREFORGET_SALUTE, 0.75);
      //  else
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
        break;
    case 8:
        if (nHDiff > 0)
            ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT);
        else {
            if (Random(2) == 0 && CSLGetAnimationCondition(CSL_ANIM_FLAG_CHATTER)) {
                SCVoiceLaugh();
            }
            ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,
                                CSL_ANIM_LOOPING_SPEED,
                                CSL_ANIM_LOOPING_LENGTH);
        }
        break;
    }

    return;
}


// Play a random animation that all creatures should have.
void SCAnimActionPlayRandomBasicAnimation()
{
    int nRoll = Random(2);
    switch (nRoll) {
    case 0:
    // BK Feb 2003: This always looks dumb
    //    ActionPlayAnimation(ANIMATION_LOOPING_GET_MID,
    //                        CSL_ANIM_LOOPING_SPEED,
    //                        CSL_ANIM_LOOPING_LENGTH);
        break;
    case 1:
        ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT);
        break;
    }
}

void SaveMusicTrack(object oArea)
{
	SetLocalInt(oArea,"00_sDayMusic", MusicBackgroundGetDayTrack(oArea));
	SetLocalInt(oArea,"00_sNightMusic", MusicBackgroundGetNightTrack(oArea));
}

void SaveBattleMusicTrack(object oArea)
{
	SetLocalInt(oArea,"00_sBattleMusic", MusicBackgroundGetBattleTrack(oArea));
}

void RestoreMusicTrack(object oArea)
{
	MusicBackgroundChangeDay(oArea, GetLocalInt(oArea,"00_sDayMusic"));
	MusicBackgroundChangeNight(oArea, GetLocalInt(oArea,"00_sNightMusic"));
}

void ChangeMusicTrack(object oArea, int nTrack)
{
	MusicBackgroundChangeDay(oArea, nTrack);
	MusicBackgroundChangeNight(oArea, nTrack);
}

void RestoreBattleMusicTrack(object oArea)
{
	MusicBattleChange(oArea, GetLocalInt(oArea,"00_sBattleMusic"));
}

void DMFI_InitializeAreaMusic(object oPC)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_InitializeAreaMusic Start", oPC ); }
	//Purpose: Stores the default local music as default music - only runs once.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 6/6/6
	int nMusic;
	object oArea = GetArea(oPC);

	if (GetLocalInt(oArea, DMFI_MUSIC_INITIALIZED)!=1)
	{
		SetLocalInt(oArea, DMFI_MUSIC_INITIALIZED, 1);
		nMusic = MusicBackgroundGetBattleTrack(oArea);
		SetLocalInt(oArea, DMFI_MUSIC_BATTLE, nMusic);
		nMusic = MusicBackgroundGetDayTrack(oArea);
		SetLocalInt(oArea, DMFI_MUSIC_DAY, nMusic);
		nMusic = MusicBackgroundGetNightTrack(oArea);
		SetLocalInt(oArea, DMFI_MUSIC_NIGHT, nMusic);
	}
	return;
}

string DMFI_GetSoundString(int nValue, string sParam)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_GetSoundString Start", GetFirstPC() ); }
	
	if (sParam=="city")
	{
		switch(nValue)
		{
			case 0: { SetLocalString(GetModule(), DMFI_TEMP, "Bell church"); return  "as_bell_church01"; break; }
			case 1: { SetLocalString(GetModule(), DMFI_TEMP, "Bell tower"); return  "as_cv_belltower1"; break; }
				case 2: { SetLocalString(GetModule(), DMFI_TEMP, "Boiler"); return  "as_cv_boilergrn1"; break; }
			case 3: { SetLocalString(GetModule(), DMFI_TEMP, "Boom dist"); return  "as_cv_boomdist1"; break; }
			case 4: { SetLocalString(GetModule(), DMFI_TEMP, "Clay break"); return  "as_cv_claybreak1"; break; }
			case 5: { SetLocalString(GetModule(), DMFI_TEMP, "Chain rattle"); return  "as_hr_x2chnratl1"; break; }
			case 6: { SetLocalString(GetModule(), DMFI_TEMP, "Crank"); return  "as_cv_crank1"; break; }
			case 7: { SetLocalString(GetModule(), DMFI_TEMP, "Campfire"); return  "al_cv_firecamp1"; break; }
			case 8: { SetLocalString(GetModule(), DMFI_TEMP, "Fire large"); return  "al_na_firelarge2"; break; }
			case 9: { SetLocalString(GetModule(), DMFI_TEMP, "Fire smolder"); return  "al_cv_firesmldr1"; break; }
			case 10: { SetLocalString(GetModule(), DMFI_TEMP, "Glass break"); return  "as_cv_glasbreak1"; break; }
			case 11: { SetLocalString(GetModule(), DMFI_TEMP, "Low Rumble"); return  "as_na_x2lowrum2"; break; }
			case 12: { SetLocalString(GetModule(), DMFI_TEMP, "Metal creak"); return  "amb_metal_creaking_1"; break; }
			case 13: { SetLocalString(GetModule(), DMFI_TEMP, "Millwheel"); return  "al_cv_millwheel1"; break; }
			case 14: { SetLocalString(GetModule(), DMFI_TEMP, "Mine pick"); return  "as_cv_minepick1"; break; }
			case 15: { SetLocalString(GetModule(), DMFI_TEMP, "Mine shovel"); return  "as_cv_mineshovl1"; break; }
			case 16: { SetLocalString(GetModule(), DMFI_TEMP, "x2dr noise"); return  "as_hr_x2drnoise4"; break; }
			case 17: { SetLocalString(GetModule(), DMFI_TEMP, "x2dr2 noise"); return  "as_hr_x2drnoise"; break; }
			case 18: { SetLocalString(GetModule(), DMFI_TEMP, "Ship sink"); return  "cs_shipsink_long"; break; }
			case 19: { SetLocalString(GetModule(), DMFI_TEMP, "Smith hammer"); return  "as_cv_smithhamr1"; break; }
			case 20: { SetLocalString(GetModule(), DMFI_TEMP, "Wood break"); return  "as_cv_woodbreak1"; break; }
		
			return "";
		}
	}
	else if (sParam=="nature")
	{
		switch(nValue)
		{
			case 0: { SetLocalString(GetModule(), DMFI_TEMP, "Boulder crumb"); return  "as_cv_bldgcrumb1"; break; }
			case 1: { SetLocalString(GetModule(), DMFI_TEMP, "Cave rumb1"); return  "amb_caverumb_01"; break; }
			case 2: { SetLocalString(GetModule(), DMFI_TEMP, "Cave rumb2"); return  "amb_caverumb_02"; break; }
			case 3: { SetLocalString(GetModule(), DMFI_TEMP, "Cave rumb3"); return  "amb_cavewind_03"; break; }
			case 4: { SetLocalString(GetModule(), DMFI_TEMP, "Cave rumb4"); return  "amb_cavewind_04"; break; }
			case 5: { SetLocalString(GetModule(), DMFI_TEMP, "Gust cavern"); return  "al_wt_gustcavrn1"; break; }
			case 6: { SetLocalString(GetModule(), DMFI_TEMP, "Gust chasm"); return  "al_wt_gustchasm1"; break; }
			case 7: { SetLocalString(GetModule(), DMFI_TEMP, "Gust grass"); return  "al_wt_gustgrass1"; break; }
			case 8: { SetLocalString(GetModule(), DMFI_TEMP, "Gust draft"); return  "as_wt_gustdraft1"; break; }
			case 9: { SetLocalString(GetModule(), DMFI_TEMP, "Gust forest"); return  "as_wt_gusforst1"; break; }
			case 10: { SetLocalString(GetModule(), DMFI_TEMP, "Gust soft"); return  "as_wt_gustsoft1"; break; }
			case 11: { SetLocalString(GetModule(), DMFI_TEMP, "Gust strong"); return  "as_wt_guststrng1"; break; }
			case 12: { SetLocalString(GetModule(), DMFI_TEMP, "Lava burst"); return  "as_na_lavaburst1"; break; }
			case 13: { SetLocalString(GetModule(), DMFI_TEMP, "Lava fire"); return  "al_na_lavafire1"; break; }
			case 14: { SetLocalString(GetModule(), DMFI_TEMP, "Lava gyser"); return  "al_na_lavagyser1"; break; }
			case 15: { SetLocalString(GetModule(), DMFI_TEMP, "Lava lake"); return  "al_na_lavalake1"; break; }
			case 16: { SetLocalString(GetModule(), DMFI_TEMP, "Ocean"); return  "amb_ocean_lp1"; break; }
			case 17: { SetLocalString(GetModule(), DMFI_TEMP, "Rain light"); return  "al_wt_rainlight1"; break; }
			case 18: { SetLocalString(GetModule(), DMFI_TEMP, "Rain hard"); return  "al_wt_rainhard1"; break; }
			case 19: { SetLocalString(GetModule(), DMFI_TEMP, "Rock fall"); return  "as_na_rockfallg1"; break; }
			case 20: { SetLocalString(GetModule(), DMFI_TEMP, "Rock cave"); return  "as_na_rockcavsm1"; break; }
			case 21: { SetLocalString(GetModule(), DMFI_TEMP, "Sludge lake"); return  "al_na_sludglake1"; break; }
			case 22: { SetLocalString(GetModule(), DMFI_TEMP, "Steam small"); return  "al_na_steamsm1"; break; }
			case 23: { SetLocalString(GetModule(), DMFI_TEMP, "Steam long"); return  "as_na_steamlong1"; break; }
			case 24: { SetLocalString(GetModule(), DMFI_TEMP, "Steam large"); return  "al_na_steamlg1"; break; }
			case 25: { SetLocalString(GetModule(), DMFI_TEMP, "Stream"); return  "al_na_stream4"; break; }
			case 26: { SetLocalString(GetModule(), DMFI_TEMP, "Cave stream"); return  "al_na_cvstream2"; break; }
			case 27: { SetLocalString(GetModule(), DMFI_TEMP, "Cave stream"); return  "al_na_cvstream1"; break; }
			case 28: { SetLocalString(GetModule(), DMFI_TEMP, "Surf1"); return  "as_na_surf1"; break; }
			case 29: { SetLocalString(GetModule(), DMFI_TEMP, "Surf2"); return  "as_na_surf2"; break; }
			case 30: { SetLocalString(GetModule(), DMFI_TEMP, "Thunder close"); return  "as_wt_thunderds1"; break; }
			case 31: { SetLocalString(GetModule(), DMFI_TEMP, "Thunder"); return  "as_wt_thundercl1"; break; }
			case 32: { SetLocalString(GetModule(), DMFI_TEMP, "Waterfall"); return  "al_na_waterfall2"; break; }
			case 33: { SetLocalString(GetModule(), DMFI_TEMP, "Water laps"); return  "as_na_waterlap3"; break; }
			case 34: { SetLocalString(GetModule(), DMFI_TEMP, "Water flow"); return  "al_na_wtrflvoid1"; break; }
			case 35: { SetLocalString(GetModule(), DMFI_TEMP, "Water pipe"); return  "al_na_waterpipe1"; break; }
			case 36: { SetLocalString(GetModule(), DMFI_TEMP, "Water tunnel"); return  "al_na_watertunl1"; break; }
			case 37: { SetLocalString(GetModule(), DMFI_TEMP, "Wind leaves"); return  "al_wind_leaves"; break; }
		
			return "";
		}
	}
	else if (sParam=="people")
	{
		switch(nValue)
		{
			case 0: { SetLocalString(GetModule(), DMFI_TEMP, "Ailing man"); return  "as_pl_ailingm1"; break; }
			case 1: { SetLocalString(GetModule(), DMFI_TEMP, "Ailing woman"); return  "as_pl_ailingf1"; break; }
			case 2: { SetLocalString(GetModule(), DMFI_TEMP, "Orc attack"); return  "c_orc_atk1"; break; }
			case 3: { SetLocalString(GetModule(), DMFI_TEMP, "Orc battle"); return  "c_orc_bat1"; break; }
			case 4: { SetLocalString(GetModule(), DMFI_TEMP, "Battle group"); return  "as_pl_battlegrp1"; break; }
			case 5: { SetLocalString(GetModule(), DMFI_TEMP, "Chanting men"); return  "as_pl_chantingm1"; break; }
			case 6: { SetLocalString(GetModule(), DMFI_TEMP, "Common group"); return  "as_pl_comyaygrp1"; break; }
			case 7: { SetLocalString(GetModule(), DMFI_TEMP, "Crypt voice"); return  "as_pl_crptvoice1"; break; }
			case 8: { SetLocalString(GetModule(), DMFI_TEMP, "KOS Death"); return  "cs_kos_death"; break; }
			case 9: { SetLocalString(GetModule(), DMFI_TEMP, "Despair Men"); return  "as_pl_despairm1"; break; }
			case 10: { SetLocalString(GetModule(), DMFI_TEMP, "Dragon roar"); return  "as_an_dragonror1"; break; }
			case 11: { SetLocalString(GetModule(), DMFI_TEMP, "Evil chant"); return  "as_pl_evilchantm"; break; }
			case 12: { SetLocalString(GetModule(), DMFI_TEMP, "Flute"); return  "as_cv_flute1"; break; }
			case 13: { SetLocalString(GetModule(), DMFI_TEMP, "Ghost"); return  "as_hr_x2ghost4"; break; }
			case 14: { SetLocalString(GetModule(), DMFI_TEMP, "Ghost2"); return  "as_hr_x2ghost2"; break; }
			case 15: { SetLocalString(GetModule(), DMFI_TEMP, "Lizardhiss"); return  "as_an_lizrdhiss1"; break; }
			case 16: { SetLocalString(GetModule(), DMFI_TEMP, "Lute"); return  "as_cv_lute1"; break; }
			case 17: { SetLocalString(GetModule(), DMFI_TEMP, "Market"); return  "as_pl_marketgrp1"; break; }
			case 18: { SetLocalString(GetModule(), DMFI_TEMP, "Mephgrunt"); return  "as_an_mephgrunt1"; break; }
			case 19: { SetLocalString(GetModule(), DMFI_TEMP, "Office"); return  "as_pl_officerm1"; break; }
			case 20: { SetLocalString(GetModule(), DMFI_TEMP, "Ogre grunt"); return  "as_an_ogregrunt1"; break; }
			case 21: { SetLocalString(GetModule(), DMFI_TEMP, "Orc grunt"); return  "as_an_orcgrunt1"; break; }
			case 22: { SetLocalString(GetModule(), DMFI_TEMP, "Shop fruit"); return  "as_cv_shopfruit1"; break; }
			case 23: { SetLocalString(GetModule(), DMFI_TEMP, "Tavern group"); return  "as_pl_taverngrp1"; break; }
			case 24: { SetLocalString(GetModule(), DMFI_TEMP, "Town cryer"); return  "as_pl_towncrym1"; break; }
			case 25: { SetLocalString(GetModule(), DMFI_TEMP, "Wilhelm scream"); return  "wilhelm_scream"; break; }
			case 26: { SetLocalString(GetModule(), DMFI_TEMP, "Yell city f"); return  "as_pl_yelcitycf1"; break; }
			case 27: { SetLocalString(GetModule(), DMFI_TEMP, "Yell city m"); return  "as_pl_yellcitym1"; break; }
			case 28: { SetLocalString(GetModule(), DMFI_TEMP, "Zombie"); return  "as_pl_zombief1"; break; }
		
			return "";
		}
	}
	else if (sParam=="magical")
	{
		switch(nValue)
		{
			case 0: { SetLocalString(GetModule(), DMFI_TEMP, "Ball Magic"); return  "al_mg_ballmagic1"; break; }
			case 1: { SetLocalString(GetModule(), DMFI_TEMP, "Cauldron"); return  "al_mg_cauldron1"; break; }
			case 2: { SetLocalString(GetModule(), DMFI_TEMP, "Crystal Evil"); return  "al_mg_crystalev1"; break; }
			case 3: { SetLocalString(GetModule(), DMFI_TEMP, "Crystal Good"); return  "al_mg_crystalgd1"; break; }
			case 4: { SetLocalString(GetModule(), DMFI_TEMP, "Crystal Ice"); return  "al_mg_crystalic1"; break; }
			case 5: { SetLocalString(GetModule(), DMFI_TEMP, "Crystal 1"); return  "al_mg_crystallv1"; break; }
			case 6: { SetLocalString(GetModule(), DMFI_TEMP, "Crystal 2"); return  "al_mg_crystalnt1"; break; }
			case 7: { SetLocalString(GetModule(), DMFI_TEMP, "Cave eerie1"); return  "al_eerie_caveloop1"; break; }
			case 8: { SetLocalString(GetModule(), DMFI_TEMP, "Cave eerie2"); return  "al_eerie_caveloop2"; break; }
			case 9: { SetLocalString(GetModule(), DMFI_TEMP, "Cave eerie3"); return  "al_eerie_caveloop4"; break; }
			case 10: { SetLocalString(GetModule(), DMFI_TEMP, "Drone loop"); return  "al_eerie_droneloop1"; break; }
			case 11: { SetLocalString(GetModule(), DMFI_TEMP, "Enter evil"); return  "al_mg_entrevil1"; break; }
			case 12: { SetLocalString(GetModule(), DMFI_TEMP, "Enter emst"); return  "al_mg_entrmyst1"; break; }
			case 13: { SetLocalString(GetModule(), DMFI_TEMP, "Enter scary"); return  "al_mg_entrscry1"; break; }
			case 14: { SetLocalString(GetModule(), DMFI_TEMP, "Frost Magic"); return  "as_mg_frstmagic1"; break; }
			case 15: { SetLocalString(GetModule(), DMFI_TEMP, "Pillar light"); return  "al_mg_pillrlght1"; break; }
			case 16: { SetLocalString(GetModule(), DMFI_TEMP, "Portal 1"); return  "al_mg_portal3"; break; }
			case 17: { SetLocalString(GetModule(), DMFI_TEMP, "Portal 2"); return  "al_mg_portal4"; break; }
			case 18: { SetLocalString(GetModule(), DMFI_TEMP, "Portal 3"); return  "al_mg_portal2"; break; }
			case 19: { SetLocalString(GetModule(), DMFI_TEMP, "Teleport in"); return  "as_mg_telepin1"; break; }
			case 20: { SetLocalString(GetModule(), DMFI_TEMP, "Motb Barrow"); return  "al_mg_spirtbarrow_01"; break; }
			case 21: { SetLocalString(GetModule(), DMFI_TEMP, "Motb GoDamb"); return  "al_en_deathgodamb"; break; }
			case 22: { SetLocalString(GetModule(), DMFI_TEMP, "Motb RoomTone"); return  "al_en_roomtone"; break; }
			return "";
		}
	}
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_GetSoundString End", GetFirstPC() ); }

	return "";
}

void DMFI_CreateSound(object oTool, object oPC, object oTarget, object oSpeaker, location lTargetLoc,  string sCommand, string sParam1)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_CreateSound Start", oPC ); }
	//Purpose: Creates a localized sound effect
	// Original scripter: Demetrious
	// Last Modified by:  Demetrious 10/9/6
	string sSound;
	object oSound;
	int nDelay;

	sSound = DMFI_GetSoundString(StringToInt(sParam1), sCommand);
	//SendMessageToPC(oPC, "DEBUGGING sSound: " + sSound);
	nDelay = StringToInt(GetLocalString(oTool, DMFI_SOUND_DELAY));
	
	//SendMessageToPC(oPC, "DEBUGGING sLoc: " + sLoc);
	
	if (oTarget==OBJECT_INVALID)
	{
		oSound = CreateObject(OBJECT_TYPE_PLACEABLE, DMFI_STORAGE_RESREF, GetLocation(oSpeaker));
	}
	else
	{
		oSound = CreateObject(OBJECT_TYPE_PLACEABLE, DMFI_STORAGE_RESREF, GetLocation(oTarget));
	}
	// verify oSound is valid
	if (!GetIsObjectValid(oSound))
	{
		SendMessageToPC(oPC, "Target Not Valid.");
		return;
	}
	
	if (GetStringLeft(sSound, 3)!="al_")
	{	
		DelayCommand(1.0 + IntToFloat(nDelay), AssignCommand(oSound, PlaySound(sSound)));		
		DelayCommand(5.0, SetPlotFlag(oSound, FALSE));
		DelayCommand(6.0, DestroyObject(oSound));
	}	
	else
	{	// Looping sounds - we run for about 20 seconds - not perfect because times are not consistent.
		DelayCommand(1.0+IntToFloat(nDelay), AssignCommand(oSound, PlaySound(sSound)));
		DelayCommand(6.0+IntToFloat(nDelay), AssignCommand(oSound, PlaySound(sSound)));
		DelayCommand(11.0+IntToFloat(nDelay), AssignCommand(oSound, PlaySound(sSound)));
		DelayCommand(16.0 + IntToFloat(nDelay), DestroyObject(oSound));
		DelayCommand(20.0, SetPlotFlag(oSound, FALSE));
		DelayCommand(21.0, DestroyObject(oSound));
	}	
	SendMessageToPC(oPC, "DMFI Sound executed: " + sSound);
}

void DMFI_CreateVFX(object oTool, object oSpeaker, string sText, string sParam)
{
	// if (DEBUGGING >= 8) { CSLDebug(  "DMFI_CreateVFX Start", GetFirstPC() ); }
	//Purpose: Create a Visual effect according to preferences.  sText is the
	//Label for the VFX and sParam is the row of the 2da file.
	//Original Scripter: Demetrious
	//Last Modified By: Demetrious 1/8/7
	object oTarget;
	effect eVFX, eEffect;
	int nAppear;
	float fDur;
	object oEffect;
	string sDur;
	location lTargetLoc;
	
	sDur = GetLocalString(oTool, DMFI_VFX_DURATION);
	fDur = StringToFloat(sDur);
	
	if (fDur<5.0) fDur=5.0;
	
	oTarget = GetLocalObject(oTool, DMFI_TARGET);
	
	if (FindSubString(sText, "_FNF_")!=-1)
	{  //Simply apply these to a location
		eVFX = EffectVisualEffect(StringToInt(sParam));
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVFX, GetLocation(oTarget));
		return;
	}

	if (FindSubString(sText, "_BEAM_")!=-1)
	{
		eVFX = EffectBeam(StringToInt(sParam), oTarget, BODY_NODE_CHEST);
	}
	else
	{
		eVFX = EffectVisualEffect(StringToInt(sParam));
	}
	if (FindSubString(sText, "_BEAM_")!=-1)
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oSpeaker, fDur);
	}
	else
	{
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, fDur);
	}
}

// Returns the string of the name of a creature that produces a sound effect.  This is a workaround for PlaySound
// since that function will not work while anything is on the action queue.  The creatures are invisible, when 
// created, play a sound associated with their name, and then destroy themselves without anyone ever being the 
// wiser.  Just like good little ninjas.
// -oWeapon: Weapon in right or left hand.
// -oTarget: What the target wears when it is hit determines the type of sound that returns.
// -nHit: Either a miss, hit, or critical hit. 0, 1, or 2.
string SoundNinja(object oWeapon, object oTarget, int nHit)
{
	string sNinja; // Value to return.
	int nWeapon = GetBaseItemType(oWeapon);
	int nSoundCategory = GetWeaponSoundType(oWeapon);
	int nWooden = GetBluntWeaponSound(oWeapon);
	int nFoe = GetObjectType(oTarget);
	int nFoeSkin = GetSubRace(oTarget);
	int nFoeArmor = GetArmorRank(GetItemInSlot(INVENTORY_SLOT_CHEST, oTarget));

	if (nHit == 2)
	{
		sNinja = "c_soundfx_crit";
	}
	else if (nHit == 0)
	{
		if (nWeapon == BASE_ITEM_FLAIL)
		{
			sNinja = "c_soundfx_missflail";
		}
		else if (nWeapon == BASE_ITEM_HEAVYFLAIL)
		{
			sNinja = "c_soundfx_missflail";
		}
		else if (nWeapon == BASE_ITEM_LIGHTFLAIL)
		{
			sNinja = "c_soundfx_missflail";
		}
		else if (nWeapon == BASE_ITEM_WHIP)
		{
			sNinja = "c_soundfx_misswhip";
		}
		else if (nSoundCategory == SOUND_TYPE_BLADE)
		{
			sNinja = "c_soundfx_missbld";
		}
		else if (nSoundCategory == SOUND_TYPE_BLUNT)
		{	
			if (nWooden == SOUND_TYPE_WOOD)
			{
				sNinja = "c_soundfx_misswood";
			}
			else sNinja = "c_soundfx_missblnt";
		}
		else if (nSoundCategory == SOUND_TYPE_RANGED)
		{
			if (nWeapon == BASE_ITEM_HEAVYCROSSBOW)
			{
				sNinja = "c_soundfx_missxbow";
			}
			else if (nWeapon == BASE_ITEM_LIGHTCROSSBOW)
			{
				sNinja = "c_soundfx_missxbow";
			}
			else sNinja = "c_soundfx_missbow";
		}
		else if (nSoundCategory == SOUND_TYPE_DAGGER)
		{
			sNinja = "c_soundfx_missdgr";
		}
		else sNinja = "c_soundfx_missua";
	}
	else if (nHit == 1)
	{	
		if (nFoe != OBJECT_TYPE_CREATURE)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2st";	break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2st";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2st";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2st";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2st";
				}
				else sNinja = "c_soundfx_m2st";
			}
		}
		else if (nFoeSkin == RACIAL_SUBTYPE_OOZE || nFoeSkin == RACIAL_SUBTYPE_INCORPOREAL)
		{
			sNinja = "c_soundfx_eth";
		}
		else if (nFoeSkin == RACIAL_SUBTYPE_DRAGON || nFoeSkin == RACIAL_SUBTYPE_HUMANOID_REPTILIAN || nFoeSkin == RACIAL_SUBTYPE_YUANTI)
		{
			sNinja = "c_soundfx_f2sc";
		}
		else if (nFoeSkin == RACIAL_SUBTYPE_PLANT)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2w";		break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2w";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2w";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2w";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2w";
				}
				else sNinja = "c_soundfx_m2w";
			}
		}
		else if (nFoeSkin == RACIAL_SUBTYPE_CONSTRUCT)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2st";	break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2st";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2st";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2st";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2st";
				}
				else sNinja = "c_soundfx_m2st";
			}
		}
		else if (nFoeArmor == ARMOR_RANK_LIGHT)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2l";		break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2l";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2l";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2l";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2l";
				}
				else sNinja = "c_soundfx_m2l";
			}
		}
		else if (nFoeArmor == ARMOR_RANK_MEDIUM)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2ch";	break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2ch";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2ch";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2ch";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2ch";
				}
				else sNinja = "c_soundfx_m2ch";
			}
		}
		else if (nFoeArmor == ARMOR_RANK_HEAVY)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2p";		break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2p";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2p";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2p";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2p";
				}
				else sNinja = "c_soundfx_m2p";
			}
		}
		else if (nFoeArmor == ARMOR_RANK_NONE)
		{
			if (nSoundCategory != SOUND_TYPE_BLUNT)
			{
				switch (nSoundCategory)
				{
					case SOUND_TYPE_BLADE:	sNinja = "c_soundfx_bld2l";		break;
					case SOUND_TYPE_DAGGER:	sNinja = "c_soundfx_d2l";		break;
					case SOUND_TYPE_RANGED: sNinja = "c_soundfx_arrow";		break;
					case SOUND_TYPE_WHIP:	sNinja = "c_soundfx_wp2l";		break;
					case SOUND_TYPE_INVALID:sNinja = "c_soundfx_f2l";		break;
				}
			}
			else if (nSoundCategory == SOUND_TYPE_BLUNT)
			{
				if (nWooden == SOUND_TYPE_WOOD)
				{
					sNinja = "c_soundfx_w2l";
				}
				else sNinja = "c_soundfx_m2l";
			}
		}
	}

	return sNinja;
}