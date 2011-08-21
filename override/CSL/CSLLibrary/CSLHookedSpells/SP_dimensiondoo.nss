//::///////////////////////////////////////////////
//:: Dimension Door
//:: SG_S0_DimDoor.nss
//:: 2003 Karl Nickels (Syrus Greycloak)
//:://////////////////////////////////////////////
/*
     You instantly transfer yourself from your current
     location to any other location withing range.
*/
//:://////////////////////////////////////////////
//:: Created By: Karl Nickels (Syrus Greycloak)
//:: Created On: March 31, 2003
//:://////////////////////////////////////////////
//
// 
#include "_HkSpell"

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId(); // put spell constant here
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 4;
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_TRANSMUTATION, SPELL_SUBSCHOOL_TELEPORTATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	location lTeleportTo = HkGetSpellTargetLocation();
	location lTeleportFrom = GetLocation(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	//int iSpellPower = HkGetSpellPower(oCaster, 10);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
	
    
    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFXSC_FNF_BURST_SMALL_SMOKEPUFF);
    effect eVis1    = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

    //--------------------------------------------------------------------------
    //Apply effects
    //--------------------------------------------------------------------------
    if ( CSLGetCanTeleport( oCaster ) )
    {
		lTeleportTo = CSLTeleportationBeam( lTeleportFrom, lTeleportTo, TRUE, TRUE, oCaster ); // this makes sure any triggers are triggered between here and there
		
		if ( lTeleportFrom != lTeleportTo )
		{
			SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_DIMENSION_DOOR, FALSE));
			HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis1, lTeleportTo);
			AssignCommand(oCaster,ClearAllActions());
			AssignCommand(oCaster,ClearAllActions(TRUE));
			
			effect eImpactVis = EffectVisualEffect( iImpactSEF );
			DelayCommand( 1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lTeleportTo) );
		
			// CSLRemoveEffectSpellIdSingle( SC_REMOVE_ALLCREATORS, OBJECT_SELF, oCaster, SPELL_BLACKFLAME );
			AssignCommand(oCaster, ClearAllActions() );
			DelayCommand( 1.5f,  CSLTeleportToLocation( oCaster, lTeleportTo, VFX_HIT_SPELL_CONJURATION ) );
			
			//AssignCommand(oCaster, ClearAllActions() );
			//DelayCommand(1.5f,AssignCommand(oCaster,JumpToLocation(lTeleportTo)));
			//DelayCommand(1.6f,HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTeleportFrom));
		}
	}
	else
	{
		SendMessageToPC( oCaster, "You are Dimensionally Anchored");
	}
    HkPostCast(oCaster);
}


