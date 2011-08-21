
/*
Corona of Cold
Sean Harrington
11/10/07
#1363
*/
//#include "nw_i0_spells"
//#include "x2_inc_spellhook"
//#include "nwn2_inc_metmag"


#include "_HkSpell"

void main()
{	
	
	/*
		Spellcast Hook Code
		Added 2003-07-07 by Georg Zoeller
		If you want to make changes to all spells,
		check x2_inc_spellhook.nss to find out more

	*/
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellSchool = SPELL_SCHOOL_NONE;
	int iSpellSubSchool = SPELL_SUBSCHOOL_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_NONE, SPELL_SUBSCHOOL_NONE ) )
	{
		return;
	}
	
	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//Also prevent stacking

	object	oCaster		=	OBJECT_SELF;
	string	sSelf		=	ObjectToString(oCaster) + IntToString(HkGetSpellId());
	object	oSelf		=	GetNearestObjectByTag(sSelf);
	effect	eAOE		=	EffectAreaOfEffect(AOE_PER_AURA_OF_COURAGE, "nw_sh_null_script", "nw_sh_corona_of_coldb", "nw_sh_null_script", sSelf);
	effect 	eVis		=	EffectVisualEffect(VFX_DUR_SPELL_CREEPING_COLD);
	float	fDuration	=	RoundsToSeconds(HkGetCasterLevel(oCaster));
	effect	eResist		=	EffectDamageResistance(DAMAGE_TYPE_FIRE,10,0);
//Link effects
	effect	eLink		=	EffectLinkEffects(eAOE, eVis);
			eLink		=	EffectLinkEffects(eLink, eResist);
//Destroy the object if it already exists before creating a new one

	if (GetIsObjectValid(oSelf))
	{
		DestroyObject(oSelf);
	}

//Determine duration
			fDuration	=	HkApplyMetamagicDurationMods(fDuration);

//Generate the object
	HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, fDuration);
	//HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, fDuration);
}