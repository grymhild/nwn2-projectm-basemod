//::///////////////////////////////////////////////
//:: Spell Template
//:: sp_template.nss
//:: 2009 Brian Meyer (Pain) 
//:://////////////////////////////////////////////
/*
Transmutation
Level:	Brd 2, Sor/Wiz 2
Components:	V, S
Casting Time:	1 standard action
Range:	Personal
Target:	You
Duration:	10 min./level (D)
You assume the form of a creature of the same type as your normal form. The new form must be within one size category of your normal size. The maximum HD of an assumed form is equal to your caster level, to a maximum of 5 HD at 5th level. You can change into a member of your own kind or even into yourself.
You retain your own ability scores. Your class and level, hit points, alignment, base attack bonus, and base save bonuses all remain the same. You retain all supernatural and spell-like special attacks and qualities of your normal form, except for those requiring a body part that the new form does not have (such as a mouth for a breath weapon or eyes for a gaze attack).
You keep all extraordinary special attacks and qualities derived from class levels, but you lose any from your normal form that are not derived from class levels.
If the new form is capable of speech, you can communicate normally. You retain any spellcasting ability you had in your original form, but the new form must be able to speak intelligibly (that is, speak a language) to use verbal components and must have limbs capable of fine manipulation to use somatic or material components.
You acquire the physical qualities of the new form while retaining your own mind. Physical qualities include natural size, mundane movement capabilities (such as burrowing, climbing, walking, swimming, and flight with wings, to a maximum speed of 120 feet for flying or 60 feet for nonflying movement), natural armor bonus, natural weapons (such as claws, bite, and so on), racial skill bonuses, racial bonus feats, and any gross physical qualities (presence or absence of wings, number of extremities, and so forth). A body with extra limbs does not allow you to make more attacks (or more advantageous two-weapon attacks) than normal.
You do not gain any extraordinary special attacks or special qualities not noted above under physical qualities, such as darkvision, low-light vision, blindsense, blindsight, fast healing, regeneration, scent, and so forth.
You do not gain any supernatural special attacks, special qualities, or spell-like abilities of the new form. Your creature type and subtype (if any) remain the same regardless of your new form. You cannot take the form of any creature with a template, even if that template doesn’t change the creature type or subtype.
You can freely designate the new form’s minor physical qualities (such as hair color, hair texture, and skin color) within the normal ranges for a creature of that kind. The new form’s significant physical qualities (such as height, weight, and gender) are also under your control, but they must fall within the norms for the new form’s kind. You are effectively disguised as an average member of the new form’s race. If you use this spell to create a disguise, you get a +10 bonus on your Disguise check.
When the change occurs, your equipment, if any, either remains worn or held by the new form (if it is capable of wearing or holding the item), or melds into the new form and becomes nonfunctional. When you revert to your true form, any objects previously melded into the new form reappear in the same location on your body they previously occupied and are once again functional. Any new items you wore in the assumed form and can’t wear in your normal form fall off and land at your feet; any that you could wear in either form or carry in a body part common to both forms at the time of reversion are still held in the same way. Any part of the body or piece of equipment that is separated from the whole reverts to its true form.

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