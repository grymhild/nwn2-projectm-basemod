//::///////////////////////////////////////////////
//:: Hellish Inferno
//:: x0_s0_inferno.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	NPC only spell for yaron

	like normal inferno but lasts only 5 rounds,
	ticks twice per round, Adds attack and damage
	penalty.

*/
//:://////////////////////////////////////////////
// Georg Z, 19-10-2003
//:://////////////////////////////////////////////


/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"



void RunHellInfernoImpact(object oTarget, object oCaster, int iDamageType, int nRoundsLeft = 10);

void main()
{
	//scSpellMetaData = SCMeta_FT_hellinferno();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 9;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	object oTarget = HkGetSpellTarget();

	//--------------------------------------------------------------------------
	// This spell no longer stacks. If there is one hand, that's enough
	//--------------------------------------------------------------------------
	if (GetHasSpellEffect(GetSpellId(),oTarget))
	{
			FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
			return;
	}

	
	//--------------------------------------------------------------------------
	// Calculate the duration
	//--------------------------------------------------------------------------
	int iDuration = CSLGetMax( 1, HkGetSpellDuration(OBJECT_SELF, 12)/2 );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	
	
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	//int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	//int iShapeEffect = HkGetShapeEffect( VFX_FNF_NONE, SC_SHAPE_BEAM ); 
	//int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	effect eRay = EffectBeam(444,OBJECT_SELF,BODY_NODE_CHEST);

	SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

	float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/13;

	if(!HkResistSpell(OBJECT_SELF, oTarget))
	{
			
			//----------------------------------------------------------------------
			// Engulf the target in flame
			//----------------------------------------------------------------------
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 3.0f);
			effect eAttackDec = EffectAttackDecrease(4);
			effect eDamageDec = EffectDamageDecrease(4);
			effect eLink = EffectLinkEffects(eAttackDec, eDamageDec);
			
			effect eDur = EffectVisualEffect(498);
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
			DelayCommand(fDelay,HkApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget, fDuration, 762));
			
			object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
			DelayCommand( fDelay, RunHellInfernoImpact(oTarget, oSelf, iDamageType ) );
	}
	else
	{
			//----------------------------------------------------------------------
			// Indicate Failure
			//----------------------------------------------------------------------
			HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0f);
			effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
			DelayCommand(fDelay+0.3f,HkApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
	}
	
	HkPostCast(oCaster);
}


void RunHellInfernoImpact(object oTarget, object oCaster, int iDamageType, int nRoundsLeft = 10)
{

	if ( nRoundsLeft > 0 && GetIsObjectValid(oTarget) && !GetIsDead(oTarget) &&  GetHasSpellEffect(762, oTarget) )
	{
		effect eDam  = EffectDamage(d6(2), iDamageType);
		effect eDam2 = EffectDamage(d6(1), DAMAGE_TYPE_DIVINE);
		effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
		eDam = EffectLinkEffects(eVis,eDam); // flare up
		HkApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
		HkApplyEffectToObject (DURATION_TYPE_INSTANT,eDam2,oTarget);
		nRoundsLeft++;
		DelayCommand(3.0f,RunHellInfernoImpact(oTarget,oCaster, iDamageType, nRoundsLeft ));
	}
}