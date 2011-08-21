//::///////////////////////////////////////////////
//:: Chromatic Orb
//:: sg_s0_chromeorb.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation
     Level(s): Brd 2, Sor/Wiz 1
     Components: V, S
     Casting Time: 1 action
     Range: Close (25 ft + 5 ft/2 levels)
     Target: 1 Creature
     Duration: Special
     Saving Throw: Will negates
     Spell Resistance: Yes

     This spell causes a 4-in. diameter sphere to appear in your hand.
     Within the limits described below, the sphere can appear in a
     variety of different colors;  each color indicates a different
     special power.  You can hurl the sphere at an opponent, providing
     there are no barriers in the way.  If the orb misses the target,
     it dissipates without effect.  If the target creatures makes a
     successful Will saving throw, the chromatic orb is also ineffective.
     Otherwise, the color of the orb determines the amount of damage
     inflicted and its special power, as summarized below;  details about
     the special powers are listed below.  You can create a single orb
     listed for your level or lower;  for instance, a 3rd level wizard
     can create an orange, red or white orb.

     Special Powers:
     Light - Light from the orb causes the target to become surrounded
     by light to a radius of 20 feet, as if affected by a light spell.
     The effect lasts for 1 round, during which time the target makes
     his attack rolls and saving throws at a -4 penalty, and his AC is
     penalized by 4.
     Heat - Heat from the orb is intense enough to melt 1 cubic yard of
     ice.  The target suffers a loss of 1 point of Strength and 1 point
     of Dexterity for 1 round.
     Fire - Fire from the orb causes an extra 1d8 damage to the target.
     Objects within 5 ft of the target take 1d4 damage.
     Blindness - Blindness from the orb causes the victim to become blind,
     as per the spell.   The effect lasts for 1 round per caster level.
     Stinking Cloud - Stinking Cloud from the orb surrounds the target in
     a 5 ft radius noxious cloud.  The victim must make a Fortitude saving
     throw or be reeling and unable to attack until he leaves the area of
     effect.
     Cold - Cold from the orb causes an extra 2d4 damage to the target.
     Objects within 10 feet of the target take 2d4 damage.
     Paralysis - Paralysis from the orb causes the victim to become paralyzed
     for for 6-20 (2d8+4) rounds; a successful Will save halves the number
     of rounds.
     Petrification - Petrification from the orb turns the victim to stone.
     If the victim successfully makes a Fortitude saving throw, he avoids
     turning to stone and instead is slowed (as per the spell) for 2-8 (2d4)
     rounds.
     Death - Death from the orb causes the victim to die.  If the victim
     makes a Will saving throw, he avoids death and is instead paralyzed
     for 2-5 (1d4+1) rounds.

     Chromatic Orb Effects
     Caster Level    Orb Color    Damage     Special Power
     1st             White        1-4        Light
     2nd             Red          1-6        Heat
     3rd             Orange       1-8        Fire
     4th             Yellow       1-10       Blindness
     5th             Green        1-12       Stinking Cloud
     6th             Turquoise    2-8        Cold
     7th             Blue         2-16       Paralysis
     8th             Violet       slow       Petrification
     9th             Black        paralysis  Death

     REMINDER:  Even though you will be able to select higher caster level
     orbs from the radial menu, they will not work for you if you are not
     of the appropriate minimum caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: June 7, 2004
//:://////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget; // = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

    int     iDieType        = 0;
    int     iNumDice        = 0;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iOrbType        = GetSpellId();
    int     iRequiredLevel;
    object  oLoopTarget;
    int     iSaveType       = 0;  // for Special Powers that provide additional saves.
    int     iDamageType     = DAMAGE_TYPE_MAGICAL;
    float   fRadius;
    float fDuration;
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eImpVis;  // Visible impact effect
    effect eEffectVis; // Special Ability hits
    effect eDamage;  // Damage amount
    effect eApply;   // Use this to assign effect determined below and apply to object
    effect eSpecial; // Special Effect without extra save

    //  cannot declare inside case statements
	effect eLight;
	effect eAttack;
	effect eSave;
	effect eAC;
	effect eStr;
	effect eDex;
	string sAOETag;
    
    /// first make sure the caster can cast the given orb, this will change it to the highest level they can cast
    string sOriginalOrb = "";
	string sNewOrb = "";
	if ( iOrbType == SPELL_CHROMATIC_ORB_BLACK && iCasterLevel < 9 )
	{
		iOrbType == SPELL_CHROMATIC_ORB_VIOLET;
		if ( sOriginalOrb == "" )  { sOriginalOrb = "Black"; }
		sNewOrb = "Violet";
	}
	if ( iOrbType == SPELL_CHROMATIC_ORB_VIOLET && iCasterLevel < 8 )
	{
		iOrbType == SPELL_CHROMATIC_ORB_BLUE;
		if ( sOriginalOrb == "" )  { sOriginalOrb = "Violet"; }
		sNewOrb = "Blue";
	}
	if ( iOrbType == SPELL_CHROMATIC_ORB_BLUE && iCasterLevel < 7 )
	{
		iOrbType = SPELL_CHROMATIC_ORB_TURQUOISE;
		if ( sOriginalOrb == "" )  { sOriginalOrb = "Blue"; }
		sNewOrb = "Turquoise";
	}
	if ( iOrbType == SPELL_CHROMATIC_ORB_TURQUOISE && iCasterLevel < 6 )
	{
		iOrbType = SPELL_CHROMATIC_ORB_GREEN;
		if ( sOriginalOrb == "" )  { sOriginalOrb = "Turquoise"; }
		sNewOrb = "Green";
	}
	if ( iOrbType == SPELL_CHROMATIC_ORB_GREEN && iCasterLevel < 5 )
	{
		iOrbType = SPELL_CHROMATIC_ORB_YELLOW;
		if ( sOriginalOrb == "" )  { sOriginalOrb = "Green"; }
		sNewOrb = "Yellow";
	}
	if ( iOrbType == SPELL_CHROMATIC_ORB_YELLOW && iCasterLevel < 4 )
	{
		iOrbType = SPELL_CHROMATIC_ORB_ORANGE;
		if ( sOriginalOrb == "" )  { sOriginalOrb = "Yellow"; }
		sNewOrb = "Orange";
	}    
	if ( iOrbType == SPELL_CHROMATIC_ORB_ORANGE && iCasterLevel < 3 )
	{
		iOrbType = SPELL_CHROMATIC_ORB_RED;
		if ( sOriginalOrb == "" )  { sOriginalOrb = "Orange"; }
		sNewOrb = "Red";
	}
	if ( iOrbType == SPELL_CHROMATIC_ORB_RED && iCasterLevel < 2 )
	{
		iOrbType = SPELL_CHROMATIC_ORB_WHITE;
		if ( sOriginalOrb == "" )  { sOriginalOrb = "Red"; }
		sNewOrb = "White";
	}
    
    if(iRequiredLevel>iCasterLevel)
    {
        SendMessageToPC( oCaster, "The "+sOriginalOrb+" Orb you tried casting was too high for you, the Orb was changed to a "+sNewOrb+" Orb" );
    }
    
    
	if ( iOrbType == SPELL_CHROMATIC_ORB_BLACK && iCasterLevel >= 9 )
	{
		//eImpVis = EffectBeam(VFX_BEAM_BLACK, oCaster, BODY_NODE_HAND);
		eEffectVis = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_GREASE);
		eSpecial = EffectDeath();
		eApply = EffectParalyze();
		iSaveType=SAVING_THROW_WILL;
		fDuration=HkApplyDurationCategory(HkApplyMetamagicVariableMods( d4(1), 4 * 1 )+1, SC_DURCATEGORY_ROUNDS);
		//iRequiredLevel=9;
	}
	else if ( iOrbType == SPELL_CHROMATIC_ORB_VIOLET && iCasterLevel >= 8 )
	{
		//eImpVis=EffectBeam(VFX_BEAM_MIND, oCaster, BODY_NODE_HAND);
		eEffectVis=EffectVisualEffect(VFX_IMP_HEAD_MIND);
		eApply=EffectSlow();
		eSpecial=EffectPetrify();
		iSaveType=SAVING_THROW_FORT;
		fDuration = HkApplyDurationCategory(HkApplyMetamagicVariableMods( d4(2), 4 * 2 ), SC_DURCATEGORY_ROUNDS);
		//iRequiredLevel=8;
	}
	else if ( iOrbType == SPELL_CHROMATIC_ORB_BLUE && iCasterLevel >= 7 )
	{
		iDieType=8;
		iNumDice=2;
		//eImpVis=EffectBeam(VFX_BEAM_LIGHTNING, oCaster, BODY_NODE_HAND);
		eEffectVis=EffectVisualEffect(VFX_IMP_FROST_L);
		eApply=EffectParalyze();
		iSaveType=SAVING_THROW_WILL;
		fDuration=HkApplyDurationCategory(HkApplyMetamagicVariableMods( d8(2), 8 * 2 )+4, SC_DURCATEGORY_ROUNDS);
		iDamage = 0;
		//iRequiredLevel=7;
	}
	else if ( iOrbType == SPELL_CHROMATIC_ORB_TURQUOISE && iCasterLevel >= 6 )
	{
		iDieType=4;
		iNumDice=2;
		//eImpVis=EffectBeam(VFX_BEAM_COLD, oCaster, BODY_NODE_HAND);
		eEffectVis=EffectVisualEffect(VFX_COM_HIT_FROST);
		iDamageType=DAMAGE_TYPE_COLD;
		fRadius=FeetToMeters(10.0);
		//iRequiredLevel=6;
	}
	else if ( iOrbType == SPELL_CHROMATIC_ORB_GREEN && iCasterLevel >= 5 )
	{
		fDuration = HkApplyDurationCategory(iCasterLevel, SC_DURCATEGORY_ROUNDS);
		sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
		iDieType=12;
		iNumDice=1;
		//eImpVis=EffectVisualEffect(245);
		eEffectVis=EffectVisualEffect(VFX_COM_HIT_ACID);
		eApply=EffectAreaOfEffect(AOE_PER_FOGSTINKSINGLE, "", "", "", sAOETag);
		
		//iRequiredLevel=5;
	}
	 else if ( iOrbType == SPELL_CHROMATIC_ORB_YELLOW && iCasterLevel >= 4 )
	{
		iDieType=10;
		iNumDice=1;
		//eImpVis=EffectVisualEffect(VFX_IMP_MIRV_FLAME);
		eEffectVis=EffectVisualEffect(VFX_COM_HIT_DIVINE);
		eApply = EffectBlindness();
		fDuration = HkApplyDurationCategory(iCasterLevel, SC_DURCATEGORY_ROUNDS);
		//iRequiredLevel=4;
	}    
	 else if ( iOrbType == SPELL_CHROMATIC_ORB_ORANGE && iCasterLevel >= 3 )
	{
		iDieType=8;
		iNumDice=1;
		//eImpVis=EffectBeam(VFX_BEAM_FIRE, oCaster, BODY_NODE_HAND);
		eEffectVis=EffectVisualEffect(VFX_COM_HIT_FIRE);
		fRadius=FeetToMeters(5.0);
		iDamageType=DAMAGE_TYPE_FIRE;
		//iRequiredLevel=3;
	}
	else if ( iOrbType == SPELL_CHROMATIC_ORB_RED && iCasterLevel >= 2 )
	{
		iDieType=6;
		iNumDice=1;
		//eImpVis = EffectBeam(VFX_BEAM_EVIL, oCaster, BODY_NODE_HAND);
		eEffectVis = EffectVisualEffect(VFX_COM_HIT_NEGATIVE);
		eStr = EffectAbilityDecrease(ABILITY_STRENGTH, 1);
		eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, 1);
		eApply = EffectLinkEffects(eStr, eDex);
		fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_ROUNDS);
		//iRequiredLevel=2;
	}
	else // if ( iOrbType == SPELL_CHROMATIC_ORB_WHITE || iCasterLevel > 1 )
	{
		iOrbType = SPELL_CHROMATIC_ORB_WHITE;
		iDieType=4;
		iNumDice=1;
		//eImpVis = EffectVisualEffect(VFX_IMP_MIRV);
		eEffectVis = EffectVisualEffect(VFX_COM_HIT_SONIC);
		eLight = EffectVisualEffect(VFX_DUR_LIGHT_WHITE_20);
		eAttack = EffectAttackDecrease(4);
		eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 4);
		eAC = EffectACDecrease(4, AC_DEFLECTION_BONUS);
		eApply = EffectLinkEffects(eLight, eAttack);
		eApply = EffectLinkEffects(eApply, eSave);
		eApply = EffectLinkEffects(eApply, eAC);
		fDuration = HkApplyDurationCategory(1, SC_DURCATEGORY_ROUNDS);
		//iRequiredLevel=1;
	}
        
    
    fDuration = HkApplyMetamagicDurationMods( fDuration );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	  	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    //if( iRequiredLevel > iCasterLevel ) // redundant, already adjusted previously
    //{
    //    FloatingTextStringOnCreature("You have insufficient experience to cast an orb of this power.", oCaster, FALSE);
    //    HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFXSC_FNF_BURST_SMALL_SMOKEPUFF), oCaster);
    //}
    //else
    //{
	SignalEvent(oTarget, EventSpellCastAt(oCaster, iOrbType));
	int iTouch = CSLTouchAttackRanged(oTarget);
	if (iTouch != TOUCH_ATTACK_RESULT_MISS )
	{
		if(!HkResistSpell(oCaster, oTarget))
		{
			if(!HkSavingThrow(SAVING_THROW_WILL, oTarget,iDC))
			{
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eEffectVis, oTarget);
				if(iDamage>0)
				{
					switch(iOrbType)
					{
						case SPELL_CHROMATIC_ORB_ORANGE:
							iDamageType=DAMAGE_TYPE_FIRE;
							break;
						case SPELL_CHROMATIC_ORB_TURQUOISE:
							iDamageType=DAMAGE_TYPE_COLD;
							break;
					}
					eDamage=EffectDamage(iDamage,iDamageType,DAMAGE_POWER_PLUS_THREE);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
				}

				if(iOrbType==SPELL_CHROMATIC_ORB_BLACK && !HkSavingThrow(iSaveType, oTarget, iDC, SAVING_THROW_TYPE_DEATH, oCaster))
				{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eSpecial, oTarget);
				}
				else if(iOrbType==SPELL_CHROMATIC_ORB_VIOLET && !HkSavingThrow(iSaveType, oTarget, iDC))
				{
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eSpecial, oTarget);
				}
				else if(iOrbType!=SPELL_CHROMATIC_ORB_ORANGE || iOrbType!=SPELL_CHROMATIC_ORB_TURQUOISE)
				{
					if(iOrbType==SPELL_CHROMATIC_ORB_BLUE && HkSavingThrow(iSaveType, oTarget, iDC))
					{
						fDuration*=0.5;
					}
					HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eApply, oTarget, fDuration);
				}

				if(iOrbType==SPELL_CHROMATIC_ORB_ORANGE || iOrbType==SPELL_CHROMATIC_ORB_TURQUOISE)
				{
					lTarget=GetLocation(oTarget);
					oLoopTarget=GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
					while(GetIsObjectValid(oLoopTarget)) 
					{
						if(oLoopTarget==oTarget)
						{
							eApply=EffectLinkEffects(eEffectVis, eDamage);
							HkApplyEffectToObject(DURATION_TYPE_INSTANT, eApply, oLoopTarget);
						}
						else
						{
							iDamage = HkApplyMetamagicVariableMods( CSLDieX(iDieType, iNumDice), iDieType * iNumDice )+iBonus;
							iDamage=HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC);
							if(iDamage>0)
							{
								if(!HkResistSpell(oCaster, oLoopTarget))
								{
									eDamage=HkEffectDamage(iDamage,iDamageType,DAMAGE_POWER_PLUS_THREE);
									HkApplyEffectToObject(DURATION_TYPE_INSTANT, eEffectVis, oLoopTarget);
									HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oLoopTarget);
								}
							}
						}
						oLoopTarget=GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
					}
				}
			}
		}
	}
    //}

    HkPostCast(oCaster);
}

