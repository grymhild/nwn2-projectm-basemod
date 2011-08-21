//::///////////////////////////////////////////////
//:: Mercy
//:: sp_mercy.nss
//:: 2009 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
Abjuration ??
Level:	Cleric 3
Components:	V, S
Casting Time:	1 standard action
Range:	Touch
Target:	Opponent
Duration:	1 round/level (D)

With a prayer the cleric channels mercy from their deity upon an almost fallen foe, making the enemy both protected from harm and also from suffering any further ill effect or anyone being able to attack them except a physical blow from the cleric.

However this mercy also restrict them from hostile action towards the cleric or his allies, or even able to move and cast spells. They can communicate with the cleric.

The spell can be dismissed by the cleric at will, which ends all protections and allowing them to move as desired. It also ends if the cleric attacks them or leaves the area.

if( !GetHasSpellEffect( SPELL_MERCY, oTarget ) )
	
*/
//:://////////////////////////////////////////////
//:: Based on Work of: Brian based on request by Sea of Dragons Player "XXXX"
//:: Created On:
//:://////////////////////////////////////////////

#include "_HkSpell"

void MonitorMercyApplication( object oTarget, object oCaster, int iSpellId, int iRemainingRounds, int iAlignment = ALIGNMENT_NEUTRAL, int iSerial = -1 )
{
	if ( !GetIsObjectValid( oTarget ) || !CSLSerialRepeatCheck( oTarget, "MERCY", iSerial ) )
	{
		// either no target or a new monitor is replacing the old
		return;
	}
	
	
	if ( iRemainingRounds < 1 || !GetHasSpellEffect(iSpellId, oTarget) || !GetIsObjectValid( oCaster ) || GetArea(oCaster) != GetArea(oTarget) || GetDistanceBetween(oTarget,oCaster) > 60.0f )
	{
		// need to put the following in module load as well
		SetImmortal(oTarget, FALSE);
		
		DeleteLocalInt(oTarget, "MERCY");
		DeleteLocalObject(oTarget, "CSL_MERCYCASTER");
		CSLSetOnDamagedScript( oTarget, "" );
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
				
		return;
	}
	
	
	if ( iAlignment == ALIGNMENT_GOOD )
	{
		if ( Random(2) == 0 )
		{
			//DelayCommand(0.3, AssignCommand(oTarget, SpeakString(CSLPickOne("ow!", "urggh", "ouch!"), TALKVOLUME_TALK)));
			CSLNWN2Emote(oTarget, CSLPickOne("talkplead","dejected", "idlecower") );
		}
		
		effect eHeal = EffectHeal(1);
		eHeal = EffectLinkEffects(eHeal, EffectVisualEffect(VFX_IMP_HEALING_S));
		
		
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
	}
	else if ( iAlignment == ALIGNMENT_EVIL )
	{
		if ( Random(2) == 0 )
		{
			DelayCommand(0.3, AssignCommand(oTarget, SpeakString(CSLPickOne("ow!", "urggh", "ouch!"), TALKVOLUME_TALK)));
			CSLNWN2Emote(oTarget, CSLPickOne("talkplead","talkinjured", "idlecower", "idleinj") );
		}
		
		effect eDam = EffectDamage(1, DAMAGE_TYPE_NEGATIVE);
		eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_INFLICT_1));
		ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oTarget, "COUNTERSPELLSERIAL" );
	}
	DelayCommand( 6.0f, MonitorMercyApplication( oTarget, oCaster, iSpellId, iRemainingRounds, iAlignment, iSerial ) );
}


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MERCY; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 3;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	//int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	int iAlignment = GetAlignmentGoodEvil(oCaster);
	//location lTarget = HkGetSpellTargetLocation();

	int iDuration = HkGetSpellDuration(oCaster);
	
	
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	
	int iSaveDC = HkGetSpellSaveDC();
	
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_FIRE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_FIRE);
	
	///float fTargetSize = HkApplySizeMods( RADIUS_SIZE_HUGE );
	//int iTargetShape = HkApplyShapeMods( SHAPE_SPHERE );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	//int iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	iDuration    = FloatToInt(fDuration)/6; // get the adjusted number of rounds again
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	//effect eVis = EffectVisualEffect( HkGetHitEffect(VFX_IMP_FLAME_M) );
	//effect eHit;
	
	//--------------------------------------------------------------------------
	// AOE
	//--------------------------------------------------------------------------
	//string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	//effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "", "", "", sAOETag);
	//DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	
	//--------------------------------------------------------------------------
	// Remove Previous Versions of this spell
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, GetLocation(oTarget));
	
	//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	if ( GetHasSpellEffect(iSpellId, oTarget)  )
	{
		FloatingTextStrRefOnCreature( SCSTR_REF_FEEDBACK_SPELL_FAILED, oTarget );  //"Failed"
		return;
	}
	
	//--------------------------------------------------------------------------
	// Apply effects
	//--------------------------------------------------------------------------
	//HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	// Visual
	//effect eExplode = EffectVisualEffect( HkGetShapeEffect( VFX_FNF_FIREBALL ) );
	//HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	
	
	
	if (!GetIsDead(oTarget, TRUE))
	{
		int iTouch = CSLTouchAttackMelee(oTarget);
		if (iTouch > TOUCH_ATTACK_RESULT_MISS )
		{
		
		// they're alive
			if ( CSLGetIsUndead(oTarget, TRUE) )
			{
				// we don't like undead
				if(!HkSavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC))
				{
					effect eDam = HkEffectDamage(1, DAMAGE_TYPE_POSITIVE);
					HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
			}
			else // we're alive and NOT undead...
			{
				// This prevents the spell hemorage
				
				
				
				if ( iAlignment == ALIGNMENT_EVIL )
				{
					CSLRemoveEffectTypeSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, EFFECT_TYPE_REGENERATE );
					
					effect eDam = EffectDamage(1, DAMAGE_TYPE_NEGATIVE);
					eDam = EffectLinkEffects(eDam, EffectVisualEffect(VFX_HIT_SPELL_INFLICT_1));
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
				}
				else // if ( iAlignment == ALIGNMENT_GOOD ) // or neutral
				{
					CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, SPELL_HEMORRHAGE );
					CSLRemoveEffectTypeSingle(SC_REMOVE_ALLCREATORS, oCaster, oTarget, EFFECT_TYPE_WOUNDING );
					
					effect eHeal = EffectHeal(1);
					eHeal = EffectLinkEffects(eHeal, EffectVisualEffect(VFX_IMP_HEALING_S));
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
					
				}
				
				
				// this stabilizes them, need to look at poison or diseases, so those don't kill them
				effect eHeal = EffectHeal(1);
				effect eVFX = EffectVisualEffect(VFX_IMP_HEALING_S);
				effect eLink = EffectLinkEffects(eHeal, eVFX);
				HkApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
			}
			
			if ( !GetImmortal(oTarget) )
			{
				if ( CSLGetIsLiving(oTarget, TRUE )  )
				{
					if ( CSLGetIsNearDeath( oTarget )  )
					{
						SetImmortal(oTarget, TRUE);
						
						effect eMercy = EffectCutsceneParalyze();
						CSLSetOnDamagedScript( oTarget, "SP_mercyB" );
						SetLocalObject(oTarget, "CSL_MERCYCASTER", oCaster );
						
						//eMercy = EffectLinkEffects(eMercy, EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION));
						eMercy = EffectLinkEffects( eMercy, EffectSpellLevelAbsorption(9, 999, SPELL_SCHOOL_GENERAL) ); // Absorbs all spells with spell resistance.
			
						eMercy = EffectLinkEffects( eMercy, EffectDamageResistance(DAMAGE_TYPE_ACID, 9999, 0) ); // this is to block AOE damage and attacks like whirlwind
						eMercy = EffectLinkEffects( eMercy, EffectDamageResistance(DAMAGE_TYPE_COLD, 9999, 0) );
						eMercy = EffectLinkEffects( eMercy, EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, 9999, 0) );
						eMercy = EffectLinkEffects( eMercy, EffectDamageResistance(DAMAGE_TYPE_FIRE, 9999, 0) );
						eMercy = EffectLinkEffects( eMercy, EffectDamageResistance(DAMAGE_TYPE_SONIC, 9999, 0) );
						eMercy = EffectLinkEffects( eMercy, EffectDamageResistance(DAMAGE_TYPE_DIVINE, 9999, 0) );
						
						// eMercy = EffectLinkEffects( eMercy, EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, 9999, 0) );
						
						eMercy = EffectLinkEffects( eMercy, EffectDamageResistance(DAMAGE_TYPE_POSITIVE, 9999, 0) );
						//eMercy = EffectLinkEffects( eMercy, EffectSanctuary(30) );
						eMercy = SetEffectSpellId( eMercy, iSpellId );
						
						HkApplyEffectToObject(iDurType, eMercy, oTarget, fDuration, iSpellId );
						
						MonitorMercyApplication( oTarget, oCaster, iSpellId, iDuration, iAlignment );
					}
					else
					{
						SendMessageToPC( oCaster, GetName(oTarget)+" is not near death.");
					}
				}
				else
				{
					SendMessageToPC( oCaster, GetName(oTarget)+" is not subject to this spell.");
				}
			}
		}
	}
	else
	{
		SendMessageToPC( oCaster, "You are too late, "+GetName(oTarget)+" is already dead.");
	}
		
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}