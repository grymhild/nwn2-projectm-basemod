//::///////////////////////////////////////////////
//:: Quillfire
//:: [x0_s0_quillfire.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Fires a cluster of quills at a target. Ranged Attack.
	2d8 + 1 point /2 levels (max 5)
	
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 02, 2003

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"

void main()
{
	//scSpellMetaData = SCMeta_SP_quillfire();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_QUILLFIRE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_ACID|SCMETA_DESCRIPTOR_POISON, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iDC = HkGetSpellSaveDC();
	
	//Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
	object oTarget = HkGetSpellTarget();
	//int iSpellPower = HkGetSpellPower( OBJECT_SELF ); // OldGetCasterLevel(OBJECT_SELF);
	int iDamage = 0;
	int nCnt;
	effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
	{
		//Fire cast spell at event for the specified target
		SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_QUILLFIRE));
		//Apply a single damage hit for each missile instead of as a single mass
		int iDamage = HkApplyMetamagicVariableMods(d8(1), 8);

		//* apply bonus damage for level
		int iBonus = HkGetSpellPower(OBJECT_SELF, 10) / 2;
		
		iDamage = iDamage + iBonus;
		int nSave = HkSavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_POISON, OBJECT_SELF );
		if( !nSave)
		{
			// * also applies poison damage
			effect ePoison = EffectPoison(POISON_LARGE_SCORPION_VENOM);
			HkApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
		}
		
		iDamage = HkGetSaveAdjustedDamage( SAVING_THROW_FORT, SAVING_THROW_METHOD_FORFULLDAMAGE, iDamage, oTarget, iDC, SAVING_THROW_TYPE_POISON, oCaster, nSave );
		//else
		//{
		//	iDamage = iDamage/2;
		//{
		if ( iDamage > 0 )
		{
			effect eDam = HkEffectDamage(iDamage, DAMAGE_TYPE_MAGICAL);
			HkApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
		}
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget);
	}
	
	HkPostCast(oCaster);
}

