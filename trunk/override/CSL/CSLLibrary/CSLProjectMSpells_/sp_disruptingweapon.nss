//::///////////////////////////////////////////////
//:: Spell Template
//:: sp_template.nss
//:: 2009 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
Transmutation
Level:	Clr 5
Components:	V, S
Casting Time:	1 standard action
Range:	Touch
Targets:	One melee weapon
Duration:	1 round/level
Saving Throw:	Will negates (harmless, object); see text
Spell Resistance:	Yes (harmless, object)
This spell makes a melee weapon deadly to undead. Any undead creature with HD equal to or less than your caster level must succeed on a Will save or be destroyed utterly if struck in combat with this weapon. Spell resistance does not apply against the destruction effect.

*/
//:://////////////////////////////////////////////
//:: Based on Work of: Author
//:: Created On:
//:://////////////////////////////////////////////

#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iImpactSEF = VFX_HIT_AOE_ACID;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_ARCANE | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_MATERIALCOMP | SCMETA_ATTRIBUTES_FOCUSCOMP | SCMETA_ATTRIBUTES_HOSTILE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	object  oTarget = HkGetSpellTarget();
	
	location lTarget = HkGetSpellTargetLocation();

	int iDuration = HkGetSpellDuration(oCaster);
	int iSpellPower = HkGetSpellPower(oCaster, 10);
	
	int iSaveDC = HkGetSpellSaveDC();
	
	int iDamageType = HkGetDamageType(DAMAGE_TYPE_FIRE);
	int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_FIRE);
	
	float fTargetSize = HkApplySizeMods( RADIUS_SIZE_HUGE );
	int iTargetShape = HkApplyShapeMods( SHAPE_SPHERE );
	
	//--------------------------------------------------------------------------
	// Declare Spell Specific Variables & impose limiting
	//--------------------------------------------------------------------------

	
	//--------------------------------------------------------------------------
	// Resolve Metamagic, if possible
	//--------------------------------------------------------------------------
	int iDamage = HkApplyMetamagicVariableMods( d6(iSpellPower), 6 * iSpellPower );
	float fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iDurType = HkApplyMetamagicDurationTypeMods(DURATION_TYPE_TEMPORARY);
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------
	effect eVis = EffectVisualEffect( HkGetHitEffect(VFX_IMP_FLAME_M) );
	effect eHit;
	
	//--------------------------------------------------------------------------
	// AOE
	//--------------------------------------------------------------------------
	//string sAOETag =  HkAOETag( oCaster, iSpellId, iSpellPower, fDuration, FALSE  );
	//effect eAOE = EffectAreaOfEffect(AOE_PER_FOGACID, "", "", "", sAOETag);
	//DelayCommand( 0.1f, HkApplyEffectAtLocation( iDurType, eAOE, lTarget, fDuration ) );
	
	//--------------------------------------------------------------------------
	// Remove Previous Versions of this spell
	//--------------------------------------------------------------------------
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTarget);
	
	CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, oCaster, oTarget, iSpellId );
	
	
	//--------------------------------------------------------------------------
	// Apply effects
	//--------------------------------------------------------------------------
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eHit, oTarget);
	// Visual
	effect eExplode = EffectVisualEffect( HkGetShapeEffect( VFX_FNF_FIREBALL ) );
	HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
	
	//--------------------------------------------------------------------------
	// Clean up
	//--------------------------------------------------------------------------
	HkPostCast( oCaster );
}

/*

#include "_HkSpell"

void main()
{	
	
object oPC = OBJECT_SELF;
int SaveDC = 15 + GetAbilityModifier(ABILITY_WISDOM,oPC);



		if (SaveDC == 15 || SaveDC == 16)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_16;
		}
else	if (SaveDC == 17 || SaveDC == 18)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_18;
		}
else	if (SaveDC == 19 || SaveDC == 20)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_20;
		}
else	if (SaveDC == 21 || SaveDC == 22)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_22;
		}
else	if (SaveDC == 23 || SaveDC == 24)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_24;
		}
else	if (SaveDC == 25 || SaveDC == 26)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_26;
		}
else	if (SaveDC == 27 || SaveDC == 28)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_28;
		}
else	if (SaveDC == 29 || SaveDC == 30)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_30;
		}
else	if (SaveDC == 31 || SaveDC == 32)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_32;
		}
else	if (SaveDC == 33 || SaveDC == 34)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_34;
		}
else	if (SaveDC == 35 || SaveDC == 36)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_36;
		}
else	if (SaveDC == 37 || SaveDC == 38)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_38;
		}
else	if (SaveDC == 39 || SaveDC == 40)
		{
		SaveDC = IP_CONST_ONHIT_SAVEDC_40;
		}
else	{SaveDC = 15;}
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
	
	int nDuration = FloatToInt(RoundsToSeconds( HkGetCasterLevel(OBJECT_SELF)));

	int nMetaMagic = HkGetMetaMagicFeat();
	if (nMetaMagic == METAMAGIC_EXTEND)
	{
		nDuration = nDuration * 2; //Duration is +100%
	}

	object oMyWeapon 	= GetSpellTargetObject();

	if(GetIsObjectValid(oMyWeapon) )
	{

		if (nDuration > 0)
		{
			itemproperty ipFlame = ItemPropertyOnHitProps(IP_CONST_ONHIT_SLAYRACE, SaveDC, IP_CONST_RACIALTYPE_UNDEAD);
			AddItemProperty(DURATION_TYPE_TEMPORARY,ipFlame,oMyWeapon, IntToFloat(nDuration));
		}
		return;
	}
	else
	{
		FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
		return;
	}
}
*/