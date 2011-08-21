//::///////////////////////////////////////////////
//:: Holy Aura
//:: NW_S0_HolyAura.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	The cleric casting this spell gains +4 AC and
	+4 to saves. Is immune to Mind-Affecting Spells
	used by evil creatures and gains an SR of 25
	versus the spells of Evil Creatures
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 28, 2001
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"
#include "_SCInclude_Abjuration"


void main()
{

	//scSpellMetaData = SCMeta_SP_holyaura();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_HOLY_AURA;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_GOOD, iClass, iSpellLevel, SPELL_SCHOOL_ABJURATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	//--------------------------------------------------------------------------
	// GZ: Make sure this aura is only active once
	//--------------------------------------------------------------------------
	//SCRemoveSpellEffects(GetSpellId(),OBJECT_SELF,HkGetSpellTarget());
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ONLYCREATOR, OBJECT_SELF, HkGetSpellTarget(), GetSpellId() );


	//SCdoAura(ALIGNMENT_EVIL, VFX_HIT_SPELL_ABJURATION, VFX_DUR_PROTECTION_GOOD_MAJOR, DAMAGE_TYPE_DIVINE); // NWN1 VFX
	SCdoAura(ALIGNMENT_EVIL, VFX_DUR_SPELL_GOOD_AURA, VFX_NONE, DAMAGE_TYPE_DIVINE, GetSpellId() ); // NWN2 VFX
	
	HkPostCast(oCaster);
}

