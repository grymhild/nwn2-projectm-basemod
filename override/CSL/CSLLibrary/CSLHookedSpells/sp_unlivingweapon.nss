//::///////////////////////////////////////////////
//:: Name 	Unliving Weapon
//:: FileName sp_unliv_weap.nss
//:://////////////////////////////////////////////
/**@file Unliving Weapon
Necromancy [Evil]
Level: Clr 3
Components: V, S, M
Casting Time: 1 full round
Range: Touch
Targets: One undead creature
Duration: 1 hour/level
Saving Throw: Will negates
Spell Resistance: Yes

This spell causes an undead creature to explode in a
burst of powerful energy when struck for at least 1
point of damage, or at a set time no longer than the
duration of the spell, whichever comes first. The
explosion is a 10-foot radius burst that deals 1d6
points of damage for every two caster levels
(maximum 10d6).

While this spell can be an effective form of attack
against an undead creature, necromancers often use
unliving weapon to create undead capable of suicide
attacks (if such a term can be applied to something
that is already dead). Skeletons or zombies with this
spell cast upon them can be very dangerous to foes
that would normally disregard them.

Material Component: A drop of bile and a bit of sulfur.

Author: 	Tenjac
Created: 	5/11/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////



#include "_HkSpell"



void UnlivingHeartbeat(object oTarget, int nCounter, int nHP )
{
	if( !GetHasSpellEffect(SPELL_UNLIVING_WEAPON, oTarget)) // expired or not applicable so exit out
    {
		CSLSetOnDamagedScript( oTarget, "" );
		DeleteLocalInt(oTarget, "SG_UNLIVINGWEAPON_HP");
		return; 
	}
	
	if((nCounter < 1) || GetCurrentHitPoints(oTarget) < nHP) // force script to go off
	{
		SetLocalInt(oTarget, "SG_UNLIVINGWEAPON_HP", nHP+10000 ); // this forces an explosion
		ExecuteScript("SP_unlivingweaponB", oTarget );
	}
	
	nCounter--;
	nHP = GetCurrentHitPoints(oTarget);
	
	SetLocalInt(oTarget, "SG_UNLIVINGWEAPON_HP", nHP );
	
	DelayCommand(3.0f, UnlivingHeartbeat(oTarget, nCounter, nHP ));
}


void main()
{	
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_UNLIVING_WEAPON; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	//int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	object oTarget = HkGetSpellTarget();
	
	int iDC = HkGetSpellSaveDC(oCaster);
	int nCasterLvl = HkGetCasterLevel(oCaster);
	//float fDur = HoursToSeconds(nCasterLvl);
	
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_HOURS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	int nCounter = (FloatToInt(fDuration))/3;
	int iSpellPower = HkGetSpellPower( oCaster, 20 )/2; 
	int iMetaMagic = HkGetMetaMagicFeat();
	int bHostile = TRUE;
	
	
	
	if ( GetIsObjectValid( oTarget ) && CSLGetIsUndead( oTarget, TRUE ) ) // this allows it to affect those who are in unliving form, you should be able to cast on yourself
	{
		
		if ( !GetHasSpellEffect( SPELL_UNLIVING_WEAPON, oTarget))
		{
			effect eUnlivingWeapon = EffectVisualEffect(VFX_DUR_FIREBALL);
			
			if ( oCaster == oTarget ) // Suicide ???
			{
				bHostile = FALSE; 
			}
			else if ( GetIsPC(oCaster) && GetIsPC(oTarget) ) // this is if in party, thinking this would always be hostile and allows backstabbing those in your party
			{
				bHostile = TRUE;
			}
			else if ( GetMaster(oTarget) == oCaster ) // this can be used on my own undead without them getting a save
			{
				bHostile = FALSE;
			}
			else if ( !GetIsPC(oCaster) && ( GetIsReactionTypeFriendly(oTarget,oCaster) || GetFactionEqual(oTarget,oCaster) ) ) // npc's can use this whenver reputation is friendly basically
			{
				bHostile = FALSE;
			}
			else if ( GetIsPC(oCaster) && ( GetFactionLeader(oCaster) == GetFactionLeader(oTarget) ) ) // this is if in party and targeting non pc's
			{
				bHostile = FALSE;
			}
			
			int nHP = GetCurrentHitPoints(oTarget);
			
			if ( bHostile )
			{
				if ( !HkResistSpell(oCaster, oTarget)) // Spell Resistance
				{
					SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
					//Saving Throw
					if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(oCaster,oTarget), SAVING_THROW_TYPE_SPELL))
					{
						//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_UNLIVING_WEAPON );
						HkApplyEffectToObject(iDurType, eUnlivingWeapon, oTarget, fDuration, iSpellId );
						CSLSetOnDamagedScript( oTarget, "SP_unlivingweaponB" );
						SetLocalInt(oTarget, "SG_UNLIVINGWEAPON_HP", GetCurrentHitPoints( oTarget ) );
						
						UnlivingHeartbeat(oTarget, nCounter, GetCurrentHitPoints( oTarget ) );
					}
				}
			}
			else
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, FALSE ));
				
				//CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_UNLIVING_WEAPON );
				HkApplyEffectToObject(iDurType, eUnlivingWeapon, oTarget, fDuration, iSpellId );
				CSLSetOnDamagedScript( oTarget, "SP_unlivingweaponB" );
				SetLocalInt(oTarget, "SG_UNLIVINGWEAPON_HP", GetCurrentHitPoints( oTarget ) );
				
				UnlivingHeartbeat(oTarget, nCounter, GetCurrentHitPoints( oTarget ) );
			}
			CSLSpellEvilShift(oCaster);
		}
		else
		{
			SendMessageToPC(oCaster, "Unliving Weapon is already applied to "+GetName( oTarget) );
		}
	}
	else
	{
		SendMessageToPC( oCaster, "You can only target undead with unliving weapon.");
	}
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}