//::///////////////////////////////////////////////
//:: x0_s3_clonefist
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
	Create a fiery version of the character
	to help them fight.
*/
#include "_HkSpell"
//#include "nw_i0_generic"
#include "_CSLCore_Player"
#include "_CSLCore_Combat"
#include "_SCInclude_Evocation"

void FakeHB(int nExplode=0, int iDamageType = DAMAGE_TYPE_FIRE)
{
	effect eFlame = EffectVisualEffect(VFX_IMP_FLAME_M);
	HkApplyEffectToObject(DURATION_TYPE_INSTANT, eFlame, OBJECT_SELF);
	object oMaster = GetLocalObject(OBJECT_SELF, "X0_L_MYMASTER");
	if (nExplode==4)
	{
		ClearAllActions();
		PlayVoiceChat(VOICE_CHAT_GOODBYE);
		effect eFirePro = EffectDamageResistance(iDamageType, 9999,0);
		HkApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFirePro, oMaster, 3.5);
		ActionCastSpellAtLocation( SPELL_FIREBALL, GetLocation(OBJECT_SELF), METAMAGIC_ANY, TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
		SCEffectFireBall( GetLocation(OBJECT_SELF), GetHitDice(OBJECT_SELF), iDamageType );
		DestroyObject(OBJECT_SELF, 0.5);
		SetCommandable(FALSE);
		return;
	}
	else
	{
		object oEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oMaster, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
		// error with function on this line
		if (GetIsObjectValid(oEnemy))
		{
			//DetermineCombatRound(oEnemy);  // * attack my master's enemy
			CSLDetermineCombatRound( OBJECT_SELF, oEnemy );
		}
		ActionMoveToObject(GetLocalObject(OBJECT_SELF, "X0_L_MYMASTER"), TRUE);
		DelayCommand(5.0, FakeHB(nExplode + 1, iDamageType ));
	}
}

void main()
{
	//--------------------------------------------------------------------------
	//Prep the spell
	//--------------------------------------------------------------------------
	object oCaster = OBJECT_SELF;
	int iSpellId = HkGetSpellId();
	int iClass = CLASS_TYPE_NONE;
	int iSpellLevel = 1;
	int iAttributes = SCMETA_ATTRIBUTES_MAGICAL | SCMETA_ATTRIBUTES_SOMANTICCOMP | SCMETA_ATTRIBUTES_TURNABLE | SCMETA_ATTRIBUTES_CANTCASTINTOWN;
	//--------------------------------------------------------------------------
	//Run Precast Code
	//--------------------------------------------------------------------------
	if (!HkPreCastHook( oCaster, iSpellId, SCMETA_DESCRIPTOR_FIRE, iClass, iSpellLevel, SPELL_SCHOOL_GENERAL, SPELL_SUBSCHOOL_NONE, iAttributes ) )
	{
		return;
	}

	//--------------------------------------------------------------------------
	//Declare major variables
	//--------------------------------------------------------------------------
	
	//FIRE
	//--------------------------------------------------------------------------
	// Elemental Damage Modifiers
	//--------------------------------------------------------------------------
	int iSaveType = HkGetSaveType( SAVING_THROW_TYPE_FIRE );
	int iShapeEffect = HkGetShapeEffect( VFX_DUR_ELEMENTAL_SHIELD, SC_SHAPE_NONE ); 
	int iHitEffect = HkGetHitEffect( VFX_HIT_SPELL_FIRE );
	int iDamageType = HkGetDamageType( DAMAGE_TYPE_FIRE );
	
	
	//--------------------------------------------------------------------------
	// Effects
	//--------------------------------------------------------------------------	
	
	string sTag = CSLGetCreatureIdentifier(oCaster) + "_FLAMETWIN";
	object oFireGuy = GetNearestObjectByTag(sTag);
	if (oFireGuy!=OBJECT_INVALID)
	{
		SendMessageToPC(oCaster, "You already have a hot twin.");
		return;
	}
	oFireGuy = CopyObject(oCaster, GetLocation(OBJECT_SELF), OBJECT_INVALID, sTag);
	oFireGuy = GetNearestObjectByTag(sTag);
	SetLocalObject(oFireGuy, "X0_L_MYMASTER", oCaster);
	ChangeToStandardFaction(oFireGuy, STANDARD_FACTION_COMMONER);
	SetPCLike(oCaster, oFireGuy);
	DelayCommand(0.5, SetPlotFlag(oFireGuy, TRUE)); // * so items don't drop, I can destroy myself.
	AssignCommand(oFireGuy, FakeHB( 0, iDamageType ));
	
	
	
	
	effect eVis = EffectVisualEffect( iShapeEffect );
	HkApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oFireGuy);
	
	HkPostCast(oCaster);
}