#include "_HkSpell"
//#include "x0_i0_spells"
////#include "cmi_includes"
// cmi_s2_turnplant.NSS
/*----  Kaedrin PRC Content ---------*/


void main()
{	
	//scSpellMetaData = SCMeta_FT_formastdomin();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_FEAT_TURN_UNDEAD;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
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
	int nTotalLevel =  GetLevelByClass(CLASS_FOREST_MASTER);
	if (GetHasFeat(FEAT_PLANT_DOMAIN_POWER))
	{
		nTotalLevel += GetLevelByClass(CLASS_TYPE_CLERIC);
	}
	
    int nCha = GetAbilityModifier(ABILITY_CHARISMA);
	int iDamage;
	int iDC = nTotalLevel + 10 + nCha;
	
    effect eVis = EffectVisualEffect( VFX_HIT_TURN_UNDEAD ); // VFX_FEAT_TURN_UNDEAD
	effect eDamage;

	float fSize = 2.0 * RADIUS_SIZE_COLOSSAL;
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lMyLocation = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lMyLocation);


	object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );	
    while( GetIsObjectValid(oTarget))
    {
        if( CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF )
        {
                if (GetRacialType(oTarget) == 22)
                {
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_TURN_UNDEAD));
                        DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
						iDamage = d6(nTotalLevel);
						
						//if (WillSave(oTarget, iDC, SAVING_THROW_WILL, OBJECT_SELF) == SAVING_THROW_CHECK_SUCCEEDED)
						//{
						//	iDamage = iDamage/2;
						//}
						iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_WILL, SAVING_THROW_METHOD_FORHALFDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_ALL, oCaster );
						eDamage = EffectDamage(iDamage, DAMAGE_TYPE_DIVINE);
                        DelayCommand(0.1f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));						
                }
        }
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fSize, lMyLocation, TRUE );
    }
    
    HkPostCast(oCaster);
}

