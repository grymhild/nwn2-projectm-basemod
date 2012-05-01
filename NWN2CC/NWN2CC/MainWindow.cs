using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using AvengersUTD.Odyssey.UserInterface.RenderableControls;
using AvengersUTD.Odyssey.UserInterface;
using AvengersUTD.Odyssey.UserInterface.Helpers;
using Font = Microsoft.DirectX.Direct3D.Font;
using System.Reflection;
using Microsoft.DirectX.AudioVideoPlayback;
using System.Diagnostics;

namespace NWN2CC
{
    public partial class MainWindow : System.Windows.Forms.Form
    {
        private Device device;
        private Texture mainBackground;
        private Texture quitMsgBkgrd, btnSmTextureNormal, btnSmTextureHover, btnSmTexturePressed;

        MainMenu mainMenu;
        NewGameMenu newGameMenu;
        NewCampaignScreen newCampaignScreen;
        ModuleLoadScreen moduleLoadScreen;
        Movies creditsMovies;
        private bool usefullscreen = false;
        private HUD hud;
        private Font buttonFont, textFont;
        const int SCREEN_WIDTH = 1024;
        const int SCREEN_HEIGHT = 768;
        private PictureBox pbMain;
        
        public bool closing = false;        

        public MainWindow()
        {
            CustomCursor.LoadCustomCursor("defaultCursor", Resources.GetEmbeddedResource("NWN2CC.Assets.nwn2main_1.cur"));
            CustomCursor.LoadCustomCursor("downCursor", Resources.GetEmbeddedResource("NWN2CC.Assets.nwn2main_2.cur"));
            CustomCursor.LoadCustomCursor("waitCursor", Resources.GetEmbeddedResource("NWN2CC.Assets.nwn2main_131.cur"));

            InitializeComponent();
            
            this.SetStyle(System.Windows.Forms.ControlStyles.AllPaintingInWmPaint | System.Windows.Forms.ControlStyles.Opaque, true);
            Cursor = CustomCursor.GetCursor("defaultCursor");
            UI.SetupHooks(this);
            
            InitializeDevice();
            creditsMovies = new Movies(device, this.ClientSize.Width, this.ClientSize.Height, @"C:\Users\0100010\Documents\Visual Studio 2010\Projects\NWN2CC\NWN2CC\Assets\Credits_NX2.avi");
            creditsMovies.Stopped += new Movies.StoppedEventHandler(creditsMovies_Stopped);
        }

        void creditsMovies_Stopped()
        {
            this.Invalidate();
        }

        private void LoadAssets()
        {
            buttonFont = FontManager.FontFromStream("TitleB 10", Resources.GetEmbeddedResource("NWN2CC.Assets.NWN2_TitleB.ttf"), 10f, FontStyle.Bold);
            FontManager.FontFromStream("TitleB 18", Resources.GetEmbeddedResource("NWN2CC.Assets.NWN2_TitleB.ttf"), 18f, FontStyle.Bold);
            textFont = FontManager.FontFromStream("Main 10", Resources.GetEmbeddedResource("NWN2CC.Assets.NWN2_Main.ttf"), 10f, FontStyle.Bold);
            AssetManager.Device = device;

            AssetManager.LoadTextureFromStream("b_main_normal", Resources.GetEmbeddedResource("NWN2CC.Assets.b_main_normal.tga"));
            AssetManager.LoadTextureFromStream("b_main_hover", Resources.GetEmbeddedResource("NWN2CC.Assets.b_main_hover.tga"));
            AssetManager.LoadTextureFromStream("b_main_hover_pressed", Resources.GetEmbeddedResource("NWN2CC.Assets.b_main_hover_pressed.tga"));
            AssetManager.LoadTextureFromStream("main_background_nx3", Resources.GetEmbeddedResource("NWN2CC.Assets.main_background_nx3.tga"));

            AssetManager.LoadTextureFromStream("quitwindow", Resources.GetEmbeddedResource("NWN2CC.Assets.quitwindow.tga"));
            AssetManager.LoadTextureFromStream("b_sm_normal", Resources.GetEmbeddedResource("NWN2CC.Assets.b_sm_normal.tga"));
            AssetManager.LoadTextureFromStream("b_sm_hover", Resources.GetEmbeddedResource("NWN2CC.Assets.b_sm_hover.tga"));
            AssetManager.LoadTextureFromStream("b_sm_hover_pressed", Resources.GetEmbeddedResource("NWN2CC.Assets.b_sm_hover_pressed.tga"));

            AssetManager.LoadTextureFromStream("b_main_sm_normal", Resources.GetEmbeddedResource("NWN2CC.Assets.b_main_sm_normal.tga"));
            AssetManager.LoadTextureFromStream("b_main_sm_hover", Resources.GetEmbeddedResource("NWN2CC.Assets.b_main_sm_hover.tga"));
            AssetManager.LoadTextureFromStream("b_main_sm_hover_pressed", Resources.GetEmbeddedResource("NWN2CC.Assets.b_main_sm_hover_pressed.tga"));
            AssetManager.LoadTextureFromStream("main_sub_bg_nx3", Resources.GetEmbeddedResource("NWN2CC.Assets.main_sub_bg_nx3.tga"));
            AssetManager.LoadTextureFromStream("main_sub_titles", Resources.GetEmbeddedResource("NWN2CC.Assets.main_sub_titles.tga"));
            AssetManager.LoadTextureFromStream("main_module_image_nx3", Resources.GetEmbeddedResource("NWN2CC.Assets.main_module_image_nx3.tga"));
            AssetManager.LoadTextureFromStream("module_list", Resources.GetEmbeddedResource("NWN2CC.Assets.module_list.tga"));
            AssetManager.LoadTextureFromStream("module_desc", Resources.GetEmbeddedResource("NWN2CC.Assets.module_desc.tga"));

            AssetManager.LoadTextureFromStream("b_g_lg04_normal", Resources.GetEmbeddedResource("NWN2CC.Assets.b_g_lg04_normal.tga"));
            AssetManager.LoadTextureFromStream("b_g_lg04_pressed", Resources.GetEmbeddedResource("NWN2CC.Assets.b_g_lg04_pressed.tga"));

            AssetManager.LoadTextureFromStream("sb_handle", Resources.GetEmbeddedResource("NWN2CC.Assets.sb_handle.tga"));
            AssetManager.LoadTextureFromStream("sb_u_normal", Resources.GetEmbeddedResource("NWN2CC.Assets.sb_u_normal.tga"));
            AssetManager.LoadTextureFromStream("sb_u_hover", Resources.GetEmbeddedResource("NWN2CC.Assets.sb_u_hover.tga"));
            AssetManager.LoadTextureFromStream("sb_u_hover_pressed", Resources.GetEmbeddedResource("NWN2CC.Assets.sb_u_hover_pressed.tga"));
            AssetManager.LoadTextureFromStream("sb_d_normal", Resources.GetEmbeddedResource("NWN2CC.Assets.sb_d_normal.tga"));
            AssetManager.LoadTextureFromStream("sb_d_hover", Resources.GetEmbeddedResource("NWN2CC.Assets.sb_d_hover.tga"));
            AssetManager.LoadTextureFromStream("sb_d_hover_pressed", Resources.GetEmbeddedResource("NWN2CC.Assets.sb_d_hover_pressed.tga"));

            AssetManager.LoadTextureFromStream("generic_base", Resources.GetEmbeddedResource("NWN2CC.Assets.generic_base.tga"));
            AssetManager.LoadTextureFromStream("loading_bar_fill", Resources.GetEmbeddedResource("NWN2CC.Assets.loading_bar_fill.tga"));

            mainBackground = AssetManager.GetTexture("main_background_nx3");
            quitMsgBkgrd = AssetManager.GetTexture("quitwindow");
            btnSmTextureNormal = AssetManager.GetTexture("b_sm_normal");
            btnSmTextureHover = AssetManager.GetTexture("b_sm_hover");
            btnSmTexturePressed = AssetManager.GetTexture("b_sm_hover_pressed");
        }

        public void InitializeDevice()
        {
            PresentParameters presentParams = new PresentParameters();
            if (usefullscreen)
            {
                presentParams.BackBufferWidth = this.ClientSize.Width;
                presentParams.BackBufferHeight = this.ClientSize.Height;
                presentParams.BackBufferFormat = Format.R5G6B5;
                presentParams.Windowed = false;                
            }
            else
            {
                presentParams.Windowed = true;                            
            }
            presentParams.SwapEffect = SwapEffect.Discard;

            device = new Device(0, DeviceType.Hardware, this, CreateFlags.SoftwareVertexProcessing, presentParams);
            UI.Device = device;
            device.DeviceReset += new EventHandler(OnDeviceReset);            

            hud = new HUD("hud1", new Size(SCREEN_WIDTH, SCREEN_HEIGHT));
            UI.CurrentHud = hud;
            UI.CurrentHud.CanRaiseEvents = true;
            LoadAssets();
            mainMenu = new MainMenu(hud);            
            mainMenu.ButtonPress += new MainMenu.ButtonEventHandler(mainMenu_ButtonPress);
            newGameMenu = new NewGameMenu(hud);
            newGameMenu.ButtonPress += new NewGameMenu.ButtonEventHandler(mainMenu_ButtonPress);
            newCampaignScreen = new NewCampaignScreen(hud);
            newCampaignScreen.ButtonPress += new BaseScreen.ButtonEventHandler(mainMenu_ButtonPress);
            moduleLoadScreen = new ModuleLoadScreen(hud);

            pbMain = new PictureBox("main_background", new Vector2(0f, 0f), new Size(1024, 768), mainBackground);
            
            hud.BeginDesign();                                                
            hud.Add(pbMain);            
            hud.EndDesign();            
        }

        void mainMenu_ButtonPress(string buttonID)
        {
            Console.WriteLine("btn was clicked");
            if (buttonID == "Exit Game")
                ShowQuitToDesktopMessage();
            else if (buttonID == "New Game")
            {
                mainMenu.Close();
                newGameMenu.Show();
            }
            else if (buttonID == "NewGameCancel")
            {
                newGameMenu.Close();
                mainMenu.Show();
            }
            else if (buttonID == "Credits")
                creditsMovies.PlayMovies();
            else if (buttonID == "New Campaign")
            {
                newGameMenu.Close();
                newCampaignScreen.Show();
            }
            else if (buttonID == "New Module")
            {
                List<CampaignData> campaign = CampaignData.Campaigns;

            }
            else if (buttonID == "Start Campaign")
            {
                string startModuleName = newCampaignScreen.SelectedModuleName;
                newCampaignScreen.Close();
                moduleLoadScreen.Show();
                Cursor = CustomCursor.GetCursor("waitCursor");
                LaunchModule(startModuleName, 0);
            }
            else if (buttonID == "NewCampaignCancel")
            {
                newCampaignScreen.Close();
                newGameMenu.Show();
            }
        }        

        private void LaunchModule(string startModule, int savedGameSlot)
        {           
            NWNXServer.LaunchNWNX(startModule, savedGameSlot);
                                                     
            
        }                   

        private void creditsMovie_Ending(object sender, EventArgs e)
        {
            StopMovie();            
        }

        private void QuitDeskTopResult(BaseControl sender, DialogResult dialogResult)
        {
            if (dialogResult == AvengersUTD.Odyssey.UserInterface.RenderableControls.DialogResult.Ok)
            {
                NWNXServer.StopNWNX();                              
                Close();
            }
        }

        protected override void OnMouseDown(System.Windows.Forms.MouseEventArgs e)
        {
            Cursor = CustomCursor.GetCursor("downCursor");
            StopMovie();
            base.OnMouseDown(e);
        }

        protected override void OnMouseUp(System.Windows.Forms.MouseEventArgs e)
        {            
            Cursor = CustomCursor.GetCursor("defaultCursor");
            base.OnMouseUp(e);
        }

        protected override void OnKeyPress(System.Windows.Forms.KeyPressEventArgs e)
        {
            StopMovie();
            base.OnKeyPress(e);
        }

        protected override void OnPaint(System.Windows.Forms.PaintEventArgs e)
        {
            try
            {
                if (creditsMovies == null || !creditsMovies.IsPlaying)
                {
                    device.Clear(ClearFlags.Target, Color.Black, 1.0f, 0);
                    device.BeginScene();
                    UI.CurrentHud.Render();
                    device.EndScene();
                    device.Present();
                    this.Invalidate();
                }
            }
            catch {}
        }

        private void OnDeviceReset(object sender, EventArgs e)
        {
            //buttontexture = TextureLoader.FromFile(device, "b_main_normal.tga");
        }

        private void MainWindow_FormClosing(object sender, System.Windows.Forms.FormClosingEventArgs e)
        {
            NWNXServer.StopNWNX();
            Process.GetCurrentProcess().Kill(); 
        }


        private void ShowQuitToDesktopMessage()
        {
            DialogBoxParameters dbParms = new DialogBoxParameters();
            dbParms.ShowCaptionBar = false;
            dbParms.DialogPos = new Vector2(352, 343);
            dbParms.DialogSize = new System.Drawing.Size(320, 82);
            dbParms.BkgrdTexture = quitMsgBkgrd;
            dbParms.MessageFont = textFont;

            dbParms.BtnOKPos = new Vector2(31, 49);
            dbParms.BtnOKFont = buttonFont;
            dbParms.BtnOKText = "OK";
            dbParms.BtnOKTextColor = Color.FromArgb(255, 219, 231, 242);
            dbParms.BtnOKSize = new System.Drawing.Size(124, 28);
            dbParms.BtnOKNormalTexture = btnSmTextureNormal;
            dbParms.BtnOKHoverTexture = btnSmTextureHover;
            dbParms.BtnOKPressedTexture = btnSmTexturePressed;

            dbParms.BtnCancelPos = new Vector2(165, 49);
            dbParms.BtnCancelFont = buttonFont;
            dbParms.BtnCancelText = "Cancel";
            dbParms.BtnCancelTextColor = Color.FromArgb(255, 219, 231, 242);
            dbParms.BtnCancelSize = new System.Drawing.Size(124, 28);
            dbParms.BtnCancelNormalTexture = btnSmTextureNormal;
            dbParms.BtnCancelHoverTexture = btnSmTextureHover;
            dbParms.BtnCancelPressedTexture = btnSmTexturePressed;

            DialogBox.Show("quit", "Quit to Desktop?", DialogBoxButtons.OkCancel, dbParms, QuitDeskTopResult);   
        }


        private void MainWindow_Load(object sender, EventArgs e)
        {
            mainMenu.Show();
        }

        private void StopMovie()
        {
            if (creditsMovies != null)
            {
                creditsMovies.StopMovies();
                this.Invalidate();
            }
        }      
    }
}
