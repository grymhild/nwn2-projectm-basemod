//::///////////////////////////////////////////////
//:: Cast In Stone
//:: sg_s0_castston.nss
//:: 2004 Karl Nickels (Syrus Greycloak) Rewritten by Pain for NWN2
//:://////////////////////////////////////////////
/*
    Magic of Faerun, Page 83
    Transmutation
	
	Level: Drd 9
	Components: V, S
	Casting Time: 1 action
	Range: Short
	Target: Personal
	Duration: 1 round/level
	Saving Throw: Will negates
	Spell Resistance: Yes
	
	Anyone meeting your gaze is permanently turned into a mindless, inert status ( as Flesh To Stone ).
	
	Each round a gaze attack automatically works against one random creature within range that is
	looking at ( attacking or interacting with ) the gazing creature.
*/


#include "_HkSpell"
#include "_SCInclude_Transmutation"


void SCDoGazeAttack( object oCaster, int iSpellId, int nPower, int nFortSaveDC, int iRemainingRounds, int iSerial = -1 )
{
	
	if ( !GetIsObjectValid( oCaster ) || !CSLSerialRepeatCheck( oCaster, "CASTINSTONE", iSerial ) )
	{
		// duplicate, there is a new heartbeat replacing this one
		return;
	
	}
	
	
	if ( iRemainingRounds < 1 || !GetHasSpellEffect(iSpellId, oCaster) )
	{
		//DeleteLocalInt(oCaster, "SERIAL_CASTINSTONE");
		return;
	}
	
	// only works if the caster can see, both the caster and target have to be able to see each other
	if ( !CSLIsGazeAttackBlocked(oCaster) )
	{
		int nCount = 0;
		location lTargetLocation = CSLGetLocationAboveAndInFrontOf(oCaster, 10.0f, 0.0f);
		vector vCasterOrigin = GetPosition(oCaster);
		object oTarget;
		object oTempTarget;
		oTempTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE, vCasterOrigin);
		while(GetIsObjectValid(oTempTarget))
		{
				if ( !GetHasSpellEffect(iSpellId, oTempTarget) && !CSLGetIsImmuneToPetrification( oTempTarget ) && !CSLIsGazeAttackBlocked( oTempTarget ) )
				{
					nCount++;
				}
				oTempTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE, vCasterOrigin);
		}
		
		if ( nCount == 0)
		{
			oTarget = OBJECT_INVALID;
		}
		else if ( nCount > 1) // more than one, pick a random one
		{
			int iRandom = Random(nCount)+1;
			
			nCount = 0;
			oTempTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE, vCasterOrigin);
			while( GetIsObjectValid(oTempTarget))
			{
				if ( !GetHasSpellEffect(iSpellId, oTempTarget) && !CSLGetIsImmuneToPetrification( oTempTarget ) && !CSLIsGazeAttackBlocked( oTempTarget ) )
				{
					nCount++;
					if ( iRandom == nCount)
					{
						oTarget = oTempTarget;
					}
				}
				oTempTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE, vCasterOrigin);
			}
		}
		
	
		if ( GetIsObjectValid( oTarget ) )
		{
			float fDelay = GetDistanceBetween(oCaster, oTarget)/20;
			DelayCommand(fDelay,  SCDoPetrification(nPower, oCaster, oTarget, iSpellId, nFortSaveDC));
			// put this one to prevent multiple saves being done over and over, one save and the target is immune to this effect for a while, probably need to make it extraordinary to prevent issues with dispel
			ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SetEffectSpellId(EffectVisualEffect(VFXSC_PLACEHOLDER), iSpellId ), oTarget, RoundsToSeconds( iRemainingRounds ) );
		}
	
	}
	if ( iSerial == -1 )
	{
		iSerial = CSLSerialGetCurrentValue( oCaster, "CASTINSTONE" );
	}
	iRemainingRounds--;
	DelayCommand( 6.0f, SCDoGazeAttack( oCaster, iSpellId, nPower, nFortSaveDC, iRemainingRounds, iSerial ) );
}


void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CAST_IN_STONE; // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	
	if( CSLIsGazeAttackBlocked( oCaster ) )
	{
		return;
	}
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iSpellPower = HkGetSpellPower( oCaster );
	
	int iCasterLevel = HkGetCasterLevel(oCaster);
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	iDuration    = FloatToInt(fDuration)/6;
	
	int iSaveDC = HkGetSpellSaveDC();
	string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	
	effect eLink = EffectVisualEffect(VFX_DUR_CESSATE_NEUTRAL);
	
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
    float   fRadius         = FeetToMeters(25+5*(iCasterLevel/2)*1.0); //Close Range
    int     iHasTarget      = FALSE;
	
	DelayCommand( 0.5f, SCDoGazeAttack( oCaster, iSpellId, iSpellPower, iSaveDC, iDuration ) );
	
    HkPostCast(oCaster);
}