//::///////////////////////////////////////////////
//:: Life Bolt
//:: sg_s0_lifebolt.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Necromancy
     Level: Sor/Wiz 2
     Components: V, S
     Casting Time: 1 action
     Range: Medium
     Effect: One ray/2 levels
     Duration: Instantaneous
     Saving Throw: None
     Spell Resistance: Yes

     You draw forth some of you own life force to
     create a beam of positive energy that harms
     undead.  You must make a ranged touch attack
     to hit, and if it hits an undead creature, it
     deals 2d4 points of damage to it.  Creating
     the beam deals you 1 point of damage.

     For every two levels of experience past 1st,
     you can create an additional ray, up to a
     maximum of five rays at 9th level.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: August 3, 2004
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
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------
    int     iDieType        = 4;
    int     iNumDice        = 2;
    int     iBonus          = 0;
    int     iDamage         = 0;

    int     iNumBolts       = 1 + (iCasterLevel-1)/2;
    int     i;

    if(iNumBolts>5) iNumBolts=5;


    //--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iBeamEffect = HkGetShapeEffect( VFX_BEAM_FIRE, SC_SHAPE_BEAM ); 
	int iHitEffect = HkGetHitEffect( VFX_COM_HIT_DIVINE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	

    effect eBolt    = EffectBeam(iBeamEffect, oCaster, BODY_NODE_HAND);  // Visible impact effect
    effect eDamage;
    effect eImpVis  = EffectVisualEffect(iHitEffect);
    effect eLink;
    effect eBoltMiss= EffectBeam(iBeamEffect, oCaster, BODY_NODE_HAND, TRUE);  // Miss effect

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_LIFE_BOLT));
    for(i=0; i<iNumBolts; i++)
    {
        if(!HkResistSpell(oCaster, oTarget) && CSLGetIsUndead(oTarget) )
        {
            int iTouch = CSLTouchAttackRanged(oTarget);
			if (iTouch != TOUCH_ATTACK_RESULT_MISS )
			{
                DelayCommand(i/10.0f,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.5f));
                iDamage = HkApplyMetamagicVariableMods( d4(iNumDice), 4 * iNumDice );
                iDamage = HkApplyTouchAttackCriticalDamage( oTarget, iTouch, iDamage, SC_TOUCHSPELL_RANGED, oCaster );
				
                eDamage=EffectDamage(iDamage);
                eLink=EffectLinkEffects(eDamage, eImpVis);
                DelayCommand(i/1.0f,HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
            }
            else
            {
                eBolt = EffectBeam(iBeamEffect, oCaster, BODY_NODE_HAND, TRUE);
                DelayCommand(i/10.0f,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBoltMiss, oTarget, 1.5f));
            }
        }
        HkApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oCaster);
    }

    HkPostCast(oCaster);
}

