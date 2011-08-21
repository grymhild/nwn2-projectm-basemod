//::///////////////////////////////////////////////
//::        Unity of Will
//::        nx_s0_ss_uwill.nss
//:://////////////////////////////////////////////
/*
	Cast Spell ability of the Silver Sword of Gith, usable 3 times per day.
	Area of effect ability which combines Greater Heroism and Mind Blank.
*/

//:://////////////////////////////////////////////
//::        Created By: Olivier Pougnand (OMP - OEI)
//::        Created On: June 15, 2007
//:://////////////////////////////////////////////
//:: RPGplayer1 03/19/2008:
//::  Delinked temporary HP
//::  Enemies immune to mind effects won't get penalties

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void PlayCustomAnimationWrapper(object oObject, string sAnimationName, int nLoop, float fSpeed)
{
	PlayCustomAnimation(oObject, sAnimationName, nLoop, fSpeed);
}

void CastSpell()
{
	// This one has it's Constant commented out for some reason
	// //scSpellMetaData = SCMeta_FT_sswordnx1uni();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, HkGetSpellTargetLocation() );
	effect eLink, eSearch;
	float fDuration = RoundsToSeconds( 10 );
	int bValid;
	effect eAttack = EffectAttackIncrease( 6 );
	effect eSave = EffectSavingThrowIncrease( SAVING_THROW_ALL, 6, SAVING_THROW_TYPE_ALL );
	effect eSkill = EffectSkillIncrease( SKILL_ALL_SKILLS, 6 );
	effect eHP = EffectTemporaryHitpoints( 40 );
	effect eFear = EffectImmunity( IMMUNITY_TYPE_FEAR );
	effect eMind = EffectImmunity( IMMUNITY_TYPE_MIND_SPELLS );
	effect eOnDispel = EffectOnDispel( 0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, SPELL_GREATER_HEROISM ) );
	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_MIND_BLANK );      

	eLink = EffectLinkEffects( eAttack, eSave );
	eLink = EffectLinkEffects( eLink, eSkill );
	//eLink = EffectLinkEffects( eLink, eHP );
	eLink = EffectLinkEffects( eLink, eFear );
	eLink = EffectLinkEffects( eLink, eMind );
	//eLink = EffectLinkEffects( eLink, eOnDispel );
	eLink = EffectLinkEffects( eLink, eVis );
	
	
	effect eVisPen1 = EffectVisualEffect( VFX_DUR_SPELL_FEAR ); // NWN2 VFX
	effect eFearPen = EffectFrightened();
	eFearPen = EffectLinkEffects( eFearPen, eVisPen1 );
	effect eSavePen = EffectSavingThrowDecrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL);
	//effect eHit = EffectVisualEffect(VFX_HIT_SPELL_ENCHANTMENT); // NWN1 VFX
	effect eVisPen2 = EffectVisualEffect( VFX_DUR_SPELL_CRUSHING_DESP ); // NWN2 VFX
	effect eSkillPen = EffectSkillDecrease(SKILL_ALL_SKILLS, 4);

	effect eDamagePenalty = EffectDamageDecrease(4);
	effect eAttackPenalty = EffectAttackDecrease(4);
	
	effect ePenLink2 = EffectLinkEffects(eDamagePenalty, eAttackPenalty);
	
	float fDurationPen = 60.0f;
	
	effect eMainVisualEffect = EffectNWN2SpecialEffectFile("fx_unity_will.sef");
	
	location lCaster = GetLocation(OBJECT_SELF);
	
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMainVisualEffect, lCaster);

	while ( GetIsObjectValid( oTarget ) )
	{
		if ( CSLSpellsIsTarget( oTarget, SCSPELL_TARGET_ALLALLIES, OBJECT_SELF ) )
		{
			eSearch = GetFirstEffect( oTarget );
			//Search through effects

			while( GetIsEffectValid( eSearch ) )
				{
			// Prevent stacking with Heroism
				bValid = FALSE;
				
					//  Check to see if the effect matches a particular type defined below
					if ( GetEffectType( eSearch ) == EFFECT_TYPE_DAZED )
					{
							bValid = TRUE;
					}
					else if( GetEffectType( eSearch ) == EFFECT_TYPE_CHARMED )
					{
							bValid = TRUE;
					}
					else if( GetEffectType( eSearch ) == EFFECT_TYPE_SLEEP )
					{
							bValid = TRUE;
					}
					else if( GetEffectType( eSearch ) == EFFECT_TYPE_CONFUSED )
					{
							bValid = TRUE;
					}
					else if( GetEffectType( eSearch ) == EFFECT_TYPE_STUNNED )
					{
							bValid = TRUE;
					}
					else if( ( GetEffectType(eSearch) == EFFECT_TYPE_DOMINATED && !GetLocalInt( oTarget, "SCSummon" ) ) )
					{
							bValid = TRUE;
					}
					else if ( GetEffectSpellId( eSearch ) == SPELL_FEEBLEMIND )
					{
							bValid = TRUE;
					}
					else if ( GetEffectSpellId( eSearch ) == SPELL_BANE )
					{
							bValid = TRUE;
					}
					else if ( GetEffectSpellId( eSearch ) == SPELL_HEROISM )
					{
						bValid = TRUE;
					}

					//  Remove effect if the effect is a match
					if ( bValid == TRUE )
					{
							RemoveEffect( oTarget, eSearch );
					}
		
					eSearch = GetNextEffect( oTarget );
				}

				CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, GetSpellId() );

				//Fire cast spell at event for the specified target

				SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, GetSpellId(), FALSE ) );

				//Apply the VFX impact and effects
			
				HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHP, oTarget, fDuration ); //FIX: HP need to be delinked
				HkApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
			
		}
		
		if (GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
			{
				// * added rep check April 2003
			// Removed rep check Spetember 2006 cause that ain't how we roll
				if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) == TRUE)
				{
					//Fire cast spell at event for the specified target
					SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

					//Make SR check
					if(!HkResistSpell(OBJECT_SELF, oTarget))
					{
							//Make Will save versus fear
							if(! HkSavingThrow(SAVING_THROW_WILL, oTarget, 32, SAVING_THROW_TYPE_MIND_SPELLS))
							{
								if (!GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
								{
								//Apply linked effects and VFX impact
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSavePen, oTarget, fDurationPen);
								HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePenLink2, oTarget, fDurationPen);
						HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVisPen2, oTarget);
								}
							}
					
					if(! HkSavingThrow(SAVING_THROW_WILL, oTarget, 26, SAVING_THROW_TYPE_FEAR))
						{
								//Apply the linked effects and the VFX impact
								DelayCommand(1.0, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFearPen, oTarget, fDurationPen));
						}
				
					}
				
				}
			
		}
				
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_ASTRONOMIC, HkGetSpellTargetLocation() );
	
	}
}

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	effect eVis = EffectNWN2SpecialEffectFile("sp_magic_cast.sef");
	
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, 2.0f);
	
	PlayCustomAnimationWrapper(oCaster, "liftswordup", 0, 0.75f);
	DelayCommand(1.0f, PlayCustomAnimationWrapper(oCaster, "liftswordloop", 0, 1.0f));
	DelayCommand(2.0f, PlayCustomAnimationWrapper(oCaster, "%", 0, 1.0f));
	
	DelayCommand(1.5f, CastSpell());
	
	
	HkPostCast(oCaster);
}