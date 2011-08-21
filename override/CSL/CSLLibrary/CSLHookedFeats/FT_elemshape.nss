//::///////////////////////////////////////////////
//:: Elemental Shape
//:: NW_S2_ElemShape
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Allows the Druid to change into elemental forms.
*/
#include "_HkSpell"
#include "_SCInclude_Polymorph"


void main()
{
	//scSpellMetaData = SCMeta_FT_elemshape();
	//if (!X2PreSpellCastCode()) { return; }  // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = HkGetSpellLevel( iSpellId, iClass );
	int iAttributes = SCMETA_ATTRIBUTES_SUPERNATURAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE;
	
	int iDescriptor = CSLPickOneInt(SCMETA_DESCRIPTOR_FIRE, SCMETA_DESCRIPTOR_EARTH, SCMETA_DESCRIPTOR_AIR, SCMETA_DESCRIPTOR_WATER );

	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, iDescriptor, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	

	if (!GetHasFeat(FEAT_WILD_SHAPE, OBJECT_SELF))
	{
			SpeakStringByStrRef(SCSTR_REF_FEEDBACK_NO_MORE_FEAT_USES);
			return;
	}
	
	if (GetHasSpellEffect(SPELL_Plant_Body))	
	{
		SendMessageToPC(OBJECT_SELF, "Wildshape failed.  The spell Plant Body prevents shifting forms.");
		int nFeatId = GetSpellFeatId();
		IncrementRemainingFeatUses(OBJECT_SELF, nFeatId);
		return;
	}
	
	
	
	if( CSLGetPreferenceSwitch("UnlimitedWildshapeUses",FALSE) )
	{
		// int nFeatId = GetSpellFeatId();
		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_ELEMENTAL_SHAPE);
	}
	
	int nSpell = GetSpellId();
	if ( nSpell != 397 && nSpell != 398 && nSpell != 399 && nSpell != 400) // spells other than this one are not linked so fix manually
	{
		DecrementRemainingFeatUses(OBJECT_SELF, 304);
	}
	
	/*
	if ( GetSpellId() == 400 )
	{
		//SendMessageToPC(OBJECT_SELF, "Wildshape Elder air.");

		object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
		if (GetIsObjectValid(oWeapon))
    	{
			if( GetBaseItemType(oWeapon) == BASE_ITEM_SLING )
			{
				SendMessageToPC(OBJECT_SELF, "Wildshape failed.  This is to block a crash from happening, try without a sling.");
				return;
			}
		}
	}
	*/
	
	
	int iLevel = CSLGetWildShapeLevel(oCaster);
	int bElder = ( iLevel >= 20 );
	float fDuration = HoursToSeconds(iLevel);
	PolyMerge(oCaster, SPELLABILITY_ELEMENTAL_SHAPE, fDuration, bElder, TRUE, TRUE);
	
	HkPostCast(oCaster);

}