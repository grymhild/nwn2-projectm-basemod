//::///////////////////////////////////////////////
//:: [Control Undead]
//:: [NW_S0_ConUnd.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
	A single undead with up to 3 HD per caster level
	can be dominated.
*/

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"


////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_contundead();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_CONTROL_UNDEAD;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_DIVINE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NECROMANCY, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	
	
	int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	if ( CSLGetIsUndead( oTarget )  && GetHitDice(oTarget) <= iSpellPower*2)
	{
		if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
		{
			SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_CONTROL_UNDEAD));
			if (!HkResistSpell(oCaster, oTarget))
			{
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oCaster, 1.0))
				{
					int iDuration = 3 + HkGetSpellDuration( oCaster )/4;
					float fDuration;
					if (GetLocalInt(oTarget, "BOSS"))
					{
						fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);
					}
					else
					{
						fDuration = HkApplyDurationCategory(iDuration * 2, SC_DURCATEGORY_HOURS);
					}
					fDuration = HkApplyMetamagicDurationMods(fDuration);
					int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);

					effect eControl = EffectVisualEffect(VFX_DUR_SPELL_CONTROL_UNDEAD);
					eControl = EffectLinkEffects(eControl, HkGetScaledEffect(EffectDominated(), oTarget));
					if (!GetIsPC(oTarget))
					{
						CSLRemoveEffectByType(oTarget, EFFECT_TYPE_DOMINATED);         
						SetLastName(oTarget, "(*" + GetName(oCaster) + "*)");
						SetLocalObject(oTarget, "DOMINATED", oCaster);
						//DeleteLocalInt( oTarget, "SCSummon" );
					}
					DelayCommand(1.0, HkApplyEffectToObject( iDurType, eControl, oTarget, fDuration));         
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}

