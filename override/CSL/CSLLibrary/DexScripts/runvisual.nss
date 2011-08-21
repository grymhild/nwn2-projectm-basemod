void main( string sVisual = "" )
{
	effect eVis = EffectVisualEffect( StringToInt( sVisual ) );
	ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eVis, GetLocation( GetFirstPC() ) );
}