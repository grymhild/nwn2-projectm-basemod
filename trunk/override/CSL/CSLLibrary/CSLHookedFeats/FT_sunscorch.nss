//::///////////////////////////////////////////////
//:: Sunscorch (2E Spells & Magic p. 163)
//:: sg_s0_sunscorch.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Evocation
     Level: Sun 1
     Components: V, S
     Casting Time: 1 action
     Range: Medium
     Target: 1 creature
     Duration: Instantaneous
     Saving Throw: Reflex Negates
     Spell Resistance: Yes

     This spell creates a brilliant ray of scorching
     heat that comes down from the sky to strike one
     target of the caster's choice.  The victim is
     entitled to a reflex save to avoid the ray - a
     successful save indicates that it missed altogether.
     Any creature struck by the ray sustains 1d6 points
     of damage, plus 1 point per caster level.  Undead
     and creatures and monsters susceptible to bright
     light sustain 1d6 points of damage, plus 2 points
     per caster level.  In addition to sustaining damage,
     living victims are also blinded for 1d4 rounds by
     the spell.

     The sun must be in the sky when Sunscorch is cast,
     or the spell fails entirely.  It cannot be cast
     underground, indoors, or in hours of darkness, although
     routine overcasts do not hinder the Sunscorch.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: September 29, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     location lTarget;        //= HkGetSpellTargetLocation();
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
//     //--------------------------------------------------------------------------
//     // Declare Spell Specific Variables & impose limiting
//     //--------------------------------------------------------------------------
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_ELEMENTAL, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration       = HkApplyMetamagicDurationMods( HkApplyDurationCategory( HkApplyMetamagicVariableMods( d4(1), 4 * 1 ) ) );

	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 6;
    int     iNumDice        = 1;
    int     iBonus          = iCasterLevel;
    int     iDamage         = 0;

    if( CSLGetIsUndead(oTarget) || CSLGetIsLightSensitiveCreature(oTarget))
    {
    	iBonus*=2;
    }
    //--------------------------------------------------------------------------
    // Resolve Metamagic, if possible
    //--------------------------------------------------------------------------
	iDamage = HkApplyMetamagicVariableMods( d6(iNumDice), 6 * iNumDice )+iBonus;


    
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_IMP_DIVINE_STRIKE_FIRE, SC_SHAPE_NONE ); 
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
    effect eImpVis  = EffectVisualEffect(iShapeEffect );
    effect eDamage  = HkEffectDamage(iDamage,iDamageType);
    effect eBlind   = EffectBlindness();
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDurLink = EffectLinkEffects(eBlind, eDur);
    effect eSmoke   = EffectVisualEffect(VFXSC_FNF_BURST_SMALL_SMOKEPUFF);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
    if( CSLGetIsInDayLight(oCaster) )
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_SUNSCORCH));
        if(!CSLGetIsConstruct(oTarget))
        {
            if(HkSavingThrow(SAVING_THROW_REFLEX, oTarget, iDC, iSaveType))
            {
                HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpVis, CSLGetMissLocation(oTarget));
            }
            else
            {
                HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget);
                if(!HkResistSpell(oCaster,oTarget))
                {
                    DelayCommand(0.2f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    if(!CSLGetIsUndead(oTarget))
                    {
						CSLRemoveEffectTypeSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, EFFECT_TYPE_BLINDNESS );
						DelayCommand(0.2f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDurLink, oTarget, fDuration));
                    }
                }
            }
        }
    }
    else
    {
        FloatingTextStringOnCreature("**You may only cast this spell during the day, above ground, and outside.**", oCaster, FALSE);
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oCaster);
    }
    HkPostCast(oCaster);
}


