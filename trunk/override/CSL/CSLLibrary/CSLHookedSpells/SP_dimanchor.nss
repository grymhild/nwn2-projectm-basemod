//::///////////////////////////////////////////////
//:: Dimensional Anchor
//:: sg_s0_dimanch.nss
//:: 2004 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Abjuration
     Level: Clr 4, Sor/Wiz 4, Portal 3
     Components: V,S
     Casting Time: 1 action
     Range: Medium
     Effect: Ray
     Duration: 1 minute/level
     Saving Throw: None
     Spell Resistance: Yes (object)

     A ray springs forth from your outstreched hand.
     You must make a ranged touch attack to hit the target.
     Any creature or object struck is covered with a shimmering
     field that completely blocks bodily extradimensional
     travel.  Forms of movement barred by Dimensional Anchor
     include Dimension Door, Etherealness, Teleport, and similar
     spell-like abilities.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: October 6, 2004
//:://////////////////////////////////////////////
//
// 
// void main()
// {
// 
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
//
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DIMENSIONAL_ANCHOR; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
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
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_MINUTES) );
	//int iMetamagic = HkGetMetaMagicFeat();
	//location lTarget = HkGetSpellTargetLocation();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

 SendMessageToPC( oCaster, "Running 2" );


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eBeam;
    effect eImpVis  = EffectVisualEffect(VFX_IMP_ACID_S);
    //effect eDurVis  = EffectVisualEffect(VFX_DUR_PIXIEDUST);
    effect eLink     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //effect eLink    = EffectLinkEffects(eDur, eDurVis);

    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE,oCaster)));
    
    int iTouch;
    if (  GetMaster(oTarget) == oCaster || GetFactionLeader(oCaster) == GetFactionLeader(oTarget) )
    {
    	iTouch = TOUCH_ATTACK_RESULT_HIT;
    }
    else
    {
    	iTouch = CSLTouchAttackRanged(oTarget, TRUE, 0, TRUE);
    }
     
	if ( iTouch != TOUCH_ATTACK_RESULT_MISS)
	{
        SendMessageToPC( oCaster, "Hit "+FloatToString(fDuration) );
		eBeam = EffectBeam(VFX_BEAM_ODD, oCaster, BODY_NODE_HAND, FALSE );
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5f );
        DelayCommand(1.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImpVis, oTarget));
        DelayCommand(1.5f, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, iSpellId ));
        //SetLocalInt(oTarget,"SG_TELEPORT_BLOCKED",TRUE);
        //DelayCommand(fDuration,DeleteLocalInt(oTarget,"SG_TELEPORT_BLOCKED"));
    }
    else
    {
        SendMessageToPC( oCaster, "mISS");
		eBeam = EffectBeam(VFX_BEAM_ODD, oCaster, BODY_NODE_HAND, TRUE);
        HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5f);
    }

    HkPostCast(oCaster);
}