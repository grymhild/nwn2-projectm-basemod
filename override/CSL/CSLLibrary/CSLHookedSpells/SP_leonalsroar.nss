//::///////////////////////////////////////////////
//:: Leonal's Roar
//:: cmi_s0_leonalroar
//:: Purpose: 
//:: Created By: Kaedrin (Matt)
//:: Created On: Sept 25, 2007
//:://////////////////////////////////////////////

/*----  Kaedrin PRC Content ---------*/


#include "_HkSpell"
#include "_SCInclude_Abjuration"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"



void main()
{	
	//scSpellMetaData = SCMeta_SP_leonalsroar();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_LEONALS_ROAR;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == LION_TALISID_LEONALS_ROAR )
	{
		iClass = CLASS_LION_TALISID;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_HOLY;
	int iAttributes = SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_EVOCATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	CSLSpellGoodShift(oCaster);
	
    int iCasterHD;
    int iSpellDC;
	float fRadius = HkApplySizeMods(RADIUS_SIZE_TREMENDOUS);
    if ( GetSpellId() == LION_TALISID_LEONALS_ROAR )
    {
    	iCasterHD = GetHitDice(OBJECT_SELF);
    		
		iSpellDC = 20 + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
	}
	else // SPELL_LEONALS_ROAR
	{
    	iCasterHD = HkGetSpellPower( OBJECT_SELF, 30 );
    	iSpellDC = HkGetSpellSaveDC();	
	}
	// int iCasterHD = GetHitDice(OBJECT_SELF);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
		
			//if ( GetAlignmentGoodEvil(oTarget) != ALIGNMENT_GOOD)
			//{
			
			
	         	if (!HkResistSpell(OBJECT_SELF, oTarget))
	         	{
					int iHD = GetHitDice(oTarget);
					if ( GetLocalObject(oTarget, "DOMINATED")!=OBJECT_INVALID) 
					{
						iHD /= 2;
					}
					//Banish Effect;
					if ( !GetIsPC(oTarget) && GetSubRace(oTarget) == RACIAL_SUBTYPE_OUTSIDER )
					{	
						if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+4)))
	            		{
							if (!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
							{
								effect eDeath = EffectVisualEffect( VFX_HIT_AOE_ABJURATION );
								eDeath = EffectLinkEffects(eDeath, EffectDeath(FALSE,TRUE,TRUE));
								DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
							}
							else
							{
								effect eDeath = EffectVisualEffect( VFX_HIT_AOE_ABJURATION );
								eDeath = EffectLinkEffects(eDeath, HkEffectDamage(GetCurrentHitPoints(oTarget)+10) );
								DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
							}
	           			}
						else
						{
							SCApplyBlasphemyEffect(oTarget,iHD,iCasterHD,iSpellDC);
						}
					}
					else
					{
						SCApplyBlasphemyEffect(oTarget,iHD,iCasterHD,iSpellDC);
					}						
								
				}
			//}	
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, GetLocation(OBJECT_SELF));
    }	
	
	HkPostCast(oCaster);	
}

