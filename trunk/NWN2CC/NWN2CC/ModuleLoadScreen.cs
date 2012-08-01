using System;
using System.Collections.Generic;
using System.Drawing;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using AvengersUTD.Odyssey.UserInterface.RenderableControls;
using AvengersUTD.Odyssey.UserInterface;
using Font = Microsoft.DirectX.Direct3D.Font;
using System.IO;

namespace NWN2CC
{
    public class ModuleLoadScreen : BaseScreen
    {
        Texture bkgrdTexture, fillTexture;
        Label lbl1, lbl2, lbl3;
        Font titleFont, labelFont;
        ProgressBar pb;
        
        public ModuleLoadScreen(ContainerControl owner) : base(owner)       
        {
            titleFont = FontManager.GetFont("TitleB 18");
            labelFont = FontManager.GetFont("Main 10");
            bkgrdTexture = AssetManager.GetTexture("generic_base");
            fillTexture = AssetManager.GetTexture("loading_bar_fill");
            NWNXServer.Update += AppendInfoString;           
        }

        public override void Show()
        {
            myWindow = new Window("ModuleLoadScreen", "ModuleLoadScreen", new Vector2(0f, 0f), new Size(1024, 768), ColorArray.Transparent, false);
            myWindow.BackgroundTexture = bkgrdTexture;
            UI.CurrentHud.BeginDesign();
            myOwner.Add(myWindow);

            Label title = new Label("lbl1", "Loading", new Vector2(454, 13), Color.White);
            title.Font = titleFont;
            myWindow.Add(title);

            lbl1 = new Label("lbl2", "                    ", new Vector2(16, 647), Color.FromArgb(255, 219, 231, 242));
            lbl1.Font = labelFont;
            lbl1.Outline = true;
            lbl1.OutlineColor = Color.Black;
            myWindow.Add(lbl1);

            lbl2 = new Label("lbl3", "                    ", new Vector2(16, 661), Color.FromArgb(255, 219, 231, 242));
            lbl2.Font = labelFont;
            lbl2.Outline = true;
            lbl2.OutlineColor = Color.Black;
            myWindow.Add(lbl2);

            lbl3 = new Label("lbl4", "                    ", new Vector2(16, 675), Color.FromArgb(255, 219, 231, 242));
            lbl3.Font = labelFont;
            lbl3.Outline = true;
            lbl3.OutlineColor = Color.Black;
            myWindow.Add(lbl3);

            pb = new ProgressBar("moduleloader", new Vector2(123, 711), new Size(766, 54));
            pb.BackgroundTexture = fillTexture;
            myWindow.Add(pb);

            myWindow.BringToFront();
            UI.CurrentHud.EndDesign();            
        }

        public void AppendInfoString(string infostr, float percent)
        {
            lbl1.Text = lbl2.Text;
            lbl2.Text = lbl3.Text;
            lbl3.Text = infostr;
            pb.ReportProgress(percent);
        }

    }

}
