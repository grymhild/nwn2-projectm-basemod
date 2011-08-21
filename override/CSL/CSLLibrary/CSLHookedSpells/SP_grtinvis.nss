///::///////////////////////////////////////////////
//:: Greater Invisibility
//:: NW_S0_GrtrInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Target creature can attack and cast spells while
	invisible
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



#include "_SCInclude_Invisibility"



void main()
{
	//scSpellMetaData = SCMeta_SP_grtinvis();
	
	if ( GetHasSpellEffect( SPELL_INVISIBILITY_PURGE, HkGetSpellTarget() ))
	{
		// Cannot be cast when in a purge AOE
		SendMessageToPC(OBJECT_SELF, "Invisibility was Purged");
		return;
	}
	
	if ( GetHasSpellEffect( SPELL_GLITTERDUST, HkGetSpellTarget() ))
	{
		// Cannot be cast when in a purge AOE
		SendMessageToPC(OBJECT_SELF, "Glitterdust Blocks Invisibility");
		return;
	}
	
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_GREATER_INVISIBILITY;
	int iClass = CLASS_TYPE_NONE;
	if ( GetSpellId() == SPELL_ASN_ImprovedInvisibility || GetSpellId() == SPELL_ASN_Spellbook_4 )
	{
		CLASS_TYPE_ASSASSIN;
	}
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
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
	
	
	
	object oTarget = HkGetSpellTarget();
	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	
	float fDuration = HkApplyMetamagicDurationMods( TurnsToSeconds( HkGetSpellDuration( oCaster ) ) );

	SCApplyInvisibility( oTarget, oCaster, fDuration, SPELL_GREATER_INVISIBILITY, 50 );
	
	float fDurationLeft = fDuration - F_DELAY;
	DelayCommand(F_DELAY, SCReapplyCanceledInvisibility(oTarget, fDurationLeft, SPELL_GREATER_INVISIBILITY ) );
	
	HkPostCast(oCaster);
}

