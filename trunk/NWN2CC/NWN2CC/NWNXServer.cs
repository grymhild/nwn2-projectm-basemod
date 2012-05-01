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
        private static Process nwn2server, nwnx_controller;
        private static IntPtr nwn2ServerWnd = IntPtr.Zero;
        private static bool isModuleLoaded = false;
        private static bool isLoginReady = false;
        private static string localIP = GetLocalIPAddress();
        private static System.Net.Sockets.TcpClient tcpClient = new System.Net.Sockets.TcpClient();

        public delegate void UpdateProgress(string str, float percent);
        public static event UpdateProgress Update;

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);

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
        
        public static IntPtr GetNWN2ServerHwnd()
        {
            return FindWindow("Exo - BioWare Corp., (c) 1999 - Generic Blank Application", IntPtr.Zero);            
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
            //TODO: launch nwn2main
            string ipAddress = NWNXServer.GetLocalIPAddress();
            //TODO: set the Direct Connect IP = ipAddress, set Direct Connect Password to empty string
            //TODO: save pregamegui.ini backup and replace with provided pregamegui.ini
            

            Process nwn2main = new Process();
            nwn2main.StartInfo.FileName = NWN2Paths.NWN2MainPath + "\\nwlauncher.exe";
            nwn2main.StartInfo.UseShellExecute = false;
            nwn2main.EnableRaisingEvents = true;
            nwn2main.Exited += new EventHandler(nwn2main_Exited);
            nwn2main.Start();

            //TODO: trigger event to main window so as to hide NWN2CC window
        }

        private static void bw_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            
        }

        private static void nwn2main_Exited(object sender, EventArgs e)
        {
            //StopNWNX();

            //TODO: trigger event to MainWindow to 
            //restore NWN2CC window to main menu screen when nwn2main exits
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
            while (true)
            {
                System.Threading.Thread.Sleep(100);                
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
                
                double v1 = pf.NextValue();
                System.Threading.Thread.Sleep(1000);
                double v2 = pf.NextValue();
                double cpuload = (v1 + v2) / 2.0;//get 2nd processor value. Minimum of two samples needed w/ a wait between each.
                tick++;
                if (cpuload < 20.0 && tick > 10)
                {
                    WriteUpdate("Server is Idle, Ready for login...", 0.9f);
                    isLoginReady = true;
                    LaunchNWN2Main();
                    break;
                }
                else
                {
                    if (tick == 10)
                        WriteUpdate("Querying CPU load...", 0.75f);
                    System.Threading.Thread.Sleep(1000);
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
        }
    }
}
