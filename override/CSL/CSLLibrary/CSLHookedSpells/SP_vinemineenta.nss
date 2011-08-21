//::///////////////////////////////////////////////
//:: Vine Mine, Entangle
//:: X2_S0_VineMEnt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Area of effect spell that places the entangled
	effect on enemies if they fail a saving throw
	each round.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_SP_vinemineenta();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_VINE_MINE_ENTANGLE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	int iSpellDuration = HkGetSpellDuration( oCaster ); // OldGetCasterLevel(oCaster);
	int nSpellDC = HkGetSpellSaveDC();
	location lTarget = HkGetSpellTargetLocation();
	
	float fDuration = RoundsToSeconds(iSpellDuration);
	if ( GetIsAreaNatural(GetArea(oCaster)) )
	{
		iSpellDuration *= 10;
	}
	
	string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE, "", "SP_vinemineentaC", "SP_vinemineentaB", sAOETag);  // SP_vinemineentaA      X2_S0_VineMEntC  X2_S0_VineMEntB
	DelayCommand( 0.1f, HkApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, fDuration ) );
	effect eLink = EffectVisualEffect(VFX_HIT_SPELL_TRANSMUTATION);
	eLink = EffectLinkEffects(eLink, EffectEntangle());
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
		
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget);
	while (GetIsObjectValid(oTarget))
	{
		if (!CSLGetIsIncorporeal( oTarget ))
		{
			if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
			{
				SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_VINE_MINE, TRUE ));
				if (!GetHasSpellEffect(SPELL_VINE_MINE_ENTANGLE, oTarget))
				{
					//if (!HkResistSpell(oCaster, oTarget))
					//{
						if (!HkSavingThrow(SAVING_THROW_REFLEX, oTarget, nSpellDC, SAVING_THROW_TYPE_NONE))
						{
							HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, 12.0f);
						}
					//}
				}
			}
		}
		oTarget = GetNextObjectInShape( SHAPE_SPHERE, fRadius, lTarget);
	}
	
	HkPostCast(oCaster);
}

