//::///////////////////////////////////////////////
//:: Blasphemy
//:: cmi_s0_blasphemy
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 25, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void SCApplyBlasphemyEffect(object oTarget, int iHD, int iCasterHD)
{

	effect eVis = EffectVisualEffect( VFX_DUR_SPELL_BESTOW_CURSE );
	
	float fDazeDur = HkApplyMetamagicDurationMods(TurnsToSeconds(1));
	
	int nPara = d10();
	float fParaDur = HkApplyMetamagicDurationMods(TurnsToSeconds(nPara));
	
	int nWeakStr = d6(2);
	int nWeakDur = d4(2);
	float fWeakDur = HkApplyMetamagicDurationMods(RoundsToSeconds(nWeakDur));
			
	int SpellDC = HkGetSpellSaveDC();	
	float fDelay = CSLRandomBetweenFloat(0.4, 1.1);
	int SpellId = GetSpellId();
			
	//Para Effect;
	effect ePara = EffectParalyze(SpellDC,SAVING_THROW_WILL); 
							
	//Weak Effect;
	effect eWeak = EffectAbilityDecrease(ABILITY_STRENGTH, nWeakStr);
				
	//Daze Effect;					
	effect eDaze = EffectDazed();
	eDaze = EffectLinkEffects(eVis,eDaze);	

	if (iHD > iCasterHD)
	{
		//No Effect
	}
	else if (iHD == iCasterHD)
	{
	
				
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, SpellId );
		//Daze
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDazeDur);
	
	}
	else if ((iHD < iCasterHD) && (iHD > (iCasterHD - 5)))
	{
		
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, SpellId );	

		//Daze
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDazeDur);
		
		//Weak		
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeak, oTarget, fWeakDur);
		
	}
	else if ((iHD <= (iCasterHD - 5) && (iHD > (iCasterHD - 10))))
	{
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, SpellId );	
	
		//Daze
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDazeDur);
				
		//Weak		
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeak, oTarget, fWeakDur);

		//Para	
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, fParaDur);		
	}
	else
	{
	
		CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF,  oTarget, SpellId );
			
		//Daze
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDaze, oTarget, fDazeDur);
		
		//Weak		
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eWeak, oTarget, fWeakDur);
			
		//Para	
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SpellId, FALSE));
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, oTarget, fParaDur);		
		
		//Death
		effect eDeath = EffectDeath();						
	    HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);	
		
	}
					
}

void main()
{	
	//scSpellMetaData = SCMeta_FT_blasphemy();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 7;
	int iImpactSEF = VFX_HIT_AOE_HOLY;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	

    	
	int iCasterHD = GetHitDice(OBJECT_SELF);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
		
			if (GetAlignmentGoodEvil(oTarget) != ALIGNMENT_EVIL)
			{
			
			
	         	if (HkResistSpell(OBJECT_SELF, oTarget))
	         	{
					// Spell resisted, no effect
	        	}	
				else
				{
				
					int iHD = GetHitDice(oTarget);

					//Banish Effect;
					if (GetSubRace(oTarget) == RACIAL_SUBTYPE_OUTSIDER)
					{	
						if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+4)))
	            		{
						    effect eVis = EffectVisualEffect( VFX_HIT_AOE_ABJURATION );
							effect eDeath = EffectDeath(FALSE,TRUE,TRUE);
							effect eBanishLink = EffectLinkEffects(eVis, eDeath);						
	                		HkApplyEffectToObject(DURATION_TYPE_INSTANT, eBanishLink, oTarget);
	           			}
						else
						{
							SCApplyBlasphemyEffect(oTarget,iHD,iCasterHD);
						}
					}
					else
					{
						SCApplyBlasphemyEffect(oTarget,iHD,iCasterHD);
					}						
								
				}
			}	
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_TREMENDOUS, GetLocation(OBJECT_SELF));
    }	
	
}      

