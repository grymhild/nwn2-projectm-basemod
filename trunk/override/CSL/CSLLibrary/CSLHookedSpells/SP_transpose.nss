//::///////////////////////////////////////////////
//:: Baleful/Benign Transposition
//:: sg_s0_transpose.nss
//:: 2006 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
Spell Description here
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 9, 2006
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
	int iAttributes = SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_TELEPORTATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	location lTarget;
	int     bTranspose      = TRUE;
	int     bIsTargetHostile= FALSE;
	location lCaster;
	location lImpactLoc = HkGetSpellTargetLocation();

    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFX_IMP_HEALING_G);
 
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	 // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( VFX_HIT_SPELL_CONJURATION );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if( GetFactionLeader(oCaster)!=GetFactionLeader(oTarget) )
    {
        bIsTargetHostile = TRUE;
    }
    
	if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE )
	{
		bTranspose = FALSE;
	}
	else if ( !CSLGetCanTeleport( oCaster ) )
	{
		bTranspose = FALSE;
		SendMessageToPC( oCaster, "You are Dimensionally Anchored");
	}
	else if ( !CSLGetCanTeleport( oTarget ) )
	{
		bTranspose = FALSE;
		SendMessageToPC( oCaster, "Target Is Dimensionally Anchored");
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, bIsTargetHostile));
	}
    else if( iSpellId == SPELL_BALEFUL_TRANSPOSITION && bIsTargetHostile)
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, bIsTargetHostile));
        if(HkResistSpell(oCaster, oTarget))
        {
            bTranspose = FALSE;
        }
        else if(HkSavingThrow(SAVING_THROW_WILL, oTarget, iDC))
        {
            bTranspose = FALSE;
        }
    }
    else if( iSpellId == SPELL_BENIGN_TRANSPOSITION && bIsTargetHostile)
    {
        bTranspose = FALSE;
    }
    else
    {
        SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, bIsTargetHostile));
    } 
    
    if(bTranspose)
    {
		AssignCommand(oTarget, ClearAllActions() );
		AssignCommand(oCaster, ClearAllActions() );
		
		DelayCommand( 1.5f,  CSLTeleportToLocation( oCaster, GetLocation(oTarget), VFX_HIT_SPELL_CONJURATION ) );
		DelayCommand( 1.5f,  CSLTeleportToLocation( oTarget, GetLocation(oCaster), VFX_HIT_SPELL_CONJURATION ) );
       
		//AssignCommand(oCaster, ClearAllActions());
		//AssignCommand(oCaster,ClearAllActions(TRUE));
		//DelayCommand( 2.5f, CSLTranspose( oCaster, oTarget ) );
		//AssignCommand(oTarget, ClearAllActions());
		//AssignCommand(oCaster, ClearAllActions());
       //CSLTranspose( oCaster, oTarget );
       
      //  lTarget = GetLocation(oTarget);
       // lCaster = GetLocation(oCaster);
       // HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lCaster);
        //DelayCommand(0.1, JumpToLocation(lCaster) );
       	//DelayCommand(0.1, JumpToLocation(lTarget) );
       // AssignCommand(oTarget, JumpToLocation(lCaster));
       // AssignCommand(oCaster, JumpToLocation(lTarget));
        
        //DelayCommand(0.05f, AssignCommand(oCaster, ClearAllActions()));
        //DelayCommand(0.05f, AssignCommand(oTarget, ClearAllActions()));                      
        //DelayCommand(0.10f, AssignCommand(oTarget, JumpToLocation(lCaster)));
        //DelayCommand(0.10f, AssignCommand(oCaster, JumpToLocation(lTarget)));
       // DelayCommand(0.15f, AssignCommand(oCaster, ClearAllActions()));
      //  DelayCommand(0.15f, AssignCommand(oTarget, ClearAllActions()));  
      //  DelayCommand(0.05f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oCaster));
    }
    
    HkPostCast(oCaster);
}