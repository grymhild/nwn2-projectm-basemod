using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace NWN2CC
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            using (MainWindow mainwindow = new MainWindow())
            {
                Application.Run(mainwindow);
            }           
        }
        

    }
}
