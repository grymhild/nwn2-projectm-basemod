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
	int iSpellId = SPELL_UNLIVING_WEAPON; // put spell constant here
	
	
	
	// oCreator
	object  oTarget = CSLGetOriginalDamageTarget(OBJECT_SELF);
	
	
	if( !GetIsObjectValid(oTarget) )
    {
		//SendMessageToPC( GetFirstPC(),"Exited, oTarget not valid");
		return;
	}
	
	object  oAttacker = GetLastDamager(OBJECT_SELF);
	
	if( !GetHasSpellEffect(SPELL_UNLIVING_WEAPON, oTarget)) // expired or not applicable
    {
		CSLSetOnDamagedScript( oTarget, "" );
		DeleteLocalInt(oTarget, "SG_UNLIVINGWEAPON_HP");
		// SendMessageToPC( GetFirstPC(),"Exited, does not have freezing curse anymore");
	}
	

	
    int iStoredHps = GetLocalInt(oTarget, "SG_UNLIVINGWEAPON_HP");
	if ( iStoredHps == 0 )
	{
		iStoredHps = GetMaxHitPoints(oTarget);
		SetLocalInt(oTarget, "SG_UNLIVINGWEAPON_HP", iStoredHps );
	}
	
	int iHitPointThreshold = iStoredHps;
    int iCurrHP = GetCurrentHitPoints(oTarget);
	
	if ( iCurrHP < iHitPointThreshold )
	{
		
		object oCaster = IntToObject( CSLGetTargetTagInt( SCSPELLTAG_CASTERPOINTER, oTarget, iSpellId ) );
		int iDC = CSLGetTargetTagInt( SCSPELLTAG_SPELLSAVEDC, oTarget, iSpellId );
		int iSpellPower = CSLGetTargetTagInt( SCSPELLTAG_SPELLPOWER, oTarget, iSpellId );
		int iMetaMagic = CSLGetTargetTagInt( SCSPELLTAG_METAMAGIC, oTarget, iSpellId );
		// time to explode
		float fRadius = RADIUS_SIZE_MEDIUM;
		effect eVis = EffectVisualEffect( CSLGetAOEExplodeByDamageType(DAMAGE_TYPE_NEGATIVE, fRadius ) );
		effect eHitEffect = EffectVisualEffect(VFX_HIT_SPELL_NECROMANCY);
		location lLoc = GetLocation(oTarget);
		int nMetaMagic = HkGetMetaMagicFeat();
		int iDamage;
		float fDelay;
		
		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
		
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_UNLIVING_WEAPON );
		
		object oOuch = GetFirstObjectInShape(SHAPE_SPHERE, fRadius,lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		while( GetIsObjectValid(oOuch) )
		{
			if ( oOuch == oTarget ) // the main target gets double damage, likely killing it, prolly need to see if damage greater than hps and if so just destroy the object
			{
				SignalEvent( oOuch, EventSpellCastAt(oCaster, iSpellId, TRUE )); // at this point they should be pissed off at the caster, idea is to use on weaker undead
				iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower*2), (6*iSpellPower)*2, iMetaMagic );
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oOuch);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHitEffect, oOuch);
			}
			else
			{
				if ( CSLSpellsIsTarget( oOuch, SCSPELL_TARGET_STANDARDHOSTILE, oCaster ) ) // this likely will set a chain reaction off
				{
					fDelay = GetDistanceBetweenLocations(lLoc, GetLocation(oOuch))/20;
					if (!HkResistSpell(oCaster, oTarget, fDelay))
					{
						SignalEvent( oOuch, EventSpellCastAt(oCaster, iSpellId, TRUE ));
						iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6*iSpellPower, iMetaMagic);
						iDamage = HkGetSaveAdjustedDamage(SAVING_THROW_REFLEX,SAVING_THROW_METHOD_FORHALFDAMAGE,iDamage, oTarget, iDC, SAVING_THROW_TYPE_SPELL );
						if(iDamage > 0)
						{
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL), oOuch) );
							DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHitEffect, oOuch) );
						}
					}
				}
			}
			//Get next victim
			oOuch = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lLoc, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
		}
    }
}
