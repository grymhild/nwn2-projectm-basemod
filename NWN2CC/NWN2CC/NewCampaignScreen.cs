using System;
using System.Collections.Generic;
using System.Drawing;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using AvengersUTD.Odyssey.UserInterface.RenderableControls;
using AvengersUTD.Odyssey.UserInterface;
using Font = Microsoft.DirectX.Direct3D.Font;

namespace NWN2CC
{
    public class NewCampaignScreen : BaseScreen
    {
        Texture bkgrdTexture, subtitleTexture, mainModuleImage, moduleListImage, moduleDescImage, modulebtnNormal, modulebtnPressed;
        Texture sbuNormal, sbuHover, sbuPressed, sbdNormal, sbdHover, sbdPressed, sbHandle;
        Font titleFont;
        bool left_sb_handle_down, right_sb_handle_down;
        Button priorBtn;
        RichTextArea descriptionText;

        List<CampaignData> campaigns = CampaignData.Campaigns;
        int rightScrollPartitions = 0;
        int leftscrollPartitions = 0;
        int currentlySelectedModule = -1;
        int ModuleButtonOffset = 0;

        public string SelectedModuleName { get { return campaigns[currentlySelectedModule].StartModule; } }

        public NewCampaignScreen(ContainerControl owner) : base(owner)       
        {
            buttonFont = FontManager.GetFont("TitleB 10");
            titleFont = FontManager.GetFont("TitleB 18");
            btnTextureNormal = AssetManager.GetTexture("b_main_sm_normal");
            btnTextureHover = AssetManager.GetTexture("b_main_sm_hover");
            btnTexturePressed = AssetManager.GetTexture("b_main_sm_hover_pressed");
            bkgrdTexture = AssetManager.GetTexture("main_sub_bg_nx3");
            subtitleTexture = AssetManager.GetTexture("main_sub_titles");
            mainModuleImage = AssetManager.GetTexture("main_module_image_nx3");
            moduleListImage = AssetManager.GetTexture("module_list");
            moduleDescImage = AssetManager.GetTexture("module_desc");

            modulebtnNormal = AssetManager.GetTexture("b_g_lg04_normal");
            modulebtnPressed = AssetManager.GetTexture("b_g_lg04_pressed");

            sbuNormal = AssetManager.GetTexture("sb_u_normal");
            sbuHover = AssetManager.GetTexture("sb_u_hover");
            sbuPressed = AssetManager.GetTexture("sb_u_hover_pressed");
            sbdNormal = AssetManager.GetTexture("sb_d_normal");
            sbdHover = AssetManager.GetTexture("sb_d_hover");
            sbdPressed = AssetManager.GetTexture("sb_d_hover_pressed");
            sbHandle = AssetManager.GetTexture("sb_handle");

            leftscrollPartitions = campaigns.Count - 7;

            UI.WinControl.MouseUp += new System.Windows.Forms.MouseEventHandler(WinControl_MouseUp);
            UI.WinControl.MouseMove += new System.Windows.Forms.MouseEventHandler(WinControl_MouseMove);
        }

        void WinControl_MouseMove(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            CheckScrollBarHandleMouseMove(e);
        }

        void WinControl_MouseUp(object sender, System.Windows.Forms.MouseEventArgs e)
        {
            left_sb_handle_down = false;
            right_sb_handle_down = false;
        }

        public override void Show()
        {
            myWindow = new Window("NewCampaignScreen", "NewCampaignScreen", new Vector2(0f, 0f), new Size(1024, 768), ColorArray.Transparent, false);
            myWindow.BackgroundTexture = bkgrdTexture;
            UI.CurrentHud.BeginDesign();
            myOwner.Add(myWindow);
            myWindow.BringToFront();
            myWindow.CanRaiseEvents = true;
            myWindow.MouseClick += new MouseEventHandler(myWindow_MouseClick);
            Panel p1 = new Panel("p1", new Vector2(0, 703), new Size(1024, 21), Shape.Rectangle, BorderStyle.None);
            myWindow.Add(p1);
            Panel p2 = new Panel("p2", new Vector2(0, 758), new Size(1024, 10), Shape.Rectangle, BorderStyle.None);
            myWindow.Add(p2);
            Panel p3 = new Panel("p3", new Vector2(0, 723), new Size(50, 35), Shape.Rectangle, BorderStyle.None);
            myWindow.Add(p3);
            Panel p4 = new Panel("p4", new Vector2(214, 723), new Size(596, 35), Shape.Rectangle, BorderStyle.None);
            myWindow.Add(p4);
            Panel p5 = new Panel("p5", new Vector2(0, 723), new Size(50, 35), Shape.Rectangle, BorderStyle.None);
            myWindow.Add(p5);

            PictureBox subtitle = new PictureBox("subtitle", new Vector2(20, 0), new Size(984, 74), subtitleTexture);
            myWindow.Add(subtitle);
            Label title = new Label("lbl1", "Select Campaign", new Vector2(400, 13), Color.White);
            title.Font = titleFont;
            myWindow.Add(title);

            PictureBox moduleImg = new PictureBox("moduleImage", new Vector2(22, 87), new Size(980, 287), mainModuleImage);
            myWindow.Add(moduleImg);
            
            Label listTitle = new Label("lbl2", "Select Campaign", new Vector2(487, 391), Color.FromArgb(255, 219, 231, 242));            
            listTitle.Font = buttonFont;
            listTitle.Outline = true;
            listTitle.OutlineColor = Color.Black;
            myWindow.Add(listTitle); 
            listTitle.Position = new Vector2(600 - listTitle.Size.Width, listTitle.Position.Y);
                       
            Label descTitle = new Label("lbl3", "Info", new Vector2(955, 391), Color.FromArgb(255, 219, 231, 242));
            descTitle.Font = buttonFont;
            descTitle.Outline = true;
            descTitle.OutlineColor = Color.Black;
            myWindow.Add(descTitle);
            descTitle.Position = new Vector2(980 - descTitle.Size.Width, descTitle.Position.Y);
            
            int btnCount = Math.Min(campaigns.Count, 7);
            for (int i = 0; i < btnCount; i++)            
                AddButton("mb_" + i.ToString(), campaigns[i].DisplayName, 26, 421 + i * 39, 570, 36, buttonFont, modulebtnNormal, modulebtnNormal, modulebtnNormal);

            AddButton("sb_u_left", "", 601, 419, 15, 22, buttonFont, sbuNormal, sbuHover, sbuPressed);
            AddButton("sb_d_left", "", 601, 683, 15, 22, buttonFont, sbdNormal, sbdHover, sbdPressed);
            AddButton("sb_handle_left", "", 601, 440, 15, 22, buttonFont, sbHandle, sbHandle, sbHandle);
            AddButton("sb_u_right", "", 984, 419, 15, 22, buttonFont, sbuNormal, sbuHover, sbuPressed);
            AddButton("sb_d_right", "", 984, 683, 15, 22, buttonFont, sbdNormal, sbdHover, sbdPressed);
            AddButton("sb_handle_right", "", 984, 440, 15, 22, buttonFont, sbHandle, sbHandle, sbHandle);

            TextStyle ts = new TextStyle(false, false, LabelSize.Small, Color.White);
            descriptionText = new RichTextArea("description_text", new Vector2(633, 412), new Size(351, 288), "_\n_\n_\n_\n_\n_\n_\n_\n_\n_\n_\n_\n_\n_\n_\n_\n_\n_", ts, BorderStyle.None, ColorArray.Transparent);            
            descriptionText.Font = FontManager.GetFont("Main 10");
            BaseControl ctl = UI.CurrentHud.Find("mb_0");
            btn1_MouseUp(ctl, null);
            myWindow.Add(descriptionText);
            AddButton("NewCampaignCancel", "Cancel", 50f, 723f, 164, 35, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);            
            AddButton("Start Campaign", "Start Campaign", 810f, 723f, 164, 35, buttonFont, btnTextureNormal, btnTextureHover, btnTexturePressed);

            UI.CurrentHud.EndDesign();
        }

        private void CheckScrollBarHandleMouseMove(System.Windows.Forms.MouseEventArgs args)
        {
            BaseControl handle = null;
            if (left_sb_handle_down)
                handle = UI.CurrentHud.Find("sb_handle_left");
            else if (right_sb_handle_down)
                handle = UI.CurrentHud.Find("sb_handle_right");

            if (handle != null && args.Button == System.Windows.Forms.MouseButtons.Left)
            {
                if (right_sb_handle_down && rightScrollPartitions > 0)
                    MoveRightScrollHandle(handle, args.Y);
                else if (left_sb_handle_down && leftscrollPartitions > 0)
                    MoveLeftScrollHandle(handle, args.Y);
            }            
        }

        private void MoveRightScrollHandle(BaseControl handle, int newY)
        {
            if (rightScrollPartitions < 1)
                return;
            MoveScrollHandle(handle, newY);
            if (newY < 440) newY = 440;
            if (newY > 666) newY = 666;
            int i = Int32.Parse(priorBtn.ID.Substring(3));
            List<string> desc = campaigns[ModuleButtonOffset + i].Description;
            int pixelsperpartition = 226 / (rightScrollPartitions + 1);
            int linestart = (newY - 440) / pixelsperpartition;
            if (newY - 440 >= pixelsperpartition * (rightScrollPartitions + 1))
                linestart -= 1;
            descriptionText.Text = desc.GetRange(linestart, Math.Min(18, desc.Count - linestart));
        }

        private void MoveLeftScrollHandle(BaseControl handle, int newY)
        {
            if (leftscrollPartitions < 1)
                return;
            MoveScrollHandle(handle, newY);
            if (newY < 440) newY = 440;
            if (newY > 666) newY = 666;
            int pixelsperpartition = 226 / (leftscrollPartitions + 1);
            ModuleButtonOffset = (newY - 440) / pixelsperpartition;
            if (newY - 440 >= pixelsperpartition * (leftscrollPartitions + 1))
                ModuleButtonOffset -= 1;

            for (int i = 0; i < 7; i++)
            {
                Button btn = (Button)UI.CurrentHud.Find("mb_" + i.ToString());
                int index = ModuleButtonOffset + i;
                if (index > campaigns.Count)
                    index = campaigns.Count - 1;
                btn.Label = campaigns[index].DisplayName;
                if (currentlySelectedModule - ModuleButtonOffset == i)
                {
                    btn.TextureNormal = modulebtnPressed;
                    btn.TextureHover = modulebtnPressed;
                    btn.TexturePressed = modulebtnPressed;
                }
                else
                {
                    btn.TextureNormal = modulebtnNormal;
                    btn.TextureHover = modulebtnNormal;
                    btn.TexturePressed = modulebtnNormal;
                }
            }
        }

        private void ClickScrollBarUpDownButtons(string id)
        {                        
            int direction = 1;
            if (id.StartsWith("sb_u"))
                direction = -1;
            if (id.EndsWith("right"))
            {
                if (rightScrollPartitions >= 0)
                {
                    int pixelsperpartition = 226 / (rightScrollPartitions + 1);
                    BaseControl handle = UI.CurrentHud.Find("sb_handle_right");
                    MoveRightScrollHandle(handle, (int)handle.Position.Y + pixelsperpartition * direction + 11);
                }
            }
            else
            {
                if (leftscrollPartitions >= 0)
                {
                    int pixelsperpartition = 226 / (leftscrollPartitions + 1);
                    BaseControl handle = UI.CurrentHud.Find("sb_handle_left");
                    MoveLeftScrollHandle(handle, (int)handle.Position.Y + pixelsperpartition * direction + 11);
                }
            }
        }

        private void MoveScrollHandle(BaseControl handle, int newY)
        {
            UI.CurrentHud.BeginDesign();
            int Y = newY - 11;
            if (Y < 440) Y = 440;
            if (Y > 666) Y = 666;
            handle.Position = new Vector2(handle.Position.X, Y);
            UI.CurrentHud.EndDesign();
        }

        private void myWindow_MouseClick(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {
            BaseControl handle = null;
            if (args.X >= 602 && args.X < 616 && args.Y >= 439 && args.Y < 683)
            {
                handle = UI.CurrentHud.Find("sb_handle_left");                
                MoveLeftScrollHandle(handle, args.Y);
            }
            else if (args.X >= 980 && args.X < 994 && args.Y >= 439 && args.Y < 683)
            {
                handle = UI.CurrentHud.Find("sb_handle_right");                
                MoveRightScrollHandle(handle, args.Y);                
            }
        }

        protected override void btn1_MouseDown(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {
            string id = ctl.ID;
            if (id == "sb_handle_left")
                left_sb_handle_down = true;
            else if (id == "sb_handle_right")
                right_sb_handle_down = true;
        }

        protected override void btn1_MouseUp(BaseControl ctl, System.Windows.Forms.MouseEventArgs args)
        {
            string id = ctl.ID;
            if (id.StartsWith("mb_"))
            {                
                Button selectedBtn = (ctl as Button);
                int selectedModule = ModuleButtonOffset + Int32.Parse(ctl.ID.Substring(3));
                if (selectedModule != currentlySelectedModule)
                {
                    for (int i = 0; i < 7; i++)
                    {
                        Button btn = (Button)UI.CurrentHud.Find("mb_" + i.ToString());                    
                        btn.TextureNormal = modulebtnNormal;
                        btn.TextureHover = modulebtnNormal;
                        btn.TexturePressed = modulebtnNormal;
                    }  
              
                    selectedBtn.TextureNormal = modulebtnPressed;
                    selectedBtn.TextureHover = modulebtnPressed;
                    selectedBtn.TexturePressed = modulebtnPressed;
                    
                    priorBtn = (Button)ctl;                    
                    ModuleButtonClick(ctl);
                }
            }
            else if (id.StartsWith("sb_"))
            {
                ClickScrollBarUpDownButtons(id);
            }
            else
                base.btn1_MouseUp(ctl, args);
        }

        private void ModuleButtonClick(BaseControl ctl)
        {
            int i = Int32.Parse(ctl.ID.Substring(3));
            List<string> desc = campaigns[ModuleButtonOffset + i].Description;
            currentlySelectedModule = ModuleButtonOffset + i;
            rightScrollPartitions = desc.Count - 17;
            descriptionText.Text = desc.GetRange(0, Math.Min(18, desc.Count));
            BaseControl handle = UI.CurrentHud.Find("sb_handle_right");
            handle.Position = new Vector2(handle.Position.X, 440);           
        }

        public override void Close()
        {                        
            base.Close();             
        }
    }
}
