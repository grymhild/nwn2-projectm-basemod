//::///////////////////////////////////////////////
//:: Mordenkainen's Magnificent Mansion
//:: sg_s0_mordmans.nss
//:: Player Resource Consortium
//:://////////////////////////////////////////////
/*
Copied from Player Resource Consortium
*/
//:://////////////////////////////////////////////
//:: Adapted By: Karl Nickels (Syrus Greycloak)
//:: Adapted On: March 7, 2006
//:://////////////////////////////////////////////
//
// 
// void main()
// {
//
//     int     iMetamagic      = HkGetMetaMagicFeat();
// 
// 
//     //--------------------------------------------------------------------------
//     // Spellcast Hook Code
//     // Added 2003-06-20 by Georg
//     // If you want to make changes to all spells, check x2_inc_spellhook.nss to
//     // find out more
//     //--------------------------------------------------------------------------
//     if (!X2PreSpellCastCode())
//     {
//         return;
//     }
    // End of Spell Cast Hook
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
	int iImpactSEF = VFX_HIT_SPELL_CONJURATION;
	int iAttributes = SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_VOCALCOMP | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_NONE, iClass, iSpellLevel, SPELL_SCHOOL_CONJURATION, SPELL_SUBSCHOOL_CREATION, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	int iCasterLevel = HkGetCasterLevel(oCaster);
	//object  oTarget = HkGetSpellTarget();
	//int iDC = HkGetSpellSaveDC(oCaster, oTarget);
	//int iMetamagic = HkGetMetaMagicFeat();
	location lTarget = HkGetSpellTargetLocation();
	int iDuration = HkGetSpellDuration( oCaster, 30 );
	float   fDuration = HkApplyMetamagicDurationMods( HkApplyDurationCategory(iDuration, SC_DURCATEGORY_ROUNDS) );
	int iSpellPower = HkGetSpellPower(oCaster, 12);
	//int iDamageType = HkGetDamageType(DAMAGE_TYPE_NONE);
	//int iSaveType = HkGetSaveType(SAVING_THROW_TYPE_NONE);
	//int iSaveDC = HkGetSpellSaveDC();
	
    object  oCasterArea     = GetArea(oCaster);


    //--------------------------------------------------------------------------
    // Effects
    //--------------------------------------------------------------------------
    effect eVis     = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
 
    	
	//--------------------------------------------------------------------------
	//Apply effects
	//--------------------------------------------------------------------------
	location lImpactLoc = HkGetSpellTargetLocation(); // GetLocation( oCreator );
	effect eImpactVis = EffectVisualEffect( iImpactSEF );
	ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpactVis, lImpactLoc);

    if( GetTag(oCasterArea) != "CSLMordMansion" ) // don't let them do it inside a mansion, need a kick everyone out script
    {
        SignalEvent(oCaster, EventSpellCastAt(oCaster, SPELL_MORDS_MAG_MANSION));
        HkApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lTarget);
		// GetArea
        // Create the mansion doorway and save the caster on the door so we know who to let in.
        // Only people in the caster's party get to go into the mansion.        
        object oPortal = GetObjectByTag("SP_mordsmansion_"+IntToString(ObjectToInt(oCaster)));
		if ( GetIsObjectValid( oPortal ) )
		{
			// destroy portals created by this caster
			// note i have not set up support for multiple mansions yet
			DestroyObject( oPortal, 0.0f, FALSE );
		}
		
		// sp_mordsmansion_entrance is the name of the script on the portal object
		oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, "SP_mordsmansion_portal", lTarget, TRUE, "SP_mordsmansion_"+IntToString(ObjectToInt(oCaster)) );
		if (GetIsObjectValid(oPortal))
        {
            SetLocalInt(oPortal, "USES", iSpellPower);
			
			SetLocalObject(oPortal, "MANSION_CASTER", oCaster);
            HkApplyEffectToObject(DURATION_TYPE_PERMANENT, 
			EffectVisualEffect(VFX_DUR_GLOW_WHITE), oPortal);
			
			// destroy it after a given duration
			DelayCommand( 2.0f+d3(), DestroyObject( oPortal, 0.0f, FALSE ) );
        }
    }

    HkPostCast(oCaster);
}