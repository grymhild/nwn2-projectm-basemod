//::///////////////////////////////////////////////
//:: Evards Black Tentacles: On Enter
//:: NW_S0_EvardsA
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Upon entering the mass of rubbery tentacles the
	target is struck by 1d4 tentacles.  Each has
	a chance to hit of 5 + 1d20. If it succeeds then
	it does 1d6 damage and the target must make
	a Fortitude Save versus paralysis or be paralyzed
	for 1 round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




int RunRollToHit(object oTarget, object oCaster, int iBonus) {
	int iRoll = d20();
	if (iRoll==20) return TRUE;
	if (iRoll==1)  return FALSE;
	iRoll += GetBaseAttackBonus(oCaster) + iBonus;
	return (iRoll>=GetAC(oTarget));
}



void main()
{
	//scSpellMetaData = SCMeta_SP_evardsblackt(); //SPELL_EVARDS_BLACK_TENTACLES;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = GetAreaOfEffectCreator();
	int iSpellId = SPELL_EVARDS_BLACK_TENTACLES;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
		
	effect eImmoble = EffectCutsceneImmobilize();
	effect eVis = EffectVisualEffect(VFX_DUR_PARALYZED);
	effect eLink = EffectLinkEffects(eVis, eImmoble);
	eLink = EffectLinkEffects(eLink, EffectAttackDecrease(4));
	eLink = EffectLinkEffects(eLink, EffectSpellFailure());
	effect eDam;
	int iDamage = 0;
	float fDelay;
	int nHits;
	int iBonus = HkGetBestCasterModifier(oCaster, TRUE, FALSE);
	object oTarget = GetEnteringObject();
	
	if ( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster) )
	{
		SignalEvent(oTarget, EventSpellCastAt(oCaster, iSpellId, TRUE ));
		// slowing is regardless
		for (nHits = d4(); nHits>0; nHits--)
		{
			if (RunRollToHit(oTarget, oCaster, iBonus))
			{
				DelayCommand( 0.1,  HkNonStackingSlow( oTarget, oCaster, RoundsToSeconds(1), 3805 )  );
		
				iDamage = 0;
				if((GetCreatureSize(oTarget)>CREATURE_SIZE_SMALL)&&(GetCreatureSize(oTarget)<=CREATURE_SIZE_HUGE)&&!CSLGetIsIncorporeal( oTarget )&&!GetIsImmune(oTarget,IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE,OBJECT_SELF))
				{
						fDelay = CSLRandomBetweenFloat(0.75, 1.50);
						if( CSLGrappleCheck( oCaster, oTarget, HkGetSpellPower(oCaster, 30 ) ) ) // only cast by warlocks
						{
							iDamage = d6();
							//Enter Metamagic conditions
							eDam = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
							DelayCommand(0.3, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
							{
								DelayCommand(0.1, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
							}
						}
				   
				}
			}
		}
		// Apply Cold Damage regardless of whether or not any tentacles struck the target.... 
		//fDelay  = CSLRandomBetweenFloat(0.4, 0.8);
		//iDamage = d6(2);
		///iDamage = ApplyMetamagicVariableMods( iDamage, 2*6 );
		///eDam = EffectDamage(iDamage, DAMAGE_TYPE_COLD);
		//DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	}
}

/*
void main()
{
	//scSpellMetaData = SCMeta_SP_evardsblackt(); //SPELL_EVARDS_BLACK_TENTACLES;
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	int iSpellId = SPELL_EVARDS_BLACK_TENTACLES;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	HkPreCast( OBJECT_INVALID, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION );
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	object oTarget = GetEnteringObject();
	object oCreator = GetAreaOfEffectCreator();
	int nHits;
	int iDamage = 0;
	int iSaveDC = HkGetSpellSaveDC();
	float fDelay;
	int iBonus = HkGetBestCasterModifier(oCreator, TRUE, FALSE);
	effect eDam;
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCreator)) {
		SignalEvent(oTarget, EventSpellCastAt(oCreator, SPELL_EVARDS_BLACK_TENTACLES));
		for (nHits = d4(); nHits>0; nHits--) {
			if (RunRollToHit(oTarget, oCreator, iBonus)) { //ROLL TO HIT TARGET
				fDelay = CSLRandomBetweenFloat(1.0, 2.2);
				iDamage = HkApplyMetamagicVariableMods(d6()+4, 10) + iBonus;
				eDam = EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
				DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
			}
		}
		if (iDamage>0 && !HkSavingThrow(SAVING_THROW_FORT, oTarget, iSaveDC, SAVING_THROW_TYPE_NONE, oCreator, fDelay)) {
			effect ePara = EffectVisualEffect(VFX_DUR_PARALYZED);
			ePara = EffectLinkEffects(ePara, EffectParalyze(iSaveDC, SAVING_THROW_FORT));
			DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, 6.0));
		}
	}
}
*/