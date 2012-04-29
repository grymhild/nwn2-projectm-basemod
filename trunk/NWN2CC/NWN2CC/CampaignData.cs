using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Drawing;
using Font = Microsoft.DirectX.Direct3D.Font;
using Microsoft.DirectX.Direct3D;
using AvengersUTD.Odyssey.UserInterface;

namespace NWN2CC
{
    public class CampaignData
    {
        string displayName = "Campaign name not defined";
        string startModule = "";

        List<string> description = new List<string>();

        Dictionary<int, string> labelOffsets = new Dictionary<int, string>();
        Dictionary<int, uint> dataoffsets = new Dictionary<int, uint>();


        private static List<CampaignData> campaigns = GetCampaignData();

        public static List<CampaignData> Campaigns { get { return campaigns; } }

        private static List<CampaignData> GetCampaignData()
        {
            List<CampaignData> campaigns = new List<CampaignData>();
            
            //Get the OC campaigns
            string path = Path.Combine(NWN2Paths.NWN2MainPath, "Campaigns");
            DirectoryInfo campaignDir = new DirectoryInfo(path);
            foreach (DirectoryInfo subdir in campaignDir.GetDirectories())
            {
                path = Path.Combine(subdir.FullName, "Campaign.cam");
                FileInfo fi = new FileInfo(path);
                if (fi.Exists)
                {
                    CampaignData cd = new CampaignData(path);
                    if (cd.StartModule != "")
                        campaigns.Add(cd);
                }
            }

            //Get the Documents campaigns
            path = Path.Combine(NWN2Paths.NWN2DocumentsPath, "Campaigns");
            campaignDir = new DirectoryInfo(path);
            foreach (DirectoryInfo subdir in campaignDir.GetDirectories())
            {
                path = Path.Combine(subdir.FullName, "Campaign.cam");
                FileInfo fi = new FileInfo(path);
                if (fi.Exists)
                {
                    CampaignData cd = new CampaignData(path);
                    if (cd.StartModule != "")
                        campaigns.Add(cd);
                }
            }

            return campaigns;
        }


        private CampaignData(string campaignFilename)
        {
            FileInfo file = new FileInfo(campaignFilename);
            if (!file.Exists)
                throw new FileNotFoundException(campaignFilename + " not found.");
            
            FileStream fs = file.OpenRead();
            BinaryReader br = new BinaryReader(fs);
            try
            {                
                char[] chars = br.ReadChars(4);
                if (new string(chars) != "CAM ")
                    throw new Exception(campaignFilename + " is not of the appropriate CAM GFF file type.");

                br.BaseStream.Seek(12, SeekOrigin.Current);
                uint fieldOffset = br.ReadUInt32();
                uint fieldCount = br.ReadUInt32();
                uint labelOffset = br.ReadUInt32();
                uint labelCount = br.ReadUInt32();
                uint fieldDataOffset = br.ReadUInt32();
                ReadLabels(br, labelOffset, labelCount);                
                ReadFields(br, fieldOffset, fieldCount);
                ReadFieldData(br, fieldDataOffset);
            }
            catch (Exception ex)
            { 
                //TODO: handle the exception
            }
            finally
            {
                br.Close();
            }
        }

        public List<string> Description { get { return description; } }
        public string DisplayName { get { return displayName; } }
        public string StartModule { get { return startModule; } }

        private void ReadLabels(BinaryReader br, uint labelOffset, uint labelCount)
        {
            br.BaseStream.Seek(labelOffset, SeekOrigin.Begin);
            for (int i = 0; i < labelCount; i++)
            {
                char[] chars = br.ReadChars(16);                
                string label = new string(chars).Trim('\0');
                if (label == "Description" || label == "StartModule" || label == "DisplayName")
                {
                    if (!labelOffsets.ContainsValue(label))
                    {
                        labelOffsets.Add(i, label);
                        if (labelOffsets.Count == 3)
                            return;
                    }
                    else
                        throw new Exception("Unexpected duplicate label in campaign file: " + label);
                }
            }
            throw new Exception("Insuficient labels found in Campaign file, Count: " + labelOffsets.Count);
        }

        private void ReadFields(BinaryReader br, uint fieldOffset, uint fieldCount)
        {
            br.BaseStream.Seek(fieldOffset, SeekOrigin.Begin);            
            for (int i = 0; i < fieldCount; i++)
            {
                uint fieldType = br.ReadUInt32();
                uint labelindex = br.ReadUInt32();
                uint dataOrDataOffset = br.ReadUInt32();
                if (labelOffsets.ContainsKey((int)labelindex))
                {
                    dataoffsets.Add((int)labelindex, dataOrDataOffset);
                    if (dataoffsets.Count == 3)
                        return;
                }
            }
            throw new Exception("Insuficient matching fields found in Campaign file, Count: " + dataoffsets.Count);
        }

        private void ReadFieldData(BinaryReader br, uint fieldDataOffset)
        {
            foreach (KeyValuePair<int, uint> kvp in dataoffsets)
            {
                br.BaseStream.Seek(fieldDataOffset + kvp.Value, SeekOrigin.Begin);
                if (labelOffsets[kvp.Key] == "StartModule")
                {
                    uint size = br.ReadUInt32();
                    char[] chars = br.ReadChars((int)size);
                    startModule = new string(chars);
                }
                else if (labelOffsets[kvp.Key] == "Description")
                {
                    string desc = ReadExoLocString(br);
                    if (desc != "")
                        description = GetFormattedDescription(desc);
                    else
                        description.Add("No Campaign Description available.");
                }
                else
                {
                    string name = ReadExoLocString(br);
                    if (name != "")
                        displayName = name;
                }
            }
        }

        private string ReadExoLocString(BinaryReader br)
        {
            string str = "";
            br.ReadUInt32();
            uint strRef = br.ReadUInt32();
            uint strCount = br.ReadUInt32();
            if (strCount > 0)
            {
                br.ReadUInt32(); //Read the ID
                int size = br.ReadInt32();
                char[] chars = br.ReadChars(size);
                str = new string(chars);
            }
            else
            {
                if (strRef != UInt32.MaxValue)                    
                {   //Get the String from the dialog.tlk file.                
                    string path = Path.Combine(NWN2Paths.NWN2MainPath, "dialog.tlk");
                    FileInfo file = new FileInfo(path);
                    FileStream fs = file.OpenRead();
                    BinaryReader br2 = new BinaryReader(fs);
                    br2.BaseStream.Seek(16, SeekOrigin.Begin);
                    int strEntriesOffset = br2.ReadInt32();                    
                    br2.BaseStream.Seek(20 + (strRef * 40) + 28, SeekOrigin.Begin);
                    int offset = br2.ReadInt32();
                    int size = br2.ReadInt32();
                    br2.BaseStream.Seek(offset + strEntriesOffset, SeekOrigin.Begin);
                    char[] chars = br2.ReadChars(size);
                    str = new string(chars);
                    br2.Close();
                }
            }                
            return str;
        }

        private List<string> GetFormattedDescription(string rawDescription)
        {
            string[] lines = rawDescription.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.None);
            List<string> descriptionLines = new List<string>();
            string text = "WWWWWWWWWWWWWWWWWWWWWWWW ";
            Font font = FontManager.GetFont("Main 10");
            DrawTextFormat dtf = DrawTextFormat.ExpandTabs | DrawTextFormat.WordBreak | DrawTextFormat.Left | DrawTextFormat.Top;
            Rectangle area = font.MeasureString(UI.CurrentHud.SpriteManager, text, dtf, Color.White);
            int width = area.Width;

            foreach (string line in lines)
            {
                string[] words = line.Split(' ');
                string linetext = "";
                for (int i = 0; i < words.Length; i++)
                {
                    string addword = words[i] + (i == words.Length - 1 ? "" : " ");
                    if ((linetext + addword).Length > 25)
                    {
                        Rectangle a = font.MeasureString(UI.CurrentHud.SpriteManager, linetext + addword, dtf, Color.White);
                        if (a.Width > width)
                        {   //Wrap
                            descriptionLines.Add(linetext);
                            linetext = "";
                        }
                    }
                    linetext += addword;
                }
                descriptionLines.Add(linetext);
            }

            return descriptionLines;
        }
    }
}
