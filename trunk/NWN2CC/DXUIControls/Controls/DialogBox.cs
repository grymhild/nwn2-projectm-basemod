using System;
using System.Drawing;
using AvengersUTD.Odyssey.UserInterface.Style;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using System.Windows.Forms;
using System.Threading;
using Font = Microsoft.DirectX.Direct3D.Font;

namespace AvengersUTD.Odyssey.UserInterface.RenderableControls
{
    public enum DialogBoxButtons
    {
        Ok,
        OkCancel,
        YesNo
    }

    public enum DialogResult
    {
        None,
        Ok,
        Cancel,
        Yes,
        No
    }


    public delegate void DialogResultEventHandler(BaseControl sender, DialogResult dialogResult);

    public class DialogBoxParameters
    {
        public Texture BkgrdTexture, BtnOKNormalTexture, BtnCancelNormalTexture, BtnOKHoverTexture, BtnCancelHoverTexture, BtnOKPressedTexture, BtnCancelPressedTexture;
        public Font BtnOKFont, BtnCancelFont, MessageFont, TitleFont;
        public Vector2 DialogPos, BtnOKPos, BtnCancelPos;
        public string BtnOKText, BtnCancelText;
        public Color BtnOKTextColor, BtnCancelTextColor;
        public bool ShowCaptionBar;
        public Size BtnOKSize, BtnCancelSize, DialogSize;
    }

    public class DialogBox : Window
    {
        DialogBoxParameters myParams;

        public event DialogResultEventHandler DialogResultAvailable;

        DialogResult dialogResult;
        DialogResult closeBehavior;

        Button btnOK, btnCancel;
        Panel btnContainer;

        DialogBox(string title, DialogBoxParameters dbParams, string text, DialogBoxButtons buttons): base(
            string.Format("{0}_Dialog{1}",title, UI.CurrentHud.WindowManager.Count),
            title, dbParams.DialogPos, dbParams.DialogSize, defaultColors, dbParams.ShowCaptionBar)

        {
            isModal = true;
            myParams = dbParams;
            if (myParams.ShowCaptionBar)
            {
                containerPanel.Size = new Size(containerPanel.Size.Width, containerPanel.Size.Height - dbParams.BtnOKSize.Height - 5);
                captionBar.CloseButton.MouseClick +=
                    delegate(BaseControl ctl, MouseEventArgs args)
                    {
                        dialogResult = closeBehavior;
                        OnDialogResultAvailable(this, dialogResult);
                    };
            }
            else
            {
                containerPanel.Position = new Vector2();
                containerPanel.Size = new Size(myParams.DialogSize.Width, myParams.DialogSize.Height - (int)myParams.BtnOKPos.Y);
                borderStyle = UserInterface.BorderStyle.None;
                containerPanel.BorderStyle = UserInterface.BorderStyle.None;
            }

            BackgroundTexture = myParams.BkgrdTexture;
            TextStyle ts = new TextStyle(true, false, false, Color.White, Color.White, 16, "NWN2_TitleB", Alignment.Center, Alignment.Center);
            RichTextArea rta = new RichTextArea(title + "_Rta", new Vector2(0, 0), containerPanel.Size, text, ts);

            if (myParams.MessageFont != null)
                rta.Font = myParams.MessageFont;
             Add(rta);
            
            switch (buttons)
            {
                default:
                case DialogBoxButtons.Ok:
                    closeBehavior = DialogResult.Ok;
                    AddOKButton(new MouseEventHandler(ReturnOk));                    
                    break;
                case DialogBoxButtons.OkCancel:
                    closeBehavior = DialogResult.Cancel;
                    AddOKButton(new MouseEventHandler(ReturnOk));
                    AddCancelButton(new MouseEventHandler(ReturnCancel));                    
                    break;
                case DialogBoxButtons.YesNo:
                    closeBehavior = DialogResult.No;
                    AddOKButton(new MouseEventHandler(ReturnYes));
                    AddCancelButton(new MouseEventHandler(ReturnNo));                    
                    break;
            }
        }

        public static void Show(string title, string text, DialogBoxButtons buttons, DialogResultEventHandler eventHandler)
        {
            DialogBoxParameters dbParams = new DialogBoxParameters();
            Size hudSize = UI.CurrentHud.Size;
            dbParams.DialogSize = new Size(500, 250);
            dbParams.DialogPos = new Vector2(hudSize.Width / 2 - dbParams.DialogSize.Width / 2, hudSize.Height / 2 - dbParams.DialogSize.Height / 2);            
            dbParams.BtnOKSize = new Size(90, 30);
            dbParams.BtnCancelSize = new Size(90, 30);
            dbParams.ShowCaptionBar = true;
            dbParams.BtnOKTextColor = Color.White;
            dbParams.BtnCancelTextColor = Color.White;

            if (buttons == DialogBoxButtons.YesNo)
            {
                dbParams.BtnOKText = "Yes";
                dbParams.BtnCancelText = "No";
            }
            else
            {
                dbParams.BtnOKText = "Ok";
                dbParams.BtnCancelText = "Cancel";
            }
            if (buttons == DialogBoxButtons.Ok)
                dbParams.BtnOKPos = new Vector2(394, 178);
            else
            {
                dbParams.BtnOKPos = new Vector2(299, 178);
                dbParams.BtnCancelPos = new Vector2(394, 178);
            }

            Show(title, text, buttons, dbParams, eventHandler);
        }


        public static void Show(string title, string text, DialogBoxButtons buttons, DialogBoxParameters dbParams, DialogResultEventHandler eventHandler)
        {
            HUD hud = UI.CurrentHud;
            hud.BeginDesign();
            DialogBox dialog = new DialogBox(title, dbParams, text, buttons);
            hud.Add(dialog);
            hud.WindowManager.BringToFront(dialog);
            hud.EndDesign();
            dialog.DialogResultAvailable += eventHandler;
        }

        private void AddOKButton(MouseEventHandler handler)
        {
            btnOK = new Button(string.Format("{0}Button", myParams.BtnOKText), myParams.BtnOKText, myParams.BtnOKPos, myParams.BtnOKSize);
            btnOK.MouseClick += handler;
            btnOK.TextureNormal = myParams.BtnOKNormalTexture;
            btnOK.TextureHover = myParams.BtnOKHoverTexture;
            btnOK.TexturePressed = myParams.BtnOKPressedTexture;
            btnOK.TextColor = myParams.BtnOKTextColor;
            if (myParams.BtnOKFont != null)
                btnOK.Font = myParams.BtnOKFont;
            btnOK.UserDepth = 2;
            Add(btnOK);            
        }

        private void AddCancelButton(MouseEventHandler handler)
        {
            btnCancel = new Button(string.Format("{0}Button", myParams.BtnCancelText), myParams.BtnCancelText, myParams.BtnCancelPos, myParams.BtnCancelSize);
            btnCancel.MouseClick += handler;
            btnCancel.TextureNormal = myParams.BtnCancelNormalTexture;
            btnCancel.TextureHover = myParams.BtnCancelHoverTexture;
            btnCancel.TexturePressed = myParams.BtnCancelPressedTexture;
            btnCancel.TextColor = myParams.BtnOKTextColor;
            if (myParams.BtnCancelFont != null)
                btnCancel.Font = myParams.BtnCancelFont;
            btnCancel.UserDepth = 2;
            Add(btnCancel);            
        }

        void ReturnOk(BaseControl ctl, MouseEventArgs args)
        {
            dialogResult = DialogResult.Ok;
            Close();
            OnDialogResultAvailable(this, dialogResult);
        }

        void ReturnCancel(BaseControl ctl, MouseEventArgs args)
        {
            dialogResult = DialogResult.Cancel;
            Close();
            OnDialogResultAvailable(this, dialogResult);
        }

        void ReturnYes(BaseControl ctl, MouseEventArgs args)
        {
            dialogResult = DialogResult.Yes;
            Close();
            OnDialogResultAvailable(this, dialogResult);
        }

        void ReturnNo(BaseControl ctl, MouseEventArgs args)
        {
            dialogResult = DialogResult.No;
            Close();
            OnDialogResultAvailable(this, dialogResult);
        }

        public virtual void OnDialogResultAvailable(BaseControl ctl, DialogResult dialogResult)
        {
            if (DialogResultAvailable!=null)
                DialogResultAvailable(ctl, dialogResult);
        }
        
    }
}