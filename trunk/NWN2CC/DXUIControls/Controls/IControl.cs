using System.Drawing;
using System.Windows.Forms;
using Microsoft.DirectX;

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{
    public interface IControl
    {
        string ID { get; }
        Size Size { get; }

        bool IsVisible { get; set; }
        bool IsEnabled { get; set; }
        bool IsFocused { get; }
        bool IsSelected { get; set; }

        void Focus();

        BaseControl Parent { get; set; }

        Vector2 Position { get; set; }
        Vector2 AbsolutePosition { get; }

        bool IntersectTest(Point cursorLocation);

        bool ProcessMouseMovement(MouseEventArgs mouseEvent);
        bool ProcessMousePress(MouseEventArgs mouseEvent);
        bool ProcessMouseRelease(MouseEventArgs mouseEvent);

        event MouseEventHandler MouseDown;
        event MouseEventHandler MouseClick;
        event MouseEventHandler MouseUp;
        event MouseEventHandler MouseMove;
        event MouseEventHandler MouseEnter;
        event MouseEventHandler MouseCaptureChanged;
        event MouseEventHandler MouseLeave;
        event MouseEventHandler MouseScroll;
        event KeyEventHandler KeyDown;
        event KeyPressEventHandler KeyPress;
        event KeyEventHandler KeyUp;
        event ControlEventHandler GotFocus;
        event ControlEventHandler LostFocus;
        event ControlEventHandler VisibleChanged;
        event ControlEventHandler SelectedChanged;
    }
}