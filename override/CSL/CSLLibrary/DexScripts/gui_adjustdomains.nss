void main( string sDeity  )
{	
	object oChar = OBJECT_SELF;
	SendMessageToPC(oChar, "Running Script for "+sDeity);
	SpeakString("Running Script for "+sDeity);
	
	SetGUIObjectDisabled( oChar,"SCREEN_CHARGEN_DOMAIN", "DOMAIN_ACTION", TRUE );
	
	SetGUIObjectDisabled( oChar,"SCREEN_CHARGEN_DOMAIN", "DOMAIN_ACTION:5", TRUE );
	SetGUIObjectDisabled( oChar,"SCREEN_CHARGEN_DOMAIN", "DOMAIN_ACTION:8", TRUE );
	SetGUIObjectDisabled( oChar,"SCREEN_CHARGEN_DOMAIN", "DOMAIN_ACTION:10", TRUE );
	SetGUIObjectDisabled( oChar,"SCREEN_CHARGEN_DOMAIN", "DOMAIN_ACTION", TRUE );
	
	SetGUIObjectHidden( oChar,"SCREEN_CHARGEN_DOMAIN", "DOMAINPANE_WAR", TRUE );
	
}