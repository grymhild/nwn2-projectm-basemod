// Causes target to explode damaging those nearby as they self destruct ( guaranteed death )

#include "_HkSpell"
#include "_SCInclude_Effects"

#include "_SCInclude_Evocation"
//#include "_SCInclude_Necromancy"
//#include "_SCInclude_Summon"


void main()
{
	//string sDeathScript = GetLocalString(OBJECT_SELF, "DeathScript");
	object oTarget = CSLGetEffectTargetObject(OBJECT_SELF);
	int iHitDice = CSLGetEffectHitDice(5);
	int iDamageType = CSLGetEffectDamageType( DAMAGE_TYPE_FIRE );
	
	location lTarget;
	
	if ( GetIsObjectValid( oTarget ) )
	{
		lTarget = GetLocation( oTarget );

		effect e2 = EffectVisualEffect( VFX_DUR_CUTSCENE_INVISIBILITY ); // make target disappear
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, e2, OBJECT_SELF);
	}
	else
	{
		lTarget = CSLGetEffectTargetLocation();
		oTarget = OBJECT_INVALID;
	}
	
	SCEffectFireBall( lTarget, iHitDice, iDamageType, oTarget );
	
	CSLPostEffect();
}