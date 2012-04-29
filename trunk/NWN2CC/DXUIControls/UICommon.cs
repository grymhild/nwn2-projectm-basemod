using System;
using System.Windows.Forms;
using AvengersUTD.Odyssey.UserInterface.RenderableControls;

namespace AvengersUTD.Odyssey.UserInterface
{
    public delegate void MouseEventHandler(BaseControl ctl, MouseEventArgs args);
    public delegate void KeyEventHandler(BaseControl ctl, KeyEventArgs args);
    public delegate void ControlEventHandler(BaseControl ctl);

    public enum Alignment
    {
        Left,
        Center,
        Right,
        Top,
        Bottom
    }

    public enum BorderStyle
    {
        None,
        Flat,
        Raised,
        Sunken,
    }

    public enum Shape : int
    {
        None = 0,
        Custom,
        Rectangle,
        Circle,
        LeftTrapezoidUpside,
        LeftTrapezoidDownside,
        RightTrapezoidUpside,
        RightTrapezoidDownside
    }

    [Flags]
    public enum Border : int
    {
        None = 0,
        Top = 1,
        Bottom = 2,
        Left = 4,
        Right = 8,
        All = Top | Bottom | Left | Right
    }

    public enum LabelSize
    {
        Small,
        Normal,
        Large,
        VeryLarge,
        Huge
    }
}