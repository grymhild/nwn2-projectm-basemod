//::///////////////////////////////////////////////
//:: [Dominate Person]
//:: [NW_S0_DomPers.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is dominated for 1 round
//:: per caster level.
//:://////////////////////////////////////////////

/////////////////////////////////////////////////////
//////////////// Includes //////////////////////////
////////////////////////////////////////////////////
#include "_HkSpell"



////#include "_inc_helper_functions"
//#include "_SCUtility"

void main()
{
	//scSpellMetaData = SCMeta_SP_domperson();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = SPELL_DOMINATE_PERSON;
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_MIND, iClass, iSpellLevel, SPELL_SCHOOL_ENCHANTMENT, SPELL_SUBSCHOOL_COMPULSION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	


	
	//int iSpellPower = HkGetSpellPower( oCaster ); // OldGetCasterLevel(oCaster);
	object oTarget = HkGetSpellTarget();
	SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DOMINATE_PERSON));
	//Make sure the target is a monster
	if (CSLSpellsIsTarget(oTarget, SCSPELL_TARGET_STANDARDHOSTILE, oCaster))
	{
		if (CSLGetIsHumanoid(oTarget))
		{
			if (!HkResistSpell(oCaster, oTarget))
			{
				if (!HkSavingThrow(SAVING_THROW_WILL, oTarget, HkGetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS))
				{
					effect eLink = EffectVisualEffect(VFX_DUR_SPELL_DOM_PERSON);
					eLink = EffectLinkEffects(eLink, HkGetScaledEffect(EffectDominated(), oTarget));
					int iDuration = 3 + HkGetSpellDuration( oCaster )/4;
					float fDuration;
					if (GetIsPC(oTarget) || GetLocalInt(oTarget, "BOSS"))
					{
						fDuration = HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS);
					}
					else
					{
						fDuration = HkApplyDurationCategory(iDuration * 2, SC_DURCATEGORY_MINUTES);
					}
					fDuration = HkApplyMetamagicDurationMods( fDuration );
					if (!GetIsPC(oTarget))
					{
						CSLRemoveEffectByType(oTarget, EFFECT_TYPE_DOMINATED);              
						SetLastName(oTarget, "(*" + GetName(oCaster) + "*)");
						SetLocalObject(oTarget, "DOMINATED", oCaster);
						//DeleteLocalInt( oTarget, "SCSummon" );
					}
					HkUnstackApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, HkGetSpellId() );       
				}
			}
		}
	}
	
	HkPostCast(oCaster);
}
