//::///////////////////////////////////////////////
//:: Freezing Curse - Changed to OnHit
//:: SG_S0_FrzCurseb.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     Target is frozen solid in ice.  Upon taking 5hp
     dmg, target shatters and is killed.

*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////

//#include "sg_i0_spconst"
//
//
//
// #include "_CSLCore_Items"
// 
// void main()
// {
//     object  oItem           = GetSpellCastItem();
//     object  oTarget         = GetItemPossessor(oItem);
//
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_FREEZING_CURSE; // put spell constant here
	
	object  oTarget = CSLGetOriginalDamageTarget(OBJECT_SELF);
	
	if( !GetIsObjectValid(oTarget) )
    {
		SendMessageToPC( GetFirstPC(),"Exited, oTarget not valid");
		return;
	}
	
	object  oAttacker = GetLastDamager(OBJECT_SELF);
	
	if( !GetHasSpellEffect(SPELL_FREEZING_CURSE, oTarget)) // expired or not applicable
    {
		CSLSetOnDamagedScript( oTarget, "" );
		DeleteLocalInt(oTarget, "SG_FRZCURSE_HP");
		// SendMessageToPC( GetFirstPC(),"Exited, does not have freezing curse anymore");
	}
	

	
    int iStoredHps = GetLocalInt(oTarget, "SG_FRZCURSE_HP");
	if ( iStoredHps == 0 )
	{
		iStoredHps = GetMaxHitPoints(oTarget);
		SetLocalInt(oTarget, "SG_FRZCURSE_HP", iStoredHps );
	}
	int iHitPointThreshold = iStoredHps - 5;
    int iCurrHP = GetCurrentHitPoints(oTarget);
	
	if ( iCurrHP <= iHitPointThreshold )
	{
		//--------------------------------------------------------------------------
		// Effects
    	//--------------------------------------------------------------------------
    	effect eDam = EffectDamage(iCurrHP,DAMAGE_TYPE_MAGICAL,DAMAGE_POWER_PLUS_TWENTY);
		effect eVis = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
		effect eImp = EffectVisualEffect(VFX_FNF_ICESTORM);
		effect eDeath = EffectDeath( FALSE, TRUE, TRUE);

    	
		//--------------------------------------------------------------------------
		//Apply effects
		//--------------------------------------------------------------------------
		location lImpactLoc = GetLocation(oTarget); // GetLocation( oCreator );
		effect eImpactVis = EffectVisualEffect( VFX_HIT_SPELL_ICE );
		ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

		           
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oTarget);
 		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oTarget, oTarget, SPELL_FREEZING_CURSE );
		DelayCommand(0.1, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
		DelayCommand(0.0, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        if ( GetIsPC( oTarget ) )
        {
        	SendMessageToPC( oTarget,"You feel "+GetName(oAttacker)+" impact shatter you!");
        }
        
        if ( GetIsPC( oAttacker ) )
        {
        	SendMessageToPC( oAttacker,"Your impact shatters "+GetName(oTarget)+"!");
        }
    }
    else
    {
    	if ( GetIsPC( oTarget ) )
        {
        	SendMessageToPC( oTarget,"You feel about to shatter from the impact by "+GetName(oAttacker)+"!");
        }
    }
}
