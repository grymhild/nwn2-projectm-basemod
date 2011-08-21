//::///////////////////////////////////////////////
//:: Crumble
//:: X2_S0_Crumble
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// This spell inflicts 1d6 points of damage per
// caster level to Constructs to a maximum of 15d6.
// This spell does not affect living creatures.
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Oct 2003/
//:: 2004-01-02: GZ: Removed Spell resistance check
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




void DoCrumble (int nDam, object oCaster, object oTarget, int iDamageType = DAMAGE_TYPE_SONIC );

void main()
{
	//scSpellMetaData = SCMeta_SP_crumble();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CRUMBLE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 6;
	int iImpactSEF = VFX_HIT_SPELL_MAGIC;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_SONIC, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	object oTarget  = HkGetSpellTarget();
	int  iSpellPower = HkGetSpellPower( oCaster, 15 ); // OldGetCasterLevel(oCaster);
	int  nType      = GetObjectType(oTarget);
	int  nRacial    = GetRacialType(oTarget);

	
	//SONIC
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_SONIC );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_SONIC );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_SONIC );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	


	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId()));
	effect eCrumb = EffectVisualEffect(VFX_HIT_SPELL_MAGIC);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);

	if (nType != OBJECT_TYPE_CREATURE && nType !=  OBJECT_TYPE_PLACEABLE && nType != OBJECT_TYPE_DOOR )
	{
			return;
	}

	if ( !CSLGetIsConstruct(oTarget, TRUE ) )
	{
			return;
	}

	int iDamage = HkApplyMetamagicVariableMods(d6(iSpellPower), 6 * iSpellPower);
	
	if (iDamage>0)
	{
			//----------------------------------------------------------------------
			// * Sever the tie between spellId and effect, allowing it to
			// * bypass any magic resistance
			//----------------------------------------------------------------------
			DelayCommand(0.1f,DoCrumble(iDamage, oCaster, oTarget, iDamageType));
	}
	
	HkPostCast(oCaster);
}

//------------------------------------------------------------------------------
// This part is moved into a delayed function in order to alllow it to bypass
// Golem Spell Immunity. Magic works by rendering all effects applied
// from within a spellscript useless. Delaying the creation and application of
// an effect causes it to loose it's SpellId, making it possible to ignore
// Magic Immunity. Hacktastic!
//------------------------------------------------------------------------------
void DoCrumble (int nDam, object oCaster, object oTarget, int iDamageType = DAMAGE_TYPE_SONIC)
{
	float  fDist = GetDistanceBetween(oCaster, oTarget);
	float  fDelay = fDist/(3.0 * log(fDist) + 2.0);
	effect eDam = HkEffectDamage(nDam, iDamageType);
	//effect eMissile = EffectVisualEffect(477); // NWN1 VFX
	effect eCrumb = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eCrumb, oTarget);
	DelayCommand(fDelay, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
	//DelayCommand(0.5f, HkApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget)); // NWN1 VFX
}

