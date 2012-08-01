using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.IO;
using System.ComponentModel;
using System.Net;
using System.Reflection;

namespace NWN2CC
{
    public abstract class NWNXServer
    {
        private static Process nwn2server, nwnx_controller, nwn2main;
        private static IntPtr nwn2ServerWnd = IntPtr.Zero;
        private static IntPtr nwn2mainWnd = IntPtr.Zero;
        private static IntPtr clientExtensionWnd = IntPtr.Zero;
        public static IntPtr nwn2CCWnd = IntPtr.Zero;
        private static bool isModuleLoaded = false;
        private static bool isLoginReady = false;
        private static string localIP = GetLocalIPAddress();
        private static System.Net.Sockets.TcpClient tcpClient = new System.Net.Sockets.TcpClient();

        public delegate void UpdateProgress(string str, float percent);
        public static event UpdateProgress Update;

        public delegate void NWN2HasExited();
        public static event NWN2HasExited NWN2Exit;

        public delegate void NWN2HasLoaded();
        public static event NWN2HasLoaded NWN2Loaded;

        public static MainWindow nwn2CC = null;

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool ShowWindow(IntPtr hWnd, WindowShowStyle nCmdShow);

        [DllImport("user32.dll")]
        static extern IntPtr SetParent(IntPtr hWndChild, IntPtr hWndNewParent);

        private enum WindowStyles : uint
        {
            WS_BORDER = 0x800000,

            /// <summary>The window has a title bar (includes the WS_BORDER style).</summary>
            WS_CAPTION = 0xc00000,

            /// <summary>The window is a child window. A window with this style cannot have a menu bar. This style cannot be used with the WS_POPUP style.</summary>
            WS_CHILD = 0x40000000,

            /// <summary>Excludes the area occupied by child windows when drawing occurs within the parent window. This style is used when creating the parent window.</summary>
            WS_CLIPCHILDREN = 0x2000000,

            /// <summary>
            /// Clips child windows relative to each other; that is, when a particular child window receives a WM_PAINT message, the WS_CLIPSIBLINGS style clips all other overlapping child windows out of the region of the child window to be updated.
            /// If WS_CLIPSIBLINGS is not specified and child windows overlap, it is possible, when drawing within the client area of a child window, to draw within the client area of a neighboring child window.
            /// </summary>
            WS_CLIPSIBLINGS = 0x4000000,

            /// <summary>The window is initially disabled. A disabled window cannot receive input from the user. To change this after a window has been created, use the EnableWindow function.</summary>
            WS_DISABLED = 0x8000000,

            /// <summary>The window has a border of a style typically used with dialog boxes. A window with this style cannot have a title bar.</summary>
            WS_DLGFRAME = 0x400000,

            /// <summary>
            /// The window is the first control of a group of controls. The group consists of this first control and all controls defined after it, up to the next control with the WS_GROUP style.
            /// The first control in each group usually has the WS_TABSTOP style so that the user can move from group to group. The user can subsequently change the keyboard focus from one control in the group to the next control in the group by using the direction keys.
            /// You can turn this style on and off to change dialog box navigation. To change this style after a window has been created, use the SetWindowLong function.
            /// </summary>
            WS_GROUP = 0x20000,

            /// <summary>The window has a horizontal scroll bar.</summary>
            WS_HSCROLL = 0x100000,

            /// <summary>The window is initially maximized.</summary>
            WS_MAXIMIZE = 0x1000000,

            /// <summary>The window has a maximize button. Cannot be combined with the WS_EX_CONTEXTHELP style. The WS_SYSMENU style must also be specified.</summary>
            WS_MAXIMIZEBOX = 0x10000,

            /// <summary>The window is initially minimized.</summary>
            WS_MINIMIZE = 0x20000000,

            /// <summary>The window has a minimize button. Cannot be combined with the WS_EX_CONTEXTHELP style. The WS_SYSMENU style must also be specified.</summary>
            WS_MINIMIZEBOX = 0x20000,

            /// <summary>The window is an overlapped window. An overlapped window has a title bar and a border.</summary>
            WS_OVERLAPPED = 0x0,

            /// <summary>The window is an overlapped window.</summary>
            WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_SIZEFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX,

            /// <summary>The window is a pop-up window. This style cannot be used with the WS_CHILD style.</summary>
            WS_POPUP = 0x80000000u,

            /// <summary>The window is a pop-up window. The WS_CAPTION and WS_POPUPWINDOW styles must be combined to make the window menu visible.</summary>
            WS_POPUPWINDOW = WS_POPUP | WS_BORDER | WS_SYSMENU,

            /// <summary>The window has a sizing border.</summary>
            WS_SIZEFRAME = 0x40000,

            /// <summary>The window has a window menu on its title bar. The WS_CAPTION style must also be specified.</summary>
            WS_SYSMENU = 0x80000,

            /// <summary>
            /// The window is a control that can receive the keyboard focus when the user presses the TAB key.
            /// Pressing the TAB key changes the keyboard focus to the next control with the WS_TABSTOP style.  
            /// You can turn this style on and off to change dialog box navigation. To change this style after a window has been created, use the SetWindowLong function.
            /// For user-created windows and modeless dialogs to work with tab stops, alter the message loop to call the IsDialogMessage function.
            /// </summary>
            WS_TABSTOP = 0x10000,

            /// <summary>The window is initially visible. This style can be turned on and off by using the ShowWindow or SetWindowPos function.</summary>
            WS_VISIBLE = 0x10000000,

            /// <summary>The window has a vertical scroll bar.</summary>
            WS_VSCROLL = 0x200000
        }

        private enum WindowShowStyle : uint
        {
            Hide = 0,
            ShowNormal = 1,
            ShowMinimized = 2,
            ShowMaximized = 3,
            Maximize = 3,
            ShowNormalNoActivate = 4,
            Show = 5,
            Minimize = 6,
            ShowMinNoActivate = 7,
            ShowNoActivate = 8,
            Restore = 9,
            ShowDefault = 10,
            ForceMinimized = 11
        }

        public enum ButtonControlMessages : uint
        {
            BM_GETCHECK = 0x00F0,
            BM_SETCHECK = 0x00F1,
            BM_GETSTATE = 0x00F2,
            BM_SETSTATE = 0x00F3,
            BM_SETSTYLE = 0x00F4,
            BM_CLICK = 0x00F5,
            BM_GETIMAGE = 0x00F6,
            BM_SETIMAGE = 0x00F7
        }

        [DllImport("user32.dll")]
        private static extern IntPtr GetDlgItem(IntPtr hDlg, int nIDDlgItem);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool IsWindowEnabled(IntPtr hWnd);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        private static extern IntPtr FindWindow(string strClassName, IntPtr nptWindowName);

        [DllImport("user32.dll", SetLastError = true)]
        static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

        public enum ExtendedWindowStyles
        {
            // ...
            WS_EX_TOOLWINDOW = 0x00000080,
            // ...
        }
        
        enum WindowLongFlags : int
        {
            GWL_EXSTYLE = -20,
            GWLP_HINSTANCE = -6,
            GWLP_HWNDPARENT = -8,
            GWL_ID = -12,
            GWL_STYLE = -16,
            GWL_USERDATA = -21,
            GWL_WNDPROC = -4,
            DWLP_USER = 0x8,
            DWLP_MSGRESULT = 0x0,
            DWLP_DLGPROC = 0x4
        }


        //[DllImport("user32.dll")]
        //public static extern IntPtr GetWindowLong(IntPtr hWnd, int nIndex);

        [DllImport("User32.dll")]
        static extern bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw);

        public static IntPtr SetWindowLong(IntPtr hWnd, int nIndex, IntPtr dwNewLong)
        {
            int error = 0;
            IntPtr result = IntPtr.Zero;
            // Win32 SetWindowLong doesn't clear error on success
            SetLastError(0);

            if (IntPtr.Size == 4)
            {
                // use SetWindowLong
                Int32 tempResult = IntSetWindowLong(hWnd, nIndex, IntPtrToInt32(dwNewLong));
                error = Marshal.GetLastWin32Error();
                result = new IntPtr(tempResult);
            }
            else
            {
                // use SetWindowLongPtr
                result = IntSetWindowLongPtr(hWnd, nIndex, dwNewLong);
                error = Marshal.GetLastWin32Error();
            }

            if ((result == IntPtr.Zero) && (error != 0))
            {
                throw new System.ComponentModel.Win32Exception(error);
            }

            return result;
        }

        //Sets window attributes
        [DllImport("USER32.DLL")]
        public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

        //Gets window attributes
        [DllImport("USER32.DLL")]
        public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

        public static long GWL_EXSTYLE = -20;
        public static long WS_EX_APPWINDOW = 0x00040000L; 
        public static int GWL_STYLE = -16;
        public static int WS_CHILD = 0x40000000; //child window
        public static int WS_BORDER = 0x00800000; //window with border
        public static int WS_DLGFRAME = 0x00400000; //window with double border but no title
        public static int WS_CAPTION = WS_BORDER | WS_DLGFRAME; //window with a title bar

        //public void WindowsReStyle()
        //{
        //    Process[] Procs = Process.GetProcesses();
        //    foreach (Process proc in Procs)
        //    {
        //        if (proc.ProcessName.StartsWith("notepad"))
        //        {
        //            IntPtr pFoundWindow = proc.MainWindowHandle;
        //            int style = IntPtrToInt32(GetWindowLong(pFoundWindow, GWL_STYLE));
        //            SetWindowLong(pFoundWindow, GWL_STYLE, (style & ~WS_CAPTION));
        //        }
        //    }
        //}



        [DllImport("user32.dll", EntryPoint = "SetWindowLongPtr", SetLastError = true)]
        private static extern IntPtr IntSetWindowLongPtr(IntPtr hWnd, int nIndex, IntPtr dwNewLong);

        [DllImport("user32.dll", EntryPoint = "SetWindowLong", SetLastError = true)]
        private static extern Int32 IntSetWindowLong(IntPtr hWnd, int nIndex, Int32 dwNewLong);

        private static int IntPtrToInt32(IntPtr intPtr)
        {
            return unchecked((int)intPtr.ToInt64());
        }

        [DllImport("kernel32.dll", EntryPoint = "SetLastError")]
        public static extern void SetLastError(int dwErrorCode);



        private static IntPtr GetNWN2ServerHwnd()
        {
            return FindWindow("Exo - BioWare Corp., (c) 1999 - Generic Blank Application", IntPtr.Zero);            
        }

        private static IntPtr GetNWLauncherHwnd()
        {
            return FindWindow("ConsoleWindowClass", "NWN2 Client Extension Console");
        }

        public static bool IsServerModuleLoaded()
        {
            return isModuleLoaded;
        }

        public static bool IsLoginReady()
        { 
            return isLoginReady; 
        }

        public static void WriteUpdate(string str, float percent)
        {
            if (Update != null)
                Update(str, percent);
            Console.WriteLine(str);
        }

        public static void LaunchNWNX(string moduleName, int savedGameSlot)
        {
            FileInfo fi;
            if (savedGameSlot <= 1)
            {
                fi = new FileInfo(Path.Combine(NWN2Paths.NWN2DocumentsPath + "\\modules", moduleName + ".mod"));
                DirectoryInfo di = new DirectoryInfo(Path.Combine(NWN2Paths.NWN2DocumentsPath + "\\modules", moduleName));
                if (!fi.Exists && di.Exists)
                    moduleName = "-moduledir " + moduleName;
                else if (fi.Exists && !di.Exists)
                    moduleName = "-module " + moduleName;
                else
                {   //Test install directories for campaigns and mods
                    fi = new FileInfo(Path.Combine(NWN2Paths.NWN2MainPath + "\\modules", moduleName + ".mod"));
                    if (fi.Exists)
                        moduleName = "-module " + moduleName;
                }
                if (!fi.Exists && !di.Exists)
                {   //Problem locating module
                    WriteUpdate("Could not find module: " + moduleName, 0);
                    return;
                }
            }
            else
                moduleName = "-load " + savedGameSlot.ToString();

            string processorToUse = (Environment.ProcessorCount > 1 ? "1" : "0");
            string parms = "parameters = -home \"" + NWN2Paths.NWN2DocumentsPath + "\" " + moduleName +
                " -publicserver 0 -pauseandplay 1 -ilr 0 -elc 0 -maxlevel 40 -minlevel 1 -cpu " + processorToUse + " -oneparty 1 -difficulty 3 -pvp 1 -maxclients 96 ";

            fi = new FileInfo(Path.Combine(Directory.GetCurrentDirectory(), "NWNX\\nwnx.ini"));
            if (fi.Exists) fi.Delete();
            StreamWriter sw = fi.CreateText();
            sw.WriteLine("nwn2 = " + NWN2Paths.NWN2MainPath);
            sw.WriteLine(parms);
            sw.WriteLine("processWatchdog = 0");
            sw.WriteLine("gamespyWatchdog = 0");
            sw.Flush();
            sw.Close();

            WriteUpdate("Starting NWNXServer...", .05f);

            BackgroundWorker bw = new BackgroundWorker();
            bw.WorkerSupportsCancellation = true;
            bw.DoWork += new DoWorkEventHandler(bw_DoWork);
            bw.RunWorkerCompleted += new RunWorkerCompletedEventHandler(bw_RunWorkerCompleted);

            bw.RunWorkerAsync();
        }

        private static void StartNWNX()
        {            
            StopNWNX(); //if it was already started we want a clean instance so kill the old one.
            nwnx_controller = new Process();
            nwnx_controller.StartInfo.FileName = Path.Combine(Directory.GetCurrentDirectory(), "NWNX\\NWNX4_Controller.exe");
            nwnx_controller.StartInfo.CreateNoWindow = true;
            nwnx_controller.StartInfo.Arguments = "-interactive -hidden";
            nwnx_controller.StartInfo.UseShellExecute = false;
            nwnx_controller.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            nwnx_controller.StartInfo.RedirectStandardInput = true;
            nwnx_controller.Start();                                   
        }

        private static void LaunchNWN2Main()
        {
            string ipAddress = NWNXServer.GetLocalIPAddress();
            //TODO: set the Direct Connect IP = ipAddress, set Direct Connect Password to empty string in nwn2player.ini            
            Process nwLauncher = new Process();
            nwLauncher.StartInfo.FileName = NWN2Paths.NWN2MainPath + "\\nwLauncher.exe";
            nwLauncher.Start();            
            //TODO: trigger event to main window so as to hide NWN2CC window
        }

        private static void bw_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            
        }

        private static void nwn2main_Exited(object sender, EventArgs e)
        {            
            StopNWNX();
            if (NWN2Exit != null)
                NWN2Exit();            
        } 

        private static void WriteStreamToFile(Stream inputStream, string outPutFile)
        {
            byte[] bytes = new byte[inputStream.Length];
            inputStream.Read(bytes, 0, (int)inputStream.Length);
            FileStream fs = new FileStream(outPutFile, FileMode.Create);
            fs.Write(bytes, 0, bytes.Length);
            fs.Flush();
            fs.Close();
        }

        private static void CreateGUIFiles()
        {
            DirectoryInfo di = new DirectoryInfo(NWN2Paths.NWN2DocumentsPath + "\\ui");
            if (!di.Exists) di.Create();
            string filepath = NWN2Paths.NWN2DocumentsPath + "\\ui\\default";
            di = new DirectoryInfo(filepath);
            if (!di.Exists) di.Create();

            //Write the needed UI files.
            Stream fs = Resources.GetEmbeddedResource("NWN2CC.Assets.pregameguix2.ini");
            WriteStreamToFile(fs, filepath + "\\pregameguix2.ini");
            fs = Resources.GetEmbeddedResource("NWN2CC.Assets.cc.xml");
            WriteStreamToFile(fs, filepath + "\\cc.xml");
            fs = Resources.GetEmbeddedResource("NWN2CC.Assets.csx3.xml");
            WriteStreamToFile(fs, filepath + "\\csx3.xml");
            fs = Resources.GetEmbeddedResource("NWN2CC.Assets.dcx3.xml");
            WriteStreamToFile(fs, filepath + "\\dcx3.xml");
            fs = Resources.GetEmbeddedResource("NWN2CC.Assets.mmx3.xml");
            WriteStreamToFile(fs, filepath + "\\mmx3.xml");
        }

        private static void bw_DoWork(object sender, DoWorkEventArgs e)
        {
            DateTime stageTime = DateTime.Now;
            int tick = 0;
            PerformanceCounter pf = null;
            StartNWNX();
            int sleeptime = 100;
            while (true)
            {
                System.Threading.Thread.Sleep(sleeptime);                
                if (nwn2server == null)
                {
                    Process[] processes = Process.GetProcessesByName("nwn2server");
                    if (processes.Length > 0)
                    {
                        nwn2server = processes[0];
                        Console.WriteLine("nwn2server process detected");
                        nwnx_controller.StandardInput.WriteLine(" ");
                        nwnx_controller.WaitForExit();
                        stageTime = DateTime.Now;
                        pf = new PerformanceCounter("Process", "% Processor Time", nwn2server.ProcessName);                        
                    }
                    else
                        continue;
                }
                
                if (nwn2ServerWnd == IntPtr.Zero)
                {
                    nwn2ServerWnd = GetNWN2ServerHwnd();
                    if (nwn2ServerWnd != IntPtr.Zero)
                    {
                        WriteUpdate("Module is loading...", 0.25f);
                        stageTime = DateTime.Now;
                    }
                    else
                    {
                        TimeSpan ts = (DateTime.Now - stageTime);
                        if (ts.TotalSeconds > 5)
                        {
                            Console.WriteLine("Failed to find window handle. Restarting NWNXServer.");
                            StartNWNX();
                        }
                        continue;
                    }
                }

                if (!isModuleLoaded)
                {
                    IntPtr saveBtn = GetDlgItem(nwn2ServerWnd, 1029);
                    if (IsWindowEnabled(saveBtn))
                    {
                        isModuleLoaded = true;
                        WriteUpdate("Module loaded. OnModuleLoad running...", 0.5f);
                        CreateGUIFiles();
                    }
                    else
                        continue;
                }

                if (!isLoginReady)
                {
                    double v1 = pf.NextValue();
                    System.Threading.Thread.Sleep(900);
                    double v2 = pf.NextValue();
                    double cpuload = (v1 + v2) / 2.0;//get 2nd processor value. Minimum of two samples needed w/ a wait between each.
                    tick++;
                    if (cpuload < 20.0 && tick > 10) //wait at least 10 seconds before querying since it takes about that load just to get ramped up
                    {
                        WriteUpdate("Server is Idle, Ready for login...", 0.9f);
                        isLoginReady = true;
                        LaunchNWN2Main();
                        sleeptime = 10;
                    }
                    else
                    {
                        if (tick == 10)
                            WriteUpdate("Querying CPU load...", 0.75f);
                        System.Threading.Thread.Sleep(1000);
                        continue;
                    }                    
                }

                if (nwn2main == null)
                {
                    Process[] processes = Process.GetProcessesByName("nwn2main");
                    if (processes.Length > 0)
                    {
                        nwn2main = processes[0];
                        Console.WriteLine("nwn2main process detected");
                        nwn2main.EnableRaisingEvents = true;
                        nwn2main.Exited += new EventHandler(nwn2main_Exited);
                        WriteUpdate("NWN2Main is loading...", 0.95f);
                    }
                    else
                        continue;
                }                

                if (nwn2mainWnd == IntPtr.Zero)
                {
                    System.Threading.Thread.Sleep(2000);
                    nwn2mainWnd = nwn2main.MainWindowHandle;
                    if (nwn2mainWnd != IntPtr.Zero)
                    {
                        clientExtensionWnd = GetNWLauncherHwnd();
                        if (clientExtensionWnd != IntPtr.Zero)
                            ShowWindow(clientExtensionWnd, WindowShowStyle.Hide);
                        Console.WriteLine("nwn2main window handle found.");
                       
                        //SetParent(nwn2mainWnd, nwn2CCWnd);
                        //SetWindowLong(nwn2mainWnd, GWL_STYLE, 0x10000000);
                        //MoveWindow(nwn2mainWnd, 0, 0, nwn2CC.ClientRectangle.Width, nwn2CC.ClientRectangle.Height, true);

                        if (NWN2Loaded != null)
                            NWN2Loaded();
                    }
                    else
                        continue;
                }

                if (clientExtensionWnd == IntPtr.Zero)
                {
                    clientExtensionWnd = GetNWLauncherHwnd();
                    if (clientExtensionWnd != IntPtr.Zero)
                    {
                        ShowWindow(clientExtensionWnd, WindowShowStyle.Hide);
                        Console.WriteLine("client extension window handle  found.");
                        break;
                    }
                    else
                        continue;
                }

            }
        }

        public static string GetLocalIPAddress()
        {
            IPAddress[] IpA = Dns.GetHostAddresses(Dns.GetHostName());
            for (int i = 0; i < IpA.Length; i++)
            {
                if (IpA[i].AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                    return IpA[i].ToString();
            }
            return null;
        }

        public static void StopNWNX()
        {       
            string filepath = NWN2Paths.NWN2DocumentsPath+  "\\ui\\default\\";
            FileInfo fi = new FileInfo(filepath + "pregameguix2.ini");
            if (fi.Exists) fi.Delete();
            fi = new FileInfo(filepath + "cc.xml");
            if (fi.Exists) fi.Delete();
            fi = new FileInfo(filepath + "csx3.xml");
            if (fi.Exists) fi.Delete();
            fi = new FileInfo(filepath + "dcx3.xml");
            if (fi.Exists) fi.Delete();
            fi = new FileInfo(filepath + "mmx3.xml");
            if (fi.Exists) fi.Delete();

            Process[] processes = Process.GetProcessesByName("nwn2server");
            foreach (Process s in processes)
            {
                try { s.Kill(); }
                catch { }
            }

            nwn2server = null;
            isModuleLoaded = false;
            isLoginReady = false;
            nwn2main = null;
            nwn2ServerWnd = IntPtr.Zero;
            clientExtensionWnd = IntPtr.Zero;
            nwn2mainWnd = IntPtr.Zero;
        }
    }
}
