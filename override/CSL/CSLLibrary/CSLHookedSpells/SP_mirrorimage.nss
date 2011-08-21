//::///////////////////////////////////////////////
//:: Mirror Image
//:: NW_S0_MirrorImg.nss
//:://////////////////////////////////////////////
/*
	Caster gains 1d4 + 1/Level Images (max 8) that
	block damage from you on a chance AC 10 + Dex mod.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"




//#include "ginc_debug"

void main()
{
	//scSpellMetaData = SCMeta_SP_mirrorimage();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_MIRROR_IMAGE;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_BUFF | SCMETA_ATTRIBUTES_TURNABLE;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_ILLUSION, SPELL_SUBSCHOOL_FIGMENT, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	object oTarget = HkGetSpellTarget();
	CSLUnstackSpellEffects(oTarget, GetSpellId());
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	float fDuration = HkApplyMetamagicDurationMods(TurnsToSeconds( HkGetSpellDuration( oCaster ) ));
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	int iBonus = CSLGetMin(15, iSpellPower) / 3;
	int nACBonus = 2 + iBonus;
	int nImages = CSLGetMin(8, HkApplyMetamagicVariableMods(d4(1) + iBonus, 4 + iBonus)); //Determine images created, max 8
	SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));


	float fSpin = 1.5 / nImages;
	float fDelay = 0.0;
	int i;
	for (i=0; i<nImages; i++) {
		effect eLink = EffectVisualEffect(VFX_DUR_SPELL_MIRROR_IMAGE_SELF);
		eLink = EffectLinkEffects(eLink, EffectAbsorbDamage(nACBonus));
		eLink = EffectLinkEffects(eLink, EffectNWN2SpecialEffectFile("sp_mirror_image_1.sef", oCaster));
		eLink = EffectLinkEffects(eLink, EffectOnDispel(0.0f, CSLRemoveEffectSpellIdSingle_Void( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oTarget, SPELL_MIRROR_IMAGE)));
		DelayCommand(fDelay, HkApplyEffectToObject(iDurType, eLink, oTarget, fDuration, SPELL_MIRROR_IMAGE ) );
		fDelay += fSpin;
	}
	
	HkPostCast(oCaster);
}

