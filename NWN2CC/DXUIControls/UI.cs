using System.Threading;
using System.Windows.Forms;
using AvengersUTD.Odyssey.UserInterface.RenderableControls;
using Microsoft.DirectX.Direct3D;

namespace AvengersUTD.Odyssey.UserInterface
{
    public static class UI
    {
        static HUD currentHUD;
        static Device device;

        public static System.Windows.Forms.Control WinControl;

        public static Device Device
        {
            get { return device; }
            set { device = value; }
        }

        public static HUD CurrentHud
        {
            get { return currentHUD; }
            set { currentHUD = value; }
        }

        public static void MouseMovementHandler(object sender, MouseEventArgs e)
        {
            bool handled = false;

            // Checks whether a control has captured the mouse pointer
            if (currentHUD.CaptureControl != null)
            {
                currentHUD.CaptureControl.ProcessMouseMovement(e);
                return;
            }

            // Check whether a modal window is displayed
            if (currentHUD.WindowManager.Foremost != null && currentHUD.WindowManager.Foremost.IsModal)
            {
                foreach (BaseControl control in currentHUD.WindowManager.Foremost.PostOrderVisible)
                {
                    handled = control.ProcessMouseMovement(e);
                    if (handled)
                        return;
                }
                return;
            }
            

            // Proceeds with the rest
            foreach (BaseControl control in currentHUD.PostOrderVisible)
            {
                handled = control.ProcessMouseMovement(e);
                if (handled)
                    break;
            }
            if (!handled)
                currentHUD.ProcessMouseMovement(e);
        }

        public static void ProcessMouseInputPress(object sender, MouseEventArgs e)
        {
            bool handled = false;

            // Checks whether a modal window is displayed
            if (currentHUD.WindowManager.Foremost != null && currentHUD.WindowManager.Foremost.IsModal)
            {
                foreach (BaseControl control in currentHUD.WindowManager.Foremost.PostOrderVisible)
                {
                    handled = control.ProcessMousePress(e);
                    if (handled)
                        return;
                }
                return;
            }

            // Proceeds with the rest
            foreach (BaseControl control in currentHUD.PostOrderVisible)
            {
                handled = control.ProcessMousePress(e);
                if (handled)
                    break;
            }

            if (!handled)
                currentHUD.ProcessMousePress(e);
        }

        public static void ProcessMouseInputRelease(object sender, MouseEventArgs e)
        {
            bool handled = false;

            // Checks whether a control has captured the mouse pointer
            if (currentHUD.CaptureControl != null)
            {
                currentHUD.CaptureControl.ProcessMouseRelease(e);
                return;
            }

            // Checks whether a modal window is displayed
            if (currentHUD.WindowManager.Foremost != null && currentHUD.WindowManager.Foremost.IsModal)
            {
                foreach (BaseControl control in currentHUD.WindowManager.Foremost.PostOrderVisible)
                {
                    handled = control.ProcessMouseRelease(e);
                    if (handled)
                        return;
                }
                return;
            }

            // Proceeds with the rest
            foreach (BaseControl control in currentHUD.PostOrderVisible)
            {
                handled = control.ProcessMouseRelease(e);
                if (handled)
                    break;
            }

            if (!handled)
                currentHUD.ProcessMouseRelease(e);
        }

        public static void ProcessKeyDown(object sender, KeyEventArgs e)
        {
            if (currentHUD.FocusedControl != null)
                currentHUD.FocusedControl.ProcessKeyDown(e);
        }

        public static void ProcessKeyPress(object sender, KeyPressEventArgs e)
        {
            if (currentHUD.FocusedControl != null)
                currentHUD.FocusedControl.ProcessKeyPress(e);
        }

        public static void SetupHooks(Control Target)
        {
            Thread.CurrentThread.Name = "UI Thread";
            WinControl = Target;
            Target.KeyDown += new
                System.Windows.Forms.KeyEventHandler(ProcessKeyDown);
            Target.KeyPress += new
                KeyPressEventHandler(ProcessKeyPress);
            Target.MouseDown += new
                System.Windows.Forms.MouseEventHandler(ProcessMouseInputPress);
            Target.MouseUp += new
                System.Windows.Forms.MouseEventHandler(ProcessMouseInputRelease);
            Target.MouseMove += new
                System.Windows.Forms.MouseEventHandler(MouseMovementHandler);
        }

        #region Configurable Settings

        public static MouseButtons ClickButton
        {
            get
            {
                if (SystemInformation.MouseButtonsSwapped) return MouseButtons.Right;
                else return MouseButtons.Left;
            }
        }

        #endregion
    }
}