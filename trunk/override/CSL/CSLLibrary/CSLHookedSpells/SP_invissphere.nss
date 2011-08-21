//::///////////////////////////////////////////////
//:: Invisibility Sphere
//:: NW_S0_InvSph.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	All allies within 15ft are rendered invisible.
*/

#include "_HkSpell"
/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_SCInclude_Invisibility"




void main()
{
	//scSpellMetaData = SCMeta_SP_invissphere();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_INVISIBILITY_SPHERE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_GLAMER, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------

	if ( GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, HkGetSpellTarget() ))
	{
		// Cannot be cast when in a purge AOE
		SendMessageToPC( oCaster, "Invisibility Purge Prevents Invisibility");
		return;
	}
	
	float fRadius = HkApplySizeMods(RADIUS_SIZE_LARGE);
	
	
	int iSpellPower = HkGetSpellPower( oCaster );
	
	
	// int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster ) ));
	
	effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);

	//string sAOETag =  HkAOETag( oCaster, GetSpellId(), iSpellPower, fDuration, FALSE  );
	//effect eAOE = EffectLinkEffects(eInvis, EffectAreaOfEffect(AOE_PER_INVIS_SPHERE, "", "", "", sAOETag));
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, oCaster, fDuration);
	
	location lCenter = GetLocation(oCaster);
	object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lCenter);
	while (GetIsObjectValid(oTarget))
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_ALLALLIES, oCaster) && oTarget!= oCaster)
		{
			DelayCommand( 0.5f, SCApplyInvisibility( oTarget, oCaster, 0.0f, iSpellId, 0, TRUE ) );

			//SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_INVISIBILITY_SPHERE, FALSE));
			//HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eInvis, oTarget);
			//if ( GetIsPC(oTarget) && GetLocalInt( GetModule(), "SC_MPINVISFIX" ) )
			//{
			//	SetInvisible(oTarget, fDuration);
			//}
		}
		oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lCenter);
	}
	
	HkPostCast(oCaster);
}