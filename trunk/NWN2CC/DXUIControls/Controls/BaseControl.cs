using System;
using System.Drawing;
using System.Windows.Forms;
using AvengersUTD.Odyssey.UserInterface.Helpers;
using Microsoft.DirectX;

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{
    public abstract class BaseControl : IControl, IComparable<BaseControl>
    {
        protected BaseControl parent;

        protected Depth depth;
        protected int index;
        protected string id;

        protected bool isClickable = true;
        protected bool canRaiseEvents = true;
        protected bool hasCaptured = false;
        protected bool isSubComponent = false;
        protected bool isDisposing = false;

        protected bool isVisible = true;
        protected bool isEnabled = true;
        protected bool isClicked = false;
        protected bool isHighlighted = false;
        protected bool isSelected = false;
        protected bool isInside = false;
        protected bool isFocused = false;
        protected bool isFocusable = true;

        protected Vector2 position;
        protected Vector2 absolutePosition;
        protected Size size;

        #region Properties

        public string ID
        {
            get { return id; }
        }

        internal virtual Depth Depth
        {
            get { return depth; }
            set { depth = value; }
        }

        public int UserDepth
        {
            get { return depth.UserDepth; }
            set { depth.UserDepth = value; }
        }

        public int Index
        {
            get { return index; }
            set { index = value; }
        }

        public virtual bool IsClickable
        {
            get { return isClickable; }
            set { isClickable = value; }
        }

        public virtual bool CanRaiseEvents
        {
            get { return canRaiseEvents; }
            set { canRaiseEvents = value; }
        }

        public bool HasCaptured
        {
            get { return hasCaptured; }
            set { hasCaptured = value; }
        }

        public bool IsSubComponent
        {
            get { return isSubComponent; }
            set { isSubComponent = value; }
        }

        internal bool IsDisposing
        {
            get { return isDisposing; }
            set { isDisposing = value;}
        }


        public virtual bool IsVisible
        {
            get { return isVisible; }
            set
            {
                isVisible = value;
                OnVisibleChanged(this);
            }
        }

        public bool IsFocused
        {
            get { return isFocused; }
        }

        public bool IsFocusable
        {
            get { return isFocusable; }
            set { isFocusable = value; }
        }


        public bool IsEnabled
        {
            get { return isEnabled; }
            set { isEnabled = value; }
        }

        internal bool IsClicked
        {
            get { return isClicked; }
        }

        /// <summary>
        /// Returns true if the control can raise events and the pointer is inside the control's bounds.
        /// </summary>
        internal bool IsInside
        {
            get { return isInside && canRaiseEvents; }
        }

        public bool IsHighlighted
        {
            get { return isHighlighted; }
            set
            {
                if (isHighlighted != value)
                {
                    isHighlighted = value;
                    OnHighlightedChanged(this);
                }
            }
        }

        public bool IsSelected
        {
            get { return isSelected; }
            set
            {
                if (isSelected != value)
                {
                    isSelected = value;
                    OnSelectedChanged(this);
                }
            }
        }

        /// <summary>
        /// Gets or Sets the parent control. When a new parent control is set
        /// the absolute position of the child control is also computed.
        /// </summary>
        public virtual BaseControl Parent
        {
            get { return parent; }
            set
            {
                parent = value;
                OnPositionChanged(this);
            }
        }

        public virtual Vector2 Position
        {
            get { return position; }
            set
            {
                position = value;

                OnPositionChanged(this);
            }
        }

        public Vector2 AbsolutePosition
        {
            get { return absolutePosition; }
            set { absolutePosition = value; }
        }


        public virtual Size Size
        {
            get { return size; }
            set
            {
                size = value;
                OnSizeChanged(this);
            }
        }

        #endregion

        #region Events

        #region MouseEvents

        public event MouseEventHandler MouseDown;
        public event MouseEventHandler MouseClick;
        public event MouseEventHandler MouseUp;
        public event MouseEventHandler MouseEnter;
        public event MouseEventHandler MouseCaptureChanged;
        public event MouseEventHandler MouseLeave;
        public event MouseEventHandler MouseScroll;
        public event MouseEventHandler MouseMove;

        protected virtual void OnMouseMove(BaseControl ctl, MouseEventArgs ctlArgs)
        {
            if (MouseMove != null)
                MouseMove(ctl, ctlArgs);
        }

        protected virtual void OnMouseDown(BaseControl ctl, MouseEventArgs args)
        {
            isClicked = true;
            UI.CurrentHud.ClickedControl = this;

            UI.CurrentHud.WindowManager.BringToFront(depth.WindowLayer);

            DebugManager.LogToScreen(ID + " - " + ctl.ID);
            if (MouseDown != null)
                MouseDown(ctl, args);
        }

        protected virtual void OnMouseClick(BaseControl ctl, MouseEventArgs args)
        {
            if (MouseClick != null)
                MouseClick(ctl, args);
        }

        protected virtual void OnMouseUp(BaseControl ctl, MouseEventArgs args)
        {
            isClicked = false;
            UI.CurrentHud.ClickedControl = null;
            if (MouseUp != null)
                MouseUp(ctl, args);
        }

        protected virtual void OnMouseCaptureChanged(BaseControl ctl, MouseEventArgs args)
        {
            UI.CurrentHud.CaptureControl = null;
            isClicked = false;

            if (MouseCaptureChanged != null)
                MouseCaptureChanged(ctl, args);
        }

        protected virtual void OnMouseEnter(BaseControl ctl, MouseEventArgs args)
        {
            isInside = true;
            DebugManager.LogToScreen(
                DateTime.Now.Millisecond + " Entering " +
                id);

            if (UI.CurrentHud.EnteredControl.IsInside )
                UI.CurrentHud.EnteredControl.OnMouseLeave(this, args);
            UI.CurrentHud.EnteredControl = this;

            if (MouseEnter != null)
                MouseEnter(ctl, args);
        }

        protected virtual void OnMouseLeave(BaseControl ctl, MouseEventArgs args)
        {
            isInside = false;
            DebugManager.LogToScreen(
                DateTime.Now.Millisecond + " Leaving " +
                id);

            if (MouseLeave != null)
                MouseLeave(ctl, args);
        }

        protected virtual void OnMouseScroll(BaseControl ctl, MouseEventArgs args)
        {
            if (MouseScroll != null)
                MouseScroll(ctl, args);
        }

        #endregion

        #region Keyboard Events

        public event KeyEventHandler KeyDown;
        public event KeyPressEventHandler KeyPress;
        public event KeyEventHandler KeyUp;

        protected virtual void OnKeyDown(BaseControl ctl, KeyEventArgs args)
        {
            if (KeyDown != null)
                KeyDown(ctl, args);
        }

        protected virtual void OnKeyPress(BaseControl ctl, KeyPressEventArgs args)
        {
            if (KeyPress != null)
                KeyPress(ctl, args);
        }

        protected virtual void OnKeyUp(BaseControl ctl, KeyEventArgs args)
        {
            if (KeyUp != null)
                KeyUp(ctl, args);
        }

        #endregion

        #region Control Events

        public event ControlEventHandler GotFocus;
        public event ControlEventHandler LostFocus;
        public event ControlEventHandler VisibleChanged;
        public event ControlEventHandler SelectedChanged;
        public event ControlEventHandler SizeChanged;
        public event ControlEventHandler PositionChanged;
        public event ControlEventHandler HighlightedChanged;

        protected virtual void OnGotFocus(BaseControl ctl)
        {
            if (UI.CurrentHud.FocusedControl != null && ctl != UI.CurrentHud.FocusedControl)
            {
                UI.CurrentHud.FocusedControl.OnLostFocus(ctl);

                UI.CurrentHud.FocusedControl = this;
                isFocused = true;

                if (GotFocus != null)
                    GotFocus(ctl);
            }
            else return;
        }

        protected virtual void OnLostFocus(BaseControl ctl)
        {
            isFocused = isClicked = false;
            UI.CurrentHud.FocusedControl = UI.CurrentHud;

            if (LostFocus != null)
                LostFocus(ctl);
        }

        protected virtual void OnVisibleChanged(BaseControl ctl)
        {
            if (VisibleChanged != null)
                VisibleChanged(ctl);
        }

        protected virtual void OnSelectedChanged(BaseControl ctl)
        {
            if (SelectedChanged != null)
                SelectedChanged(ctl);
        }

        protected virtual void OnSizeChanged(BaseControl ctl)
        {
            if (SizeChanged != null)
                SizeChanged(ctl);
        }


        protected virtual void OnPositionChanged(BaseControl ctl)
        {
            ComputeAbsolutePosition();

            if (PositionChanged != null)
                PositionChanged(ctl);
        }

        protected virtual void OnHighlightedChanged(BaseControl ctl)
        {
            if (HighlightedChanged != null)
                HighlightedChanged(ctl);
        }

        #endregion

        #endregion

        public abstract bool IntersectTest(Point cursorLocation);

        public BaseControl(string id, Vector2 position, Size size)
        {
            this.id = id;
            this.position = position;
            this.size = size;
        }

        /// <summary>
        /// Computes the absolute position depending on the inherited position by the parent.
        /// This method is called when the parent property is set.
        /// </summary>
        public virtual void ComputeAbsolutePosition()
        {
            Object lockThis = new Object();

            if (parent != null)
            {
                absolutePosition = Vector2.Add(parent.AbsolutePosition, position);
            }
            else
                throw new ArgumentNullException("Parent of control: " + id + " is null!");
        }

        public bool IsChildControl(BaseControl ctl)
        {
            return depth.WindowLayer == ctl.depth.WindowLayer;
        }

        public void Focus()
        {
            UI.CurrentHud.FocusedControl.OnLostFocus(UI.CurrentHud.FocusedControl);
            OnGotFocus(this);
        }

        protected void LoseFocus(BaseControl toInvoke)
        {
            toInvoke.OnLostFocus(this);
        }

        public Window FindWindow()
        {
            if (depth.WindowLayer == 0)
                return null;
            else
                return UI.CurrentHud.WindowManager[depth.WindowLayer - 1];
        }

        #region Event Processing Methods

        public virtual bool ProcessMousePress(MouseEventArgs e)
        {
            if (canRaiseEvents && IntersectTest(e.Location) && isClickable)
            {
                if (e.Button == UI.ClickButton && !isClicked && isEnabled)
                {
                    OnMouseDown(this, e);

                    if (isFocusable)
                    {
                        if (!isFocused && UI.CurrentHud.FocusedControl != null)
                        {
                            UI.CurrentHud.FocusedControl.OnLostFocus(UI.CurrentHud.FocusedControl);
                        }

                        if (!isFocused)
                            OnGotFocus(this);
                    }
                }

                return true;
            }
            else
                return false;
        }

        public virtual bool ProcessMouseRelease(MouseEventArgs e)
        {
            if (canRaiseEvents && (hasCaptured || IntersectTest(e.Location)))
            {
                if (isClicked)
                {
                    if (e.Button != MouseButtons.None)
                        OnMouseClick(this, e);
                }
                OnMouseUp(this, e);
                return true;
            }
            else
            {
                return false;
            }
        }

        public virtual void ProcessKeyDown(KeyEventArgs e)
        {
            OnKeyDown(this, e);
        }

        public virtual void ProcessKeyPress(KeyPressEventArgs e)
        {
            OnKeyPress(this, e);
        }

        public virtual bool ProcessMouseMovement(MouseEventArgs e)
        {
            if (hasCaptured || IntersectTest(e.Location))
            {
                if (canRaiseEvents)
                {
                    if (!isInside)
                    {
                        OnMouseEnter(this, e);
                    }

                    if (e.Delta != 0)
                        OnMouseScroll(this, e);

                    OnMouseMove(this, e);
                }

                return true;
            }
            else
            {
                //if (isInside)
                //{
                //    OnMouseLeave(this, e);
                //}

                return false;
            }
        }

        #endregion

        #region IComparable<BaseControl> Members

        public int CompareTo(BaseControl other)
        {
            return depth.CompareTo(other.depth);
        }

        #endregion
    }
}