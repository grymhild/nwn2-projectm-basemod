void main()
    {
    object oDoor;

    oDoor=OBJECT_SELF;

    DelayCommand(10.0, ActionCloseDoor(OBJECT_SELF));
    }